// child_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/Notificationsmodel.dart';

import 'package:flutter_application_1/services/notificationservices.dart'; // Import your ChildService

class NotificationProvider extends ChangeNotifier {
  final notificationservices notifservice = notificationservices();
/*
   AnimationController _controller ;

  AnimationController get _controller => _controller2;

NotificationProvider(){
 _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() => setState(() {}));

} 

  void toggleController() {
    if (_controller!.isDismissed) {
      _controller?.forward();
    } else {
      _controller?.reverse();
    }
    notifyListeners();
  }*/
  bool _isMenuOpen = true;
  bool? isLoading;
  bool get isMenuOpen => _isMenuOpen;
  List<notification> _notifs = [];
  // ignore: recursive_getters
  List<notification> get notifs => _notifs;
  void toggleMenu() {
    _isMenuOpen = !_isMenuOpen;
    notifyListeners();
  }

  Future<void> createNotification(notification notif) async {
    try {
      notifservice.createnotification(notif);
      _notifs.add(notif);
      // Notify listeners to update UI if needed
      notifyListeners();
    } catch (error) {
      print('Failed to create child: $error');
    }
  }

  Future<void> fetchnotifications() async {
    try {
      isLoading = true;
      _notifs = await notifservice.getnotifications();
      isLoading = false;
      print(_notifs);
      notifyListeners();
    } catch (e) {
      print('Error fetching children: $e');
    }
  }
}
