// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, use_key_in_widget_constructors

import 'dart:ui';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/Providers/Notificationprovider.dart';
import 'package:flutter_application_1/consts/language.dart';
import 'package:flutter_application_1/controller/paymentProvider.dart';
import 'package:flutter_application_1/controller/reelProvider.dart';
import 'package:flutter_application_1/controller/reportReelProvider.dart';
import 'package:flutter_application_1/controller/updateProfileProvider.dart';
import 'package:flutter_application_1/guide.dart';
import 'package:flutter_application_1/models/ChildModel.dart';
import 'package:flutter_application_1/pages/mainskeleton.dart';
import 'package:flutter_application_1/pages/mainskeletonchild.dart';
import 'package:flutter_application_1/services/chatSocket.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_application_1/services/notificationservices.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/user.dart';
import '../models/user.dart';
import 'package:o3d/o3d.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/Providers/Childsprovider.dart';
import 'package:flutter_application_1/pages/parentRegister.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_1/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final storage = FirebaseStorage.instance;
  // Request notification permission
  await _requestNotificationPermission();

  await ChatSocket.init();

  FirebaseMessaging messaging = FirebaseMessaging.instance;
   _setupLogging();
  // Get the token
  String? token = await messaging.getToken();
  print('FCM Token: $token');
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('tokendevice', token!);

  runApp(
    MaterialApp(
      // Provide necessary configurations here, such as theme, localizations, etc.
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ChildProvider()),
          ChangeNotifierProvider(create: (context) => NotificationProvider()),
          ChangeNotifierProvider(create: (context) => NotificationProvider()),
          ChangeNotifierProvider(
              create: (_) => BottomNavigationIndexProvider()),
          ChangeNotifierProvider(
              create: (_) => BottomNavigationIndexProvider2()),
          ChangeNotifierProvider(create: (context) => PaymentNotifier()),
          ChangeNotifierProvider(create: (context) => UpdateProfileNotifier()),
          ChangeNotifierProvider(create: (context) => ReelsNotifier()),
          ChangeNotifierProvider(create: (context) => ReportNotifier()),
        ],
        child: MyApp(),
      ),
    ),
  );
}
void _setupLogging() {
  // Set up the root logger
  Logger.root.level = Level.ALL; // Set the root level to ALL for verbose logging
  Logger.root.onRecord.listen((LogRecord record) {
    // Format and print the log messages
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
}
Future<void> _requestNotificationPermission() async {
  final PermissionStatus status = await Permission.notification.request();
  if (status != PermissionStatus.granted) {
    print("Permission for notifications refused");
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final storage = FlutterSecureStorage();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  OverlayEntry? _overlayEntry;
  bool _shouldDisplayPopup = false;

  @override
  void initState() {
    super.initState();
    _initFirebaseMessaging();
    _loadShouldDisplayPopup();
  }

  void _initFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.data['action'] == 'default_notification') {
        _displayNotification(message.data['title'], message.data['body']);
      }
      if (message.data['action'] == 'confirm_payment') {
        _displayPaymentConfirmationPopup(
            message.data['title'],
            message.data['body'],
            message.data['sellerId'],
            message.data['amount']);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
    });
  }

  void _sendRejectionNotification(
      String title, String body, String sellerId) async {
    final notificationService = notificationservices();

    final notification = {
      'title': 'Transaction Rejected by Parent',
      'body': 'Transaction for $title has been rejected by the parent.',
    };

    try {
      await notificationService.sendNotificationReact(notification, sellerId);
      print('Rejection notification sent successfully');
    } catch (error) {
      print('Error sending rejection notification: $error');
    }
  }

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
        // sharedPreferencesName: 'Test2',
        // preferencesKeyPrefix: 'Test'
      );
  void _sendRejectionNotificationyes(
      String title, String body, String sellerId, String amount) async {
    final notificationService = notificationservices();

    final notification = {
      'title': 'transaction success',
      'body': 'Transaction for $title has been accepted by the parent.',
    };

    try {
      var username = "houba-";

      String? crypted = await storage.read(
          key: "crypt:${username}", aOptions: _getAndroidOptions());

      await notificationService.sendNotificationReactyes(
          notification, sellerId, crypted ?? "", "username", amount);
      print('Rejection notification sent successfully');
    } catch (error) {
      print('Error sending rejection notification: $error');
    }
  }

  void _displayPaymentConfirmationPopup(
      String title, String body, String sellerId, String amount) async {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null; // Set _overlayEntry to null after removing it
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('sellerId', sellerId);
    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Blur background
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(color: Colors.black.withOpacity(0.5)),
          ),
          // Popup
          Center(
            child: Material(
              color: Colors.transparent,
              child: AlertDialog(
                title: Text(title),
                content: Text(body),
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      _overlayEntry?.remove();
                      _saveShouldDisplayPopup(false);
                      _sendRejectionNotificationyes(title, body, sellerId,
                          amount); // Mark popup as dismissed
                    },
                    child: Text('Yes'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _overlayEntry?.remove();
                      _saveShouldDisplayPopup(false); // Mark popup as dismissed
                      _sendRejectionNotification(
                          title, body, sellerId); // Send rejection notification
                    },
                    child: Text('No'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context)?.insert(_overlayEntry!);
    _saveShouldDisplayPopup(true); // Mark popup as displayed
  }

  Future<void> _displayNotification(String title, String body) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '223JMT4611',
      'mooteznotif',
      channelDescription: 'Notification channel for mooteznotif',
      icon: 'avatar_kids',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  void _loadShouldDisplayPopup() async {
    final prefs = await SharedPreferences.getInstance();
    final shouldDisplay = prefs.getBool('shouldDisplayPopup') ?? false;
    final sellerId = prefs.getString('sellerId');
    print(shouldDisplay);
    print(shouldDisplay);
    print(shouldDisplay);

    setState(() {
      _shouldDisplayPopup = shouldDisplay;
    });

    if (_shouldDisplayPopup) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        _displayPaymentConfirmationPopup(
            'Payment Confirmation', 'Confirm your payment', sellerId!, "");
      });
    }
  }

  Future<void> _saveShouldDisplayPopup(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('shouldDisplayPopup', value);
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
      translations: Languages(),

      title: 'app',
      home: LoginApp(),
      debugShowCheckedModeBanner: false, // Replace with your desired URL
    );
  }
}

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
/*
class SecretKeyResetPage extends StatefulWidget {
  @override
  _SecretKeyResetPageState createState() => _SecretKeyResetPageState();
}

Future<Map<String, dynamic>> forgetKeys(
    String mnemonic, String accountId) async {
  final response = await http.post(
    Uri.parse('http://10.0.2.2:9090/parent/newPhrase'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'mnemonic': mnemonic,
      'accountId': accountId,
    }),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to update private key: ${response.body}');
  }
}

class _SecretKeyResetPageState extends State<SecretKeyResetPage> {
  TextEditingController _textController = TextEditingController();
  List<String> _wordList = []; // List to store entered words
  String _newPrivateKey = '';

  Future<void> _handleSubmit() async {
    if (_wordList.length != 12) {
      _showErrorDialog('Please enter 12 words.');
      return;
    }

    // Check if entered words match predefined words
    try {
      final Map<String, dynamic> data =
          await forgetKeys(_wordList.join(' '), "0.0.3971845");

      // Check if the response contains the privateKey
      if (data.containsKey('privateKey')) {
        setState(() {
          _newPrivateKey = data['privateKey'];
        });
      } else {
        _showErrorDialog('Please enter valid words.');
      }
    } catch (e) {
      _showErrorDialog('An error occurred: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Secret Key Recover'),
        backgroundColor: Colors.white, // Set app bar background color
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        color: Colors.white, // Set background color of the body
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _textController,
              onChanged: (value) {
                setState(() {
                  _wordList = value.split(' ');
                });
              },
              decoration: InputDecoration(
                labelText: 'Enter 12 Words',
                border: OutlineInputBorder(),
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleSubmit,
              child: Text('Submit'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow, // Set button background color
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Your Private Key:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18, // Adjust font size
                color: Colors.black, // Set text color
              ),
            ),
            Text(
              _newPrivateKey ?? '', // Ensure _newPrivateKey is not null
              style: TextStyle(
                fontWeight: FontWeight.normal, // Set font weight to normal
                fontSize: 16, // Adjust font size
                color: Colors.grey, // Set text color
                fontStyle: FontStyle.italic, // Set italic style
              ),
            ),
            /* SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Navigate back to the previous page
              },
              child: Text('Get Back'),
            ),*/
          ],
        ),
      ),
    );
  }
}*/

