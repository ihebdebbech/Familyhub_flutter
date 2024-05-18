import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/Providers/Notificationprovider.dart';
// import your NotificationProvider class

class NotificationWidget extends StatefulWidget {
  @override
  _NotificationWidgetState createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  @override
  void initState() {
    super.initState();
    // Fetch notifications when the widget is initialized
    Provider.of<NotificationProvider>(context, listen: false).fetchnotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (context, notificationProvider, _) {
        // Display loading indicator while loading
        if (notificationProvider.isLoading != null && notificationProvider.isLoading == true) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return SafeArea(
            top: false,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Container(
                color: const Color(0xFFFFE27D),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Notifications',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    for (int index = 0; index < notificationProvider.notifs.length; index++)
                      GestureDetector(
                        onTap: () {
                          // Handle tap on notification
                        },
                        child: Row(
                           mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                              children: [
                          const Icon(        
                                                  Icons
                                                      .person_add_alt_1_outlined,
                                                  color: Color(
                                                                0xFF17233D),
                                                  size: 30,
                                                ),     
                                                Padding(padding: const EdgeInsets.only(top: 15, left: 12),   
                       child : Text(   
                          notificationProvider.notifs[index].content,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF17233D),
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
          );
        }
      },
    );
  }
}
