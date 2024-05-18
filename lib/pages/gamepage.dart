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

class MygamePage extends StatelessWidget {
  

  MygamePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        child: ScrollSnapEffect(
          itemSize: 116,
          itemCount: 4,
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
              'assets/images/mario.png',
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
                      case 3:                 
                          Navigator.push(
                          context,
                           MaterialPageRoute(builder: (context) => TicTacToe()),
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