class LoginPage extends StatelessWidget {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final O3DController controller = O3DController();

  @override
  Widget build(BuildContext context) {
    checkLoggedInUser(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(''), // Empty title
        centerTitle: true, // Center align title
      ),
      body: SingleChildScrollView(
        // Wrap with SingleChildScrollView
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Start from the top
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 50.0), // Add space for the title
              Center(
                child: Text(
                  'The Future For Kids Payment',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Color(0xFF38A9C2), // Specified color
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20.0), // Add space between title and image
              SizedBox(
                height: 350,
                width: double.infinity,
                child: O3D.asset(
                  src: 'assets/running_boy.glb',
                  controller: controller,
                ),
              ),
              SizedBox(height: 30.0), // Add space between image and form fields
              LoginForm(
                usernameController: _usernameController,
                passwordController: _passwordController,
              ),
              // Add space between login form and additional texts
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Add space between texts
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgotPasswordPage()),
                      );
                    },
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14.0,
                        decoration: TextDecoration.underline,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 180.0),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Color.fromARGB(255, 184, 184,
                              184), // Adjust line color as needed
                          thickness: 2, // Adjust line thickness as needed
                        ),
                      ),
                      SizedBox(width: 4),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ParentRegistrationPage()),
                            );
                          },
                          child: Text(
                            "Don't have an Account?",
                            style: TextStyle(
                              color: Color.fromARGB(255, 86, 138, 202),
                              fontSize: 14.0,
                              decoration: TextDecoration.underline,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Color.fromARGB(255, 184, 184,
                              184), // Adjust line color as needed
                          thickness: 2, // Adjust line thickness as needed
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> checkLoggedInUser(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      final String role = prefs.getString('role') ?? 'parent';
      // If user is logged in, navigate to main page directly
      if (role == 'child') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Mainskeletonchild(selectedIndex: 2)),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Mainskeleton(selectedIndex: 2)),
        );
      }
    }
  }
}

