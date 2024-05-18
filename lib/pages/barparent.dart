// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/controller/paymentProvider.dart';
import 'package:flutter_application_1/controller/updateProfileProvider.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/pages/header_widget.dart';
import 'package:flutter_application_1/pages/pinball.dart';
import 'package:flutter_application_1/pages/scratch_card_demo_page.dart';
import 'package:flutter_application_1/pages/task/parent/task-page.dart';
import 'package:flutter_application_1/pages/web_view_widget.dart';
import 'package:flutter_application_1/pages/weeDasher.dart';
import 'package:flutter_application_1/theme/theme_helper.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_application_1/tic_tac_toe.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:scroll_snap_effect/scroll_snap_effect.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'PurchaseHistory.dart';


import 'SecretKeyResetPage.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: Icon(Icons.gamepad),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TicTacToe()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: ScrollSnapEffect(
          itemSize: 116,
          itemCount: 3,
          padding: const EdgeInsets.only(bottom: 600),
          onChanged: (index) {
            debugPrint('$index');
          },
          itemBuilder: (context, index) {
            // Example asset paths
            List<String> assetPaths = [
              'assets/images/scatch.png',
              'assets/images/brick.jpeg',
              'assets/images/mario.png',
              'assets/images/mario.png'
            ];

            return Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      12.0), // Adjust the value to control the roundness
                ),
                child: InkWell(
                  onTap: () {
                    // Navigate to a new page based on the index
                    switch (index) {
                      case 0:
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ScratchCardDemoPage()),
                        );
                        break;
                      case 1:
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => GameApp()),
                        );
                        break;
                      case 2:
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => WeeDasher()),
                        );
                        
  
                        
                      default:
                    }
                  },
                  child: SizedBox(
                    height: 100,
                    width: 150,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          12.0), // Same as the Card's borderRadius
                      child: Image.asset(
                        assetPaths[
                            index], // Use the asset path corresponding to the index
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class DetailsPage extends StatelessWidget {
  final String imagePath;

  DetailsPage({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
      ),
      body: Center(
        child: Image.asset(imagePath),
      ),
    );
  }
}

