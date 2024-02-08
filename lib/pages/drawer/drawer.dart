import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timetrek/helper/helper_function.dart';
import 'package:timetrek/pages/drawer/home_page.dart';
import 'package:timetrek/pages/drawer/profile_page.dart';
import 'package:timetrek/pages/drawer/settings_page.dart';
import 'package:timetrek/pages/drawer/topic_page.dart';
import 'package:timetrek/widgets/widgets.dart';

class SideDrawer extends StatefulWidget {

  SideDrawer({super.key});

  @override
  State<SideDrawer> createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {

  late String userId;
  int _selectedIndex = 2;
  String fullName = '';

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }


  @override
  Widget build(BuildContext context) {
    return Drawer(

      child: Container(
        decoration: bgBoxDecoration2,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [

            const SizedBox(height: 50,),

            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Icon(
                    Icons.account_circle,
                    size: 50,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 10.0),

                  Text(
                    fullName,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 15.0),
                  // Other widgets...
                ],
              ),
            ),

            const SizedBox(height: 10,),

            const Divider(thickness: 1, color: Colors.grey, height: 5,),

            //profile
            ListTile(
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                  nextScreenReplace(context, ProfilePage());
                });
              },
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 5),
              leading: const Icon(Icons.person, color: Colors.white,),
              title: Text(
                "Profile",
                style: TextStyle(
                  color: _selectedIndex == 0 ? Theme
                      .of(context)
                      .primaryColor : Colors.white,
                ),
              ),
            ),

            // //topic
            // ListTile(
            //   onTap: () {
            //     setState(() {
            //       _selectedIndex = 1;
            //       nextScreenReplace(context, const TopicPage());
            //     });
            //   },
            //   contentPadding: const EdgeInsets.symmetric(
            //       horizontal: 20, vertical: 5),
            //   leading: const Icon(Icons.topic, color: Colors.white,),
            //   title: Text(
            //     "Topic",
            //     style: TextStyle(
            //       color: _selectedIndex == 1 ? Theme
            //           .of(context)
            //           .primaryColor : Colors.white,
            //     ),
            //   ),
            // ),

            //groups
            ListTile(
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                  nextScreenReplace(context, const HomePage());
                });
              },
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 5),
              leading: const Icon(Icons.group, color: Colors.white,),
              title: Text(
                "Groups",
                style: TextStyle(
                  color: _selectedIndex == 2 ? Theme
                      .of(context)
                      .primaryColor : Colors.white,
                ),
              ),
            ),

            //settings
            ListTile(
              onTap: () {
                setState(() {
                  _selectedIndex = 3;
                  nextScreenReplace(context, const SettingsPage());
                });
              },
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 5),
              leading: const Icon(Icons.settings, color: Colors.white,),
              title: Text(
                "Settings",
                style: TextStyle(
                  color: _selectedIndex == 3 ? Theme
                      .of(context)
                      .primaryColor : Colors.white,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }


  fetchUserData() async {

    setState(() {
    });

    User? user = FirebaseAuth.instance.currentUser;
    userId = user!.uid;
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
    fullName = userData['fullName'];
    setState(() {
    });
  }
}