class LoginForm extends StatefulWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;

  LoginForm({
    required this.usernameController,
    required this.passwordController,
  });

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _isObscure = true;
  final storage = FlutterSecureStorage();
  TextEditingController _textController = TextEditingController();
  List<String> _wordList = []; // List to store entered words
  String _newPrivateKey = '';
  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
        // sharedPreferencesName: 'Test2',
        // preferencesKeyPrefix: 'Test'
      );
  Future<void> _handleSubmit() async {
    if (_wordList.length != 12) {
      _showErrorDialog('Please enter 12 words.');
      return;
    }

    // Check if entered words match predefined words
    try {
      final user = await signinwithsecret(_wordList.join(' '));

      // Handle successful login
      print('Logged in: $user');

      // Check user role
      if (user.role != "parent" && user.role != "child") {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Login Failed'),
              content: Text('You are not authorized to access this app.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        return; // Stop further execution
      }
      if (user.role == "parent") {
        String? value = await storage.read(
            key: "crypt:${user.username}", aOptions: _getAndroidOptions());
        print(' his private key crypted is :$value');
        // Store user data in shared preferences

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        var firsttime = prefs.getBool('firsttime');
        print("iiiiiiiiiiiiiiiii" + firsttime.toString());
        await storeUserDataInSharedPreferences(user);
        if (firsttime == true) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    OnboardingScreen(), // Navigate to the new page
              ));
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Mainskeleton(selectedIndex: 2)), // Navigate to the new page
          );
        }
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Login Successful'),
              content: Text('Welcome, ${user.username}!'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(user.username); // Return username
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else if (user.role == "child") {
        String? value = await storage.read(
            key: "crypt:${user.username}", aOptions: _getAndroidOptions());
        print(' his private key crypted is :$value');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Mainskeletonchild(
                  selectedIndex: 2)), // Navigate to the new page
        );

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Login Successful'),
              content: Text('Welcome, ${user.username}!'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(user.username); // Return username
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      // Handle login error
      print('Login error: $error');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Login Failed'),
            content: Text('Failed to login. Please try again later.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
    // Check if the response contains the privateKey
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  var loginofsecret = true;
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    // Define a GlobalKey<FormState> for the form
    if (loginofsecret == true) {
      return Container(
        padding: EdgeInsets.all(5.0),
        color: Colors.white, // Set background color of the body
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 40),
            TextField(
              controller: _textController,
              onChanged: (value) {
                setState(() {
                  _wordList = value.split(' ');
                });
              },
              decoration: InputDecoration(
                labelText: 'Enter your secret key',
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
            SizedBox(height: 25),
            ElevatedButton(
              onPressed: _handleSubmit,
              child: Text(
                'Submit',
                style: TextStyle(
                  fontFamily: 'Nerko One',
                  fontSize: 18.0,
                  color: Color(0xFF17233D),
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Color.fromARGB(255, 253, 224, 116), // Background color
                fixedSize: Size(72.0, 36.0), // Adjust width and height
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(18.0), // Adjust border radius
                ),
              ),
            ),
            SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('you want to login with username?'),
                      content: Text(
                          "Unless this is your first time or you have used the app before on this device ,you should login with your secret key"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              loginofsecret = false;
                            });
                            Navigator.of(context).pop();
                          },
                          child: Text('proceed'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text(
                "login with Username / Email",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 14.0,
                  decoration: TextDecoration.underline,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            /* SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Navigate back to the previous page
              },
              child: Text('Get Back'),
            ),*/
          ],
        ),
      );
    } else {
      return Form(
        key: formKey, // Assign the _formKey to the Form widget
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: widget.usernameController,
              decoration: InputDecoration(
                labelText: 'Username/Email',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Username/Email is required'; // Return an error message if the field is empty
                }
                return null; // Return null if the validation succeeds
              },
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: widget.passwordController,
              obscureText: _isObscure,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscure ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Password is required'; // Return an error message if the field is empty
                }
                return null; // Return null if the validation succeeds
              },
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  // Check if the form is valid
                  String username = widget.usernameController.text;
                  String password = widget.passwordController.text;

                  try {
                    var user = await AuthService.signIn(username, password);
                    // Handle successful login
                    print('Logged in: $user');

                    // Check user role
                    if (user.role != "parent" && user.role != "child") {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Login Failed'),
                            content: Text(
                                'You are not authorized to access this app.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                      return; // Stop further execution
                    }
                    if (user.role == "parent") {
                      String? value = await storage.read(
                          key: "crypt:${user.username}",
                          aOptions: _getAndroidOptions());
                      print(' his private key crypted is :$value');
                      // Store user data in shared preferences
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await storeUserDataInSharedPreferences(user);
                      var firsttime = prefs.getBool('firsttime');
                      print("iiiiiiiiiiiiiiiii" + firsttime.toString());

                      if (firsttime == true) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OnboardingScreen(), // Navigate to the new page
                            ));
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Login Successful'),
                              content: Text('Welcome, ${user.username}!'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(user.username);
                                    // Return username
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Mainskeleton(
                                  selectedIndex:
                                      2)), // Navigate to the new page
                        );
                      }
                    } else if (user.role == "child") {
                      await storeUserDataInSharedPreferences2(user);
                      String? value = await storage.read(
                          key: "crypt:${user.username}",
                          aOptions: _getAndroidOptions());
                      print(' his private key crypted is :$value');
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Mainskeletonchild(
                                selectedIndex: 2)), // Navigate to the new page
                      );

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Login Successful'),
                            content: Text('Welcome, ${user.username}!'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(user.username); // Return username
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  } catch (error) {
                    // Handle login error
                    print('Login error: $error');
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Login Failed'),
                          content:
                              Text('Failed to login. Please try again later.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Color.fromARGB(255, 253, 224, 116), // Background color
                fixedSize: Size(72.0, 36.0), // Adjust width and height
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(18.0), // Adjust border radius
                ),
              ),
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontFamily: 'Nerko One',
                    fontSize: 18.0,
                    color: Color(0xFF17233D),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                setState(() {
                  loginofsecret = true;
                });
              },
              child: Text(
                "login with Secret key",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 14.0,
                  decoration: TextDecoration.underline,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 5),
          ],
        ),
      );
    }
  }

  Future<void> storeUserDataInSharedPreferences(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', user.id);
    await prefs.setString('username', user.username);
    await prefs.setString('email', user.email ?? '');
    await prefs.setBool('isLoggedIn', true); // Set isLoggedIn to true
  }

  Future<void> storeUserDataInSharedPreferences2(Child user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', user.id!);
    await prefs.setString('username', user.username);

    await prefs.setBool('isLoggedIn', true); // Set isLoggedIn to true
  }
}

