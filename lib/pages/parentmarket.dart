import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/task/parent/task-page.dart';
import './barparent.dart';
import '../pages/ProductSwitcher.dart';
import './marketproductsparent.dart';

class MyParentMarket extends StatefulWidget {
  @override
  _MyParentMarketState createState() => _MyParentMarketState();
}

class _MyParentMarketState extends State<MyParentMarket> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    MyHomePage(title: 'Home'),
    ProductSwitcher(),
    ReelsPage(),
    TasksPage(),
    const UpdateProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor:
            const Color.fromARGB(255, 255, 227, 125), // Set the background color
        type: BottomNavigationBarType.fixed, // Set the type to fixed
        currentIndex: _selectedIndex, // Set the current index
        selectedItemColor: Colors.black, // Set the color of the selected item
        unselectedItemColor: const Color.fromARGB(
            255, 56, 169, 194), // Set the color of the unselected items
        onTap: _onItemTapped, // Handle item tap
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Market',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.video_collection),
            label: 'Reels',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
          ),
          const BottomNavigationBarItem(
            icon: CircleAvatar(
              radius: 15,
              backgroundImage: AssetImage('assets/images/avatar_kids.png'),
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