class WalletPage extends StatelessWidget {
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Wallet"),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text("Recharge"),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Enter Recharge Amount",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Amount",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () async {
                          int amount =
                              int.tryParse(_amountController.text) ?? 0;
                          // Call the makePayment method from PaymentNotifier
                          final paymentNotifier = Provider.of<PaymentNotifier>(
                              context,
                              listen: false);
                          await paymentNotifier.makePayment(amount);
                          // Navigate to WebViewPage if payment is successful
                          final paymentResult =
                              await paymentNotifier.paymentResult;
                          if (paymentResult.result.success) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WebViewPage(
                                  url: paymentResult.result.link,
                                ),
                              ),
                            );
                          } else {
                            // Handle payment failure
                          }
                        },
                        child: const Text("Confirm"),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class ReelsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyHomePage(title: 'Reels');
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyHomePage(title: 'Profile');
  }
}

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({Key? key}) : super(key: key);

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController addressController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  String? username;
  String? phone;
  String? newImage;
  String? address;
  bool checkedValue = false;
  bool checkboxValue = false;
  String? imageUrl;
  File? image;
  var uuid = const Uuid();
  int? storedPhoneNumber;
  String? storedUsername,
      storedEmail,
      number; // Define a variable to store the retrieved username

  @override
  void initState() {
    super.initState();
    getStoredUsername();
    // Call the method to retrieve the stored username
  }

  Future<void> getStoredUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      storedUsername = prefs.getString('username');
      username =
          storedUsername; // Set the username variable with storedUsername
      storedEmail = prefs.getString('Email');
      storedPhoneNumber = prefs.getInt('number');
      number = storedPhoneNumber.toString();
      fullNameController = TextEditingController(text: storedUsername);
      addressController = TextEditingController(text: storedEmail);
      mobileNumberController = TextEditingController(text: number);
    });
  }

  @override
  void dispose() {
    fullNameController.dispose();
    mobileNumberController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      backgroundColor: Colors.white,
      body: Consumer<UpdateProfileNotifier>(
        builder: (context, updateProfileNotifier, child) {
          if (updateProfileNotifier.solde.isEmpty) {
            updateProfileNotifier.getsolde(fullNameController.text);
          }
          return SingleChildScrollView(
            child: Stack(
              children: [
                const SizedBox(
                  height: 150,
                  child: HeaderWidget(
                    150,
                    false,
                    AssetImage("assets/images/logo.png"),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(25, 50, 25, 10),
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  alignment: Alignment.center,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        GestureDetector(
                          child: Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                    width: 5,
                                    color: Colors.white,
                                  ),
                                  color: Colors.white,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 20,
                                      offset: Offset(5, 5),
                                    ),
                                  ],
                                ),
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: CircleAvatar(
                                    radius: 50,
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.white,
                                    foregroundImage: image != null
                                        ? FileImage(image!)
                                            as ImageProvider<Object>
                                        : const AssetImage(
                                            "assets/images/avatar_kids.png"),
                                  ),
                                ),
                              ),
                              if (image != null)
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                      width: 5,
                                      color: Colors.white,
                                    ),
                                    color: Colors.white,
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 20,
                                        offset: Offset(5, 5),
                                      ),
                                    ],
                                  ),
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: CircleAvatar(
                                      radius: 50,
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.white,
                                      foregroundImage: FileImage(image!),
                                    ),
                                  ),
                                ),
                              GestureDetector(
                                onTap: () {
                                  pickImage();
                                },
                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(
                                    90,
                                    90,
                                    0,
                                    0,
                                  ),
                                  child: const Icon(
                                    Icons.add_circle,
                                    color: Color.fromARGB(255, 255, 227, 125),
                                    size: 25.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        // Assuming storedUsername is a String variable

                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            enabled: false,
                            controller: fullNameController,
                            onChanged: (value) {
                              username = value;
                            },
                            decoration: ThemeHelper().textInputDecoration(
                              'Username',
                              'Please enter your user name',
                              GestureDetector(
                                child: const Icon(Icons.person),
                              ),
                            ),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter your user name";
                              }
                              return null;
                            },
                          ),
                        ),

                        Column(
                          children: [
                            const SizedBox(height: 20),
                            Container(
                              decoration:
                                  ThemeHelper().inputBoxDecorationShaddow(),
                              child: TextFormField(
                                controller: mobileNumberController,
                                maxLength: 8,
                                onChanged: (value) {
                                  phone = value;
                                },
                                decoration: ThemeHelper().textInputDecoration(
                                  'Phone number',
                                  "Enter your mobile number",
                                  GestureDetector(
                                    child: const Icon(Icons.phone),
                                  ),
                                ),
                                keyboardType: TextInputType.phone,
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            Container(
                              decoration:
                                  ThemeHelper().inputBoxDecorationShaddow(),
                              child: TextFormField(
                                controller: addressController,
                                onChanged: (value) {
                                  address = value;
                                },
                                decoration: ThemeHelper().textInputDecoration(
                                  "Email",
                                  "Enter your email",
                                  GestureDetector(
                                    child: const Icon(Icons.mail),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Enter your email';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            Row(
                              children: [
                                const SizedBox(
                                    width:
                                        8.0), // Add some spacing between the icon and the text
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SecretKeyResetPage()),
                                    ); // Navigate to another page here
                                  },
                                  child: Text(
                                    "Get your secret key back",
                                    style: TextStyle(
                                      color: Colors
                                          .blue, // Change the color as needed
                                      decoration: TextDecoration
                                          .underline, // Underline the text
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 15.0),
                        const SizedBox(height: 20.0),
                        Container(
                          decoration:
                              ThemeHelper().buttonBoxDecoration(context),
                          child: ElevatedButton(
                            style: ThemeHelper().buttonStyle(),
                            onPressed: () async {
                              int number =
                                  int.tryParse(mobileNumberController.text) ??
                                      0;
                              mobileNumberController.text;

                              // Call the updateProfile method
                              bool updateSuccess =
                                  await updateProfileNotifier.updateProfile(
                                fullNameController.value.text,
                                addressController.text,
                                number,
                                imageUrl ?? "2",
                              );

                              Get.back(); // Close bottom sheet

                              // Show success dialog if the update was successful
                              if (updateSuccess) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Success'),
                                      content: const Text(
                                          'Profile updated successfully!'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(40, 10, 40, 10),
                              child: Text(
                                "update".toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(40, 20, 40, 10),
                          child: Text(
                            'Your balance:${updateProfileNotifier.solde} SPT',
                            style: TextStyle(
                              fontFamily: 'Readex Pro',
                              fontSize: 20,
                              color: Color(0xFF17233D),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(40, 20, 40, 10),
                          child: Container(
                            decoration:
                                ThemeHelper().buttonBoxDecoration(context),
                            child: ElevatedButton(
                              style: ThemeHelper().buttonStyle(),
                              onPressed: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PurchaseHistoryPage(),
                                  ),
                                );
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(30, 10, 30, 10),
                                child: Icon(
                                  Icons.payments_outlined,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(40, 50, 40, 10),
                          child: Container(
                            width: 490,
                            decoration:
                                ThemeHelper().buttonBoxDecoration(context),
                            child: ElevatedButton(
                              style: ThemeHelper().buttonStyle(),
                              onPressed: () async {
                                final SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                
                                final username = prefs.getString('username');
                                
                                
                           final String? token = prefs.getString('tokendevice');

                                prefs.clear();
                                    final storage = FlutterSecureStorage();
                                       String? value = await storage.read(
                                 key: "crypt:${username}", aOptions: _getAndroidOptions());
                             print('Child private key crypted is :$value');
 if (token != null) {
          await prefs.setString('tokendevice', token);
        }
                               Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginPage(),
                                    
                                  ),
                                );
                              },
                              child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(35, 0, 30, 0),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            30, 10, 30, 10),
                                        child: Text("Logout",
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            )),
                                      ),
                                      Icon(
                                        Icons.logout,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ],
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future pickImage() async {
    try {
      var image = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 1);

      if (image == null) return;
      final imageTemp = File(image.path);
      // Reference ref = FirebaseStorage.instance.ref().child(uuid.v1());
      // await ref.putFile(imageTemp);
      // ref.getDownloadURL().then((value) {
      //   setState(() {
      //     image = imageTemp as XFile?;
      //     imageUrl = value;
      //   });
      //   if (kDebugMode) {
      //     print(value);
      //   }
      // });

      setState(() {
        this.image = imageTemp;
      });
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Failed to pick image: $e');
      }
    }
  }
   AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
        // sharedPreferencesName: 'Test2',
        // preferencesKeyPrefix: 'Test'
      );
}