class ForgotPasswordPage extends StatelessWidget {
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                try {
                  // Send password reset email
                  String result = await AuthService.sendPasswordResetEmail(
                      _emailController.text);
                  // Show result message (e.g., using a snackbar)
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(result)),
                  );
                  // Navigate to EnterResetCodePage only if email sent successfully
                  if (result == 'Password reset email sent successfully') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EnterResetCodePage()),
                    );
                  }
                } catch (e) {
                  // Handle any errors
                  print('Error sending password reset email: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Failed to send reset email. Please try again later.')),
                  );
                }
              },
              child: Text('Send Reset Email'),
            ),
          ],
        ),
      ),
    );
  }
}

class EnterResetCodePage extends StatelessWidget {
  final _resetCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Reset Code'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _resetCodeController,
              decoration: InputDecoration(labelText: 'Reset Code'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                // Retrieve stored reset code from shared preferences
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String? storedResetCode = prefs.getString('resetCode');

                // Compare entered reset code with stored reset code
                String enteredResetCode = _resetCodeController.text;
                if (enteredResetCode == storedResetCode) {
                  // Reset code is correct, navigate to ResetPasswordPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ResetPasswordPage()),
                  );
                } else {
                  // Reset code is incorrect, show an error message
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Error'),
                      content: Text('Invalid reset code'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Text('Verify Reset Code'),
            ),
          ],
        ),
      ),
    );
  }
}

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _passwordsMatch = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'New Password'),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Confirm New Password'),
            ),
            SizedBox(height: 20.0),
            if (!_passwordsMatch)
              Text(
                'Passwords do not match',
                style: TextStyle(color: Colors.red),
              ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                final email = prefs.getString('email');

                // Check if passwords match
                if (_passwordController.text !=
                    _confirmPasswordController.text) {
                  setState(() {
                    _passwordsMatch = false;
                  });
                  return; // Exit the function early if passwords don't match
                }

                // If passwords match, proceed with password reset
                final result = await AuthService.resetPassword(
                    email!, _passwordController.text);
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(result)));

                if (result == 'Password reset successfully') {
                  // Clear all navigation history and go back to login screen
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginPage()),
                    (Route<dynamic> route) => false,
                  );
                }
              },
              child: Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
