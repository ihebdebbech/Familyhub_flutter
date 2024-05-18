// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:flutter/material.dart';

import 'package:flutter_application_1/Providers/Notificationprovider.dart';
import 'package:flutter_application_1/models/ChildModel.dart';
import 'package:flutter_application_1/Providers/Childsprovider.dart';
import 'package:flutter_application_1/models/Notificationsmodel.dart';
import 'package:flutter_application_1/pages/ChildListpage.dart';
import 'package:flutter_application_1/pages/bottomBarWidget.dart';
import 'package:flutter_application_1/pages/header_widget.dart';
import 'package:flutter_application_1/pages/mainskeleton.dart';
import 'package:provider/provider.dart';

class AddChildWidget extends StatefulWidget {
  const AddChildWidget({super.key});

  @override
  State<AddChildWidget> createState() => _AddChildWidgetState();
}

class _AddChildWidgetState extends State<AddChildWidget>
    with TickerProviderStateMixin {
  String dropdownValue = 'Prohibited products';
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _rfidController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();
  String imagename = '';
  final TextEditingController _prohibitedtypesController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  List<Color> colorList = List.filled(
    6,
    Color.fromRGBO(251, 255, 253, 1),
  );
  /*final GlobalKey _containerKey1 = GlobalKey();
  final GlobalKey _containerKey2 = GlobalKey();
  final GlobalKey _containerKey3 = GlobalKey();
  final GlobalKey _containerKey4 = GlobalKey();
  final GlobalKey _containerKey5 = GlobalKey();
  final GlobalKey _containerKey6 = GlobalKey();
*/
  // Function to handle container click and change its color
  void _changeColor(int index) {
    setState(() {
      colorList = List.filled(
        6,
        Color.fromRGBO(251, 255, 253, 1),
      );
      // Find the container widget by its key and change its color
      colorList[index] = Color(0xFF17233D);
    });
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final double _height = 150;
    return GestureDetector(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, _) => [],
          body: Builder(
            builder: (context) {
              return SafeArea(
                top: false,
                child: SingleChildScrollView(
                  child: Stack(
                    children: [
                      SizedBox(
                          height: 150,
                          child: Stack(children: [
                            ClipPath(
                              clipper: ShapeClipper([
                                Offset(width / 5, _height),
                                Offset(width / 10 * 5, _height - 60),
                                Offset(width / 5 * 4, _height + 20),
                                Offset(width, _height - 18)
                              ]),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                        Color.fromARGB(255, 255, 212, 125)
                                            .withOpacity(0.4),
                                        Color.fromARGB(255, 255, 162, 0)
                                            .withOpacity(0.7),
                                      ],
                                      begin: const FractionalOffset(0.0, 0.0),
                                      end: const FractionalOffset(1.0, 0.0),
                                      stops: const [0.0, 1.0],
                                      tileMode: TileMode.clamp),
                                ),
                              ),
                            ),
                            ClipPath(
                              clipper: ShapeClipper([
                                Offset(width / 3, _height + 20),
                                Offset(width / 10 * 8, _height - 60),
                                Offset(width / 5 * 4, _height - 60),
                                Offset(width, _height - 20)
                              ]),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                        Color.fromARGB(255, 255, 225, 117)
                                            .withOpacity(1),
                                        Color.fromARGB(255, 255, 212, 125)
                                            .withOpacity(0.4),
                                      ],
                                      begin: const FractionalOffset(0.0, 0.0),
                                      end: const FractionalOffset(1.0, 0.0),
                                      stops: const [0.0, 1.0],
                                      tileMode: TileMode.clamp),
                                ),
                              ),
                            ),
                            ClipPath(
                              clipper: ShapeClipper([
                                Offset(width / 5, _height),
                                Offset(width / 2, _height - 40),
                                Offset(width / 5 * 4, _height - 80),
                                Offset(width, _height - 20)
                              ]),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                        //   Color.fromARGB(255, 255, 227, 125),
                                        //  Color.fromARGB(255, 246, 196, 12),
                                        Color.fromARGB(255, 11, 45, 84),
                                        Color.fromARGB(255, 254, 210, 143),
                                      ],
                                      begin: const FractionalOffset(0.0, 0.0),
                                      end: const FractionalOffset(0.95, 0.0),
                                      stops: const [0, 0.9],
                                      tileMode: TileMode.clamp),
                                ),
                              ),
                            ),
                          ])),
                      Align(
                        alignment: AlignmentDirectional(0, 1),
                        child: Container(
                          width: double.infinity,
                          height: screenHeight,
                          decoration: BoxDecoration(
                            color: Color(0x00EEEEEE),
                          ),
                          child: Stack(
                            children: [
                              Align(
                                alignment: AlignmentDirectional(-0.08, -0.65),
                                child: Container(
                                  width: screenWidth * 0.9,
                                  height: screenHeight * 0.65,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color.fromARGB(255, 253, 224, 116)
                                            .withOpacity(0),
                                        Color.fromARGB(255, 252, 251, 243)
                                            .withOpacity(0)
                                      ],
                                      stops: [0, 1],
                                      begin: AlignmentDirectional(0.34, -1),
                                      end: AlignmentDirectional(-0.34, 1),
                                    ),
                                    /*color: Color(0xFFFFE99F),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 4,
                              color: Color(0xFF17233D),
                              offset: Offset(0, 4),
                              spreadRadius: 1,
                            )
                          ],*/
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                  child: Form(
                                    // key: _model.formKey,
                                    autovalidateMode: AutovalidateMode.disabled,
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment: AlignmentDirectional(
                                              -0.05, -0.45),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 7, 0, 0),
                                            child: Container(
                                              width: screenWidth * 0.20,
                                              height: screenHeight * 0.10,
                                              decoration: BoxDecoration(
                                                color: colorList[0],
                                                shape: BoxShape.circle,
                                              ),
                                              child: Align(
                                                alignment:
                                                    AlignmentDirectional(0, 0),
                                                child: Material(
                                                  clipBehavior: Clip.antiAlias,
                                                  shape: CircleBorder(),
                                                  child: InkWell(
                                                    onTap: () {
                                                      imagename =
                                                          'Asset 2-8.png';
                                                      _changeColor(0);
                                                    },
                                                    child: Image.asset(
                                                      'assets/images/Asset 2-8.png',
                                                      width: 77,
                                                      height: 100,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              AlignmentDirectional(0.85, -0.45),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 7, 20, 0),
                                            child: Container(
                                              width: screenWidth * 0.20,
                                              height: screenHeight * 0.10,
                                              decoration: BoxDecoration(
                                                color: colorList[1],
                                                shape: BoxShape.circle,
                                              ),
                                              child: Align(
                                                alignment:
                                                    AlignmentDirectional(0, 0),
                                                child: Material(
                                                  clipBehavior: Clip.antiAlias,
                                                  shape: CircleBorder(),
                                                  child: InkWell(
                                                    onTap: () {
                                                      imagename =
                                                          'Asset 1-8.png';
                                                      _changeColor(1);
                                                    },
                                                    child: Image.asset(
                                                      'assets/images/Asset 1-8.png',
                                                      width: 77,
                                                      height: 100,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: AlignmentDirectional(
                                              -0.25, -1.05),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    20, 0, 0, 0),
                                            child: Text(
                                              'Select an Icon For your Child',
                                              style: TextStyle(
                                                fontFamily: 'Outfit',
                                                color: Color.fromARGB(
                                                    255, 241, 246, 255),
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      Align(
                                          alignment:
                                              AlignmentDirectional(0, -0.06),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    20, 240, 20, 12),
                                            child: SizedBox(
                                              width: screenWidth * 0.67,
                                              height: screenHeight *
                                                  0.05, // Set the width to 200
                                              child: TextFormField(
                                                controller: _rfidController,
                                                autofillHints: [
                                                  AutofillHints.name
                                                ],
                                                textCapitalization:
                                                    TextCapitalization.words,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  labelText: 'your child bracelet tag',
                                                  labelStyle: TextStyle(
                                                    fontFamily: 'Readex Pro',
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  hintText: 'your child bracelet tag...',
                                                  hintStyle: TextStyle(
                                                      fontFamily: 'Readex Pro',
                                                      color: Color(0xFF17233D)),
                                                  errorStyle: TextStyle(
                                                      fontFamily: 'Readex Pro',
                                                      color: Color.fromARGB(
                                                          255, 159, 24, 0)),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 255, 253, 252),
                                                      width: 2,
                                                    ),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 152, 41, 0),
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0xFF17233D),
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  filled: true,
                                                  fillColor: Color.fromARGB(
                                                      255, 253, 254, 255),
                                                  contentPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(
                                                              16, 12, 0, 12),
                                                ),
                                                style: TextStyle(
                                                  fontFamily: 'Readex Pro',
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                cursorColor: Color(0xFF17233D),
                                              ),
                                            ),
                                          ),
                                      ),
                                        Align(
                                          alignment:
                                              AlignmentDirectional(0, -0.06),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    20, 0, 20, 12),
                                            child: SizedBox(
                                              width: screenWidth * 0.67,
                                              height: screenHeight *
                                                  0.05, // Set the width to 200
                                              child: TextFormField(
                                                controller: _usernameController,
                                                autofillHints: [
                                                  AutofillHints.name
                                                ],
                                                textCapitalization:
                                                    TextCapitalization.words,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  labelText: 'UserName',
                                                  labelStyle: TextStyle(
                                                    fontFamily: 'Readex Pro',
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  hintText: 'Your full name...',
                                                  hintStyle: TextStyle(
                                                      fontFamily: 'Readex Pro',
                                                      color: Color(0xFF17233D)),
                                                  errorStyle: TextStyle(
                                                      fontFamily: 'Readex Pro',
                                                      color: Color.fromARGB(
                                                          255, 159, 24, 0)),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 255, 253, 252),
                                                      width: 2,
                                                    ),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 152, 41, 0),
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0xFF17233D),
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  filled: true,
                                                  fillColor: Color.fromARGB(
                                                      255, 253, 254, 255),
                                                  contentPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(
                                                              16, 12, 0, 12),
                                                ),
                                                style: TextStyle(
                                                  fontFamily: 'Readex Pro',
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                cursorColor: Color(0xFF17233D),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              AlignmentDirectional(0.87, -0.85),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 5, 20, 0),
                                            child: Container(
                                              width: screenWidth * 0.20,
                                              height: screenHeight * 0.10,
                                              decoration: BoxDecoration(
                                                color: colorList[2],
                                                shape: BoxShape.circle,
                                              ),
                                              child: Align(
                                                alignment:
                                                    AlignmentDirectional(0, 0),
                                                child: Material(
                                                  clipBehavior: Clip.antiAlias,
                                                  shape: CircleBorder(),
                                                  child: InkWell(
                                                    onTap: () {
                                                      imagename =
                                                          'Asset 3-8.png';
                                                      _changeColor(2);
                                                    },
                                                    child: Image.asset(
                                                      'assets/images/Asset 3-8.png',
                                                      width: 77,
                                                      height: 100,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: AlignmentDirectional(
                                              -0.03, -0.84),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 5, 0, 0),
                                            child: Container(
                                              width: screenWidth * 0.20,
                                              height: screenHeight * 0.10,
                                              decoration: BoxDecoration(
                                                color: colorList[3],
                                                shape: BoxShape.circle,
                                              ),
                                              child: Align(
                                                alignment:
                                                    AlignmentDirectional(0, 0),
                                                child: Material(
                                                  clipBehavior: Clip.antiAlias,
                                                  shape: CircleBorder(),
                                                  child: InkWell(
                                                    onTap: () {
                                                      imagename =
                                                          'Asset 4-8.png';
                                                      _changeColor(3);
                                                    },
                                                    child: Image.asset(
                                                      'assets/images/Asset 4-8.png',
                                                      width: 77,
                                                      height: 100,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: AlignmentDirectional(
                                              -0.93, -0.85),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    20, 7, 0, 0),
                                            child: Container(
                                              width: screenWidth * 0.20,
                                              height: screenHeight * 0.10,
                                              decoration: BoxDecoration(
                                                color: colorList[4],
                                                shape: BoxShape.circle,
                                              ),
                                              child: Align(
                                                alignment:
                                                    AlignmentDirectional(0, 0),
                                                child: Material(
                                                  clipBehavior: Clip.antiAlias,
                                                  shape: CircleBorder(),
                                                  child: InkWell(
                                                    onTap: () {
                                                      imagename =
                                                          'Asset 5-8.png';
                                                      _changeColor(4);
                                                    },
                                                    child: Image.asset(
                                                      'assets/images/Asset 5-8.png',
                                                      width: 77,
                                                      height: 100,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              AlignmentDirectional(0, 0.70),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    20, 0, 20, 12),
                                            child: SizedBox(
                                              width: screenWidth * 0.67,
                                              height: screenHeight *
                                                  0.05, // Set the width to 200
                                              child: TextFormField(
                                                controller: _passwordController,
                                                autofillHints: [
                                                  AutofillHints.name
                                                ],
                                                textCapitalization:
                                                    TextCapitalization.words,
                                                obscureText: true,
                                                decoration: InputDecoration(
                                                  labelText: 'Password',
                                                  labelStyle: TextStyle(
                                                    fontFamily: 'Readex Pro',
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  hintText: '********',
                                                  hintStyle: TextStyle(
                                                      fontFamily: 'Readex Pro',
                                                      color: Color(0xFF17233D)),
                                                  errorStyle: TextStyle(
                                                      fontFamily: 'Readex Pro',
                                                      color: Color.fromARGB(
                                                          255, 159, 24, 0)),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 255, 253, 252),
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 159, 24, 0),
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 159, 24, 0),
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  filled: true,
                                                  fillColor: Color.fromARGB(
                                                      255, 251, 252, 255),
                                                  contentPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(
                                                              16, 12, 0, 12),
                                                ),
                                                style: TextStyle(
                                                  fontFamily: 'Readex Pro',
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                cursorColor: Color(0xFF17233D),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              AlignmentDirectional(0, 0.19),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    20, 0, 20, 12),
                                            child: SizedBox(
                                              width: screenWidth * 0.67,
                                              height: screenHeight *
                                                  0.05, // Set the width to 200
                                              child: TextFormField(
                                                controller:
                                                    _phoneNumberController,
                                                autofillHints: [
                                                  AutofillHints.name
                                                ],
                                                textCapitalization:
                                                    TextCapitalization.words,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  labelText: 'PhoneNumber',
                                                  labelStyle: TextStyle(
                                                    fontFamily: 'Readex Pro',
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  alignLabelWithHint: false,
                                                  hintText: 'ex:85789621',
                                                  hintStyle: TextStyle(
                                                      fontFamily: 'Readex Pro',
                                                      color: Color(0xFF17233D)),
                                                  errorStyle: TextStyle(
                                                      fontFamily: 'Readex Pro',
                                                      color: Color.fromARGB(
                                                          255, 159, 24, 0)),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 255, 253, 252),
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 159, 24, 0),
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 159, 24, 0),
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  filled: true,
                                                  fillColor: Color.fromARGB(
                                                      255, 251, 252, 255),
                                                  contentPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(
                                                              16, 12, 0, 12),
                                                ),
                                                style: TextStyle(
                                                  fontFamily: 'Readex Pro',
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              AlignmentDirectional(0, 0.95),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    20, 0, 20, 12),
                                            child: SizedBox(
                                              width: screenWidth * 0.67,
                                              height: screenHeight *
                                                  0.05, // Set the width to 200
                                              child: TextFormField(
                                                controller:
                                                    _confirmpasswordController,
                                                obscureText: true,
                                                autofillHints: [
                                                  AutofillHints.name
                                                ],
                                                textCapitalization:
                                                    TextCapitalization.words,
                                                decoration: InputDecoration(
                                                  labelText: 'Confirm Password',
                                                  labelStyle: TextStyle(
                                                    fontFamily: 'Readex Pro',
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  hintText: '*****',
                                                  hintStyle: TextStyle(
                                                      fontFamily: 'Readex Pro',
                                                      color: Color(0xFF17233D)),
                                                  errorStyle: TextStyle(
                                                      fontFamily: 'Readex Pro',
                                                      color: Color.fromARGB(
                                                          255, 159, 24, 0)),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 255, 253, 252),
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 159, 24, 0),
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 159, 24, 0),
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  filled: true,
                                                  fillColor: Color.fromARGB(
                                                      255, 251, 252, 255),
                                                  contentPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(
                                                              16, 12, 0, 12),
                                                ),
                                                style: TextStyle(
                                                  fontFamily: 'Readex Pro',
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: AlignmentDirectional(
                                              -0.93, -0.46),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    20, 7, 0, 0),
                                            child: Container(
                                              width: screenWidth * 0.20,
                                              height: screenHeight * 0.10,
                                              decoration: BoxDecoration(
                                                color: colorList[5],
                                                shape: BoxShape.circle,
                                              ),
                                              child: Align(
                                                alignment:
                                                    AlignmentDirectional(0, 0),
                                                child: Material(
                                                  clipBehavior: Clip.antiAlias,
                                                  shape: CircleBorder(),
                                                  child: InkWell(
                                                    onTap: () {
                                                      imagename =
                                                          'Asset 7-8.png';
                                                      _changeColor(5);
                                                    },
                                                    child: Image.asset(
                                                      'assets/images/Asset 7-8.png',
                                                      width: 77,
                                                      height: 100,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(0, 0.5),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 7, 0, 0),
                                  child: Container(
                                    width: 230,
                                    // Set the desired width
                                    decoration: BoxDecoration(
                                      color: Color(0xFF17233D),
                                      borderRadius: BorderRadius.circular(14),
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 10,
                                          color:
                                              Color.fromARGB(255, 86, 97, 120),
                                          offset: Offset(0, 4),
                                          spreadRadius: 0.1,
                                        )
                                      ], // Set the desired corner radius
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        if (imagename.isEmpty) {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Check again'),
                                                content: Text(
                                                    'please select an image'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(); // Return username
                                                    },
                                                    child: Text('OK'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        } else if ((_passwordController.text !=
                                                _confirmpasswordController
                                                    .text) &&
                                            (_passwordController
                                                .text.isNotEmpty) &&
                                            (_confirmpasswordController
                                                .text.isNotEmpty)) {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Check again'),
                                                content: Text(
                                                    'please check your entered passwords'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      // Check if this is printed
                                                      Navigator.of(context)
                                                          .pop(); // Return username
                                                    },
                                                    child: Text('OK'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        } else {
                                          print(imagename);
                                          // Perform action when the image is tapped
                                          Provider.of<ChildProvider>(context,
                                                  listen: false)
                                              .createChild(Child(
                                            username: _usernameController.text,
                                            password: _passwordController.text,
                                            image: imagename,
                                            phoneNumber: int.tryParse(
                                                    _phoneNumberController
                                                        .text) ??
                                                0,
                                            prohibitedProductTypes: [],
                                            rfidtag : _rfidController.text,
                                          ) // Assuming it's an empty list for now
                                                  );
                                         /* Provider.of<NotificationProvider>(
                                                  context,
                                                  listen: false)
                                              .createNotification(
                                            notification(
                                                type: "new child added ",
                                                content:
                                                    "you added a new child named ${_usernameController.text}",
                                                senderId: "senderId",
                                                timestamp: DateTime.now()),
                                            // Assuming it's an empty list for now
                                          );*/
                                          /* Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ChildListWidget()),
                                          );*/
                                          Provider.of<BottomNavigationIndexProvider>(
                                                  context,
                                                  listen: false)
                                              .onTabTapped(2);
                                        }
                                      },
                                      child: Text(
                                        'Add', // Text displayed on the button
                                        style: TextStyle(
                                          fontFamily: 'Outfit',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors
                                              .white, // Adjust font size as needed
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
