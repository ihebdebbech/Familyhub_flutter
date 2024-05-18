// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import '../Services/parentServices.dart';
import '../main.dart';

class ParentRegistrationPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Register Now",
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center (
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 80.0, // Increase the radius to make the image bigger
                    backgroundImage: AssetImage('assets/images/avatar_kids.png'),
                  ),
                ),
                SizedBox(height: 20.0), // Spacing after the image
                TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                    // Customizing input field color and border
                    fillColor: Colors.white, // Background color of the text field
                    filled: true,
                    focusedBorder: OutlineInputBorder( // Border when the TextFormField is focused
                      borderSide: BorderSide(
                        color: Colors.blue, // Your specified color
                        width: 2.0, // You can adjust the border width
                      ),
                    ),
                    floatingLabelStyle: TextStyle( // Style for the label when the field is focused
                      color: Colors.blue, // Specified color for focused label
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                    // Customizing input field color and border
                    fillColor: Colors.white, // Same as above
                    filled: true,
                    focusedBorder: OutlineInputBorder( // Border when the TextFormField is focused
                      borderSide: BorderSide(
                        color: Colors.blue, // Your specified color
                        width: 2.0, // You can adjust the border width
                      ),
                    ),
                    floatingLabelStyle: TextStyle( // Style for the label when the field is focused
                      color: Colors.blue, // Specified color for focused label
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: phoneNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                    // Customizing input field color and border
                    fillColor: Colors.white, // Same as above
                    filled: true,
                    focusedBorder: OutlineInputBorder( // Border when the TextFormField is focused
                      borderSide: BorderSide(
                        color: Colors.blue, // Your specified color
                        width: 2.0, // You can adjust the border width
                      ),
                    ),
                    floatingLabelStyle: TextStyle( // Style for the label when the field is focused
                      color: Colors.blue, // Specified color for focused label
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                    // Customizing input field color and border
                    fillColor: Colors.white, // Same as above
                    filled: true,
                    focusedBorder: OutlineInputBorder( // Border when the TextFormField is focused
                      borderSide: BorderSide(
                        color: Colors.blue, // Your specified color
                        width: 2.0, // You can adjust the border width
                      ),
                    ),
                    floatingLabelStyle: TextStyle( // Style for the label when the field is focused
                      color: Colors.blue, // Specified color for focused label
                    ),
                  ),
                ),
                SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: () {
                    registerParent(
                      usernameController.text.trim(),
                      emailController.text.trim(),
                      passwordController.text,
                      phoneNumberController.text.trim(),
                    ).then((success) {
                      // Show success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Registration successfull , please login with your new informations')),
                      );

                      // Navigate to the success page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginPage()),
                      );
                    }).catchError((error) {
                      // Show error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $error')),
                      );
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Color(0xFF17233D), backgroundColor: Color.fromARGB(255, 253, 224, 116), // Text color
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: Text(
                    'Submit',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}