/*
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/success.dart';
import 'package:provider/provider.dart';

void main() {
   runApp(
    ChangeNotifierProvider(
      create: (_) => MyState(),
      child: MaterialApp(
        title: 'Sliding Drawer Example',
        home: MyHomePage(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sliding Drawer Example',
      home: MyHomePage(),
    );
  }
}
class MyState extends ChangeNotifier {
  late AnimationController _controller;

  MyState() {
    _controller = AnimationController(
      vsync: NavigatorState(),
      duration: Duration(milliseconds: 250),
    );
  }

  AnimationController get controller => _controller;

  void toggleController() {
    if (_controller.isDismissed) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    notifyListeners();
  }
}
class MyHomePage extends StatefulWidget {
  final Widget child =  RegistrationSuccessPage();
  final bool isOpen;
  final Duration animationDuration;
    MyHomePage({
    Key? key,
 
    this.isOpen = false,
    this.animationDuration = const Duration(milliseconds: 250),
  }) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
 
class _MyHomePageState extends State<MyHomePage>     
 with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
   final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.animationDuration);
    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(_controller)
          ..addListener(() => setState(() {}));
    if (widget.isOpen) {
      _controller.forward();
    }
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }






  @override
Widget build(BuildContext context) {
  // Calculate the horizontal offset based on the animation value
  double xOffset = _slideAnimation.value * MediaQuery.of(context).size.width / 2;

  return GestureDetector(
        child: Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: Stack( 
    
    children: [
        Container(
          width: MediaQuery.of(context).size.width / 2,
          color: Color.fromARGB(255, 174, 20, 20),
           // Optional background color for tap area
        ),
      // The content that slides
      AnimatedContainer(
        duration: widget.animationDuration,
        curve: Curves.easeInOut,
        // Apply translation transformation to slide content horizontally
        transform: Matrix4.translationValues(xOffset, 0.0, 0.0),
        child: widget.child,
        
      ),
      // (Optional) Add a GestureDetector for user interaction
 
    
    ],
  )));
}
}
*//*
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: CustomBackButtonExample(),
  ));
}

class CustomBackButtonExample extends StatefulWidget {
  @override
  _CustomBackButtonExampleState createState() =>
      _CustomBackButtonExampleState();
}

class _CustomBackButtonExampleState extends State<CustomBackButtonExample> {
  // Array to store selected indexes
  List<int> selectedIndexes = [0, 1, 2]; // Example initial selection

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle back button press
        if (selectedIndexes.isNotEmpty) {
          // Remove the last selected index
          selectedIndexes.removeLast();
          // Perform navigation
          // Replace this logic with your own navigation
          // For example, push to a new screen using Navigator
          print("iiinnnnnnn");
          // Prevent default system back button behavior
          return false;
        }
        // If there are no selected indexes left, allow the back navigation
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Custom Back Button Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Selected Index: ${selectedIndexes.last}'),
              ElevatedButton(
                onPressed: () {
                  // Example: Add a new selected index and navigate
                  selectedIndexes.add(selectedIndexes.last + 1);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SelectedScreen(index: selectedIndexes.last),
                    ),
                  );
                },
                child: Text('Push New Index'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SelectedScreen extends StatelessWidget {
  final int index;

  const SelectedScreen({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selected Screen'),
      ),
      body: Center(
        child: Text('Selected Index: $index'),
      ),
    );
  }
}
*/