// ignore_for_file: non_constant_identifier_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Providers/Notificationprovider.dart';
import 'package:flutter_application_1/pages/AddChildpage.dart';
import 'package:flutter_application_1/pages/ChildListpage.dart';
import 'package:flutter_application_1/pages/bottomBarWidget.dart';
import 'package:flutter_application_1/pages/notificationpage.dart';
import 'package:flutter_application_1/pages/reelsPage.dart';
import 'package:flutter_application_1/pages/silverappBarwidget.dart';
import 'package:flutter_application_1/pages/task/parent/task-page.dart';
import 'package:flutter_application_1/services/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/ProductSwitcher.dart';
import 'package:provider/provider.dart';
import './barparent.dart';
import './marketproductsparent.dart';

class Mainskeleton extends StatefulWidget {
  final int selectedIndex;

  Mainskeleton({required this.selectedIndex});

  @override
  _MainskeletonState createState() => _MainskeletonState();
}

class _MainskeletonState extends State<Mainskeleton> {
  bool _showUpdatePasswordPopup = true;
  final List<Widget> _pages = [
    MyHomePage(title: 'Home'),
    TasksPage(),
    ChildListWidget(),
    reelsPage(),
    ProductSwitcher(),
    AddChildWidget(),
  ];
  Future<void> firsttimecheck() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var firsttime = prefs.getBool('firsttime') ?? true;
    setState(() {
      if (firsttime == false) {
        _showUpdatePasswordPopup = firsttime;
      }
    });

    print("iheb" + _showUpdatePasswordPopup.toString());
  }

  // Initially true to show the popup
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmNewPasswordController = TextEditingController();

  void onTabTapped(int index) {
    setState(() {});
  }

  @override
  initState() {
    super.initState();
    firsttimecheck();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double menuWidth = screenWidth * 0.35;
    return Scaffold(
      appBar: sliverAppBarWidget(),
      body: Consumer<BottomNavigationIndexProvider>(
        builder: (context, provider, _) {
          return Stack(
            children: [
              Consumer<NotificationProvider>(
                  builder: (context, notificationprovider, _) {
                if ((notificationprovider.isLoading == null) &&
                    (notificationprovider.isLoading != true) &&
                    notificationprovider.notifs.isEmpty) {
                  // Fetch children if they are not already loading and the list is empty
                  notificationprovider.fetchnotifications();
                }

                // Display loading indicator while loading
                if ((notificationprovider.isLoading != null) &&
                    (notificationprovider.isLoading == true)) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return SafeArea(
                    top: false,
                    child: Stack(
                      children: [
                        NotificationWidget(),
                        AnimatedPositioned(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            left: notificationprovider.isMenuOpen
                                ? 0
                                : screenWidth - menuWidth,
                            child: SizedBox(
                                width: screenWidth,
                                height: screenHeight,
                                child: _pages[provider._selectedIndex])),
                      ],
                    ),
                  );
                }
              }),
              Align(
                alignment: AlignmentDirectional(0, 1),
                child: Container(
                  width: double.infinity,
                  height: 75,
                  decoration: BoxDecoration(
                    color: Color(0x00EEEEEE),
                  ),
                  child: BottomBarWidget(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showPasswordFields(BuildContext context) async {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            width: screenWidth * 0.8,
            height: screenHeight * 0.4,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close),
                        ),
                      ],
                    ),
                    Text(
                      "Update Your Password",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _newPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _confirmNewPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Confirm New Password',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        // Validate new password and confirm password
                        String newPassword = _newPasswordController.text;
                        String confirmNewPassword =
                            _confirmNewPasswordController.text;
                        if (newPassword.isEmpty || confirmNewPassword.isEmpty) {
                          Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              width: screenWidth * 0.8,
                              height: screenHeight * 0.4,
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Text("password reset successfully"),
                                ),
                              ),
                            ),
                          );
                        } else if (newPassword != confirmNewPassword) {
                          // Show error message if passwords do not match
                          Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              width: screenWidth * 0.8,
                              height: screenHeight * 0.4,
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Text("password reset successfully"),
                                ),
                              ),
                            ),
                          );
                        } else {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();

                          String? useremail = prefs.getString('email');
                          print(useremail);
                          // Call AuthService's resetPassword function
                          var message =
                              await firstimereset(useremail!, newPassword);
                          Navigator.pop(context);
                          // Show success or failure message
                          ;
                          // Close the dialog
                        }
                      },
                      child: Text("Save"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class BottomNavigationIndexProvider with ChangeNotifier {
  int _selectedIndex = 2;

  int get selectedIndex => _selectedIndex;

  void onTabTapped(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
