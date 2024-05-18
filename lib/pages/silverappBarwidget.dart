// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Providers/Notificationprovider.dart';
import 'package:flutter_application_1/pages/barparent.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class sliverAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const sliverAppBarWidget({super.key});

  @override
  Size get preferredSize => Size.fromHeight(70);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 70,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      shadowColor: const Color(0xFF17233D),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          boxShadow: const [
            BoxShadow(
              blurRadius: 10,
              color: Color.fromARGB(40, 0, 0, 0),
              offset: Offset(0, 10),
              spreadRadius: 0,
            )
          ],
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
            topLeft: Radius.circular(0),
            topRight: Radius.circular(0),
          ),
        ),
        child: FlexibleSpaceBar(
          titlePadding: EdgeInsets.only(top: 40),
          title: Align(
            alignment: Alignment.center,
            child: Text(
              'Kidscoin',
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF17233D),
              ),
            ),
          ),
        ),
      ),
      leading: Padding(
        padding: EdgeInsets.only(top: 15),
        child: ElevatedButton(
          onPressed: () {
            Provider.of<NotificationProvider>(context, listen: false)
                .toggleMenu();
          },
          style: ElevatedButton.styleFrom(
            // Make button transparent
            // Remove elevation

            padding: EdgeInsets.zero,
            elevation: 0, // Remove padding
            // Make button circular
          ),
          child: const Icon(
            Icons.notifications_active_sharp,
            color: Color(0xFF17233D),
            size: 30,
          ),
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(top: 15),
          child: Row(children: [
            Align(
              alignment: const AlignmentDirectional(0, -1),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 20, 0),
                      child: FaIcon(
                        FontAwesomeIcons.solidMoon,
                        color: Color(0xFF17233D),
                        size: 22,
                      ),
                    ),
                   GestureDetector( onTap: () {
                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                 
    UpdateProfile(),),
                                                        );
                   },
                    child: Stack(
                      children: [
                        // Profile image with circular container in the background
                       Container(
                          width: 45, // Adjust size as needed
                          height: 45, // Adjust size as needed
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey
                                .withOpacity(0.3), // Background color
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/Asset 1-8.png',
                              fit: BoxFit.cover,
                              width: 40, // Adjust size as needed
                              height: 40, // Adjust size as needed
                            ),
                          ),
                        ),
                        // Icon in the bottom right corner
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 3,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(4),
                            child: Icon(
                              Icons.menu,
                              color: Colors.black,
                              size: 15,
                            ),
                          ),
                        ),
                     
                      ],
                    ),
                     ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ],
    );
  }
}
