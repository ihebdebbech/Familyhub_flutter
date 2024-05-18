// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/ChildListpage.dart';
import 'package:flutter_application_1/pages/mainskeleton.dart';
import 'package:flutter_application_1/pages/mainskeletonchild.dart';
import 'package:flutter_application_1/pages/marketproductsparent.dart';
import 'package:flutter_application_1/pages/parenttoolbar.dart';
import 'package:provider/provider.dart';

class BottomBarWidgetchild extends StatefulWidget {
  @override
  State<BottomBarWidgetchild> createState() => _BottomBarWidgetState();
}

class _BottomBarWidgetState extends State<BottomBarWidgetchild> {
  int selectedIndex = 2;

  List<Map<String, dynamic>> iconData = [
    {"icon": Icons.home_rounded, "route": ""},
    {"icon": Icons.task_alt, "route": ""},
    {"icon": Icons.gamepad, "route": ""},
    {"icon": Icons.movie_outlined, "route": ""},
    {"icon": Icons.museum_sharp, "route": "MarketPage()"},
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Align(
              alignment: AlignmentDirectional(0, 1),
              child: Material(
                color: Colors.transparent,
                elevation: 0,
                child: Container(
                  width: double.infinity,
                  height: 65,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 251, 254, 255),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 8,
                        color: Color.fromARGB(15, 64, 73, 79),
                        offset: Offset(0, -11),
                        spreadRadius: 0.3,
                      )
                    ],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (int index = 0; index < iconData.length; index++)
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                    Provider.of<BottomNavigationIndexProvider2>(context,
                            listen: false)
                        .onTabTapped(index);
                  });
                },
                child: Container(
                  width: 55,
                  height: 60,
                  color: selectedIndex == index
                      ? Color(0xFFFFE27D)
                      : Colors.transparent,
                  child: Padding(
                    padding: EdgeInsets.only(top: 15), // Adjust as needed
                    child: Align(
                      alignment: Alignment.center,
                      child: Icon(
                        iconData[index]["icon"],
                        color: Color(0xFF17233D),
                        size: 25,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        Positioned(
          left: (selectedIndex * 74.0) + 19,
          bottom: 0,
          child: Container(
            width: 80,
            height: 4,
            color: Color.fromARGB(255, 253, 212, 64),
          ),
        ),
      ],
    );
  }
}
