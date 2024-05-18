import 'package:flutter/material.dart';
import 'package:flutter_application_1/Providers/Notificationprovider.dart';
import 'package:flutter_application_1/pages/ChildListpage.dart';
import 'package:flutter_application_1/pages/silverappBarwidget.dart';
import 'package:provider/provider.dart';

 // Import your AppBarWidget file

class Widget1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, _) => [
           const sliverAppBarWidget()
          ],
       // Use your custom AppBarWidget
      body: Stack(
        children: [
         const ChildListWidget(),
          MenuSlide(),
        ],
      ),
    )
    );
  }
}

class ContentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: const Center(
        child: Text('Content of Widget 1'),
      ),
    );
  }
}

class MenuSlide extends StatelessWidget {
   
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
        double menuWidth = screenWidth * 0.35;
    return Consumer<NotificationProvider>(
      builder: (context, menuState, child) {
        return AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          left: menuState.isMenuOpen ? 0 : screenWidth - menuWidth,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Menu',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListTile(
                    title: const Text('Menu Item 1'),
                    onTap: () {},
                  ),
                  ListTile(
                    title: const Text('Menu Item 2'),
                    onTap: () {},
                  ),
                  ListTile(
                    title: const Text('Menu Item 3'),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
