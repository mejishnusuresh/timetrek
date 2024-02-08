import 'package:flutter/material.dart';
import 'package:timetrek/pages/drawer/drawer.dart';
import 'package:timetrek/pages/tabs/group_tab.dart';
import 'package:timetrek/pages/tabs/notification_tab.dart';
import 'package:timetrek/pages/tabs/search_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const GroupTab(),
    const SearchTab(),
    const NotificationTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideDrawer(),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.notifications),
          //   label: 'Notifications',
          // ),
        ],
        fixedColor: Colors.white, // Set the active icon and label color
        backgroundColor: Theme.of(context).primaryColor, // Set the background color
        type: BottomNavigationBarType.fixed, // Set the type to fixed
      ),
    );
  }
}
