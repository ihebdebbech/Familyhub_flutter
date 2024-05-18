// child_provider.dart
// ignore_for_file: unused_local_variable

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/ChildModel.dart';
import 'package:flutter_application_1/services/ChildsApi.dart'; // Import your ChildService

class ChildProvider extends ChangeNotifier {
  final ChildApi _childService = ChildApi();
  List<Child> _children = [];
  HashMap<String, dynamic> soldes = HashMap();
  List<Child> get children => _children;

  bool? isLoading;
  Future<void> createChild(Child child) async {
    try {
      await _childService.createChild(child);
      _children.add(child);
      // Notify listeners to update UI if needed
      notifyListeners();
    } catch (error) {
      print('Failed to create child: $error');
    }
  }

  Future<void> fetchChildren() async {
    try {
      isLoading = true;
      _children = await _childService.getChildren();
      //await getsolde();
       _children.forEach((child) async {
      print('innnn');
      soldes[child.username] = await _childService.getsolde(child.username);
      print(soldes[child.username]);
      notifyListeners();
    });
      isLoading = false;
      print(_children);
    
      
    } catch (e) {
      print('Error fetching children: $e');
    }
  }

  Future<void> getsolde() async {
    _children.forEach((child) async {
     soldes[child.username] = await _childService.getsolde(child.username);
      print(soldes[child.username]);
      notifyListeners();
    });
    print(_children.length);
   

  
  }
}
