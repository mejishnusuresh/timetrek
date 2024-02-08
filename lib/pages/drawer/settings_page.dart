import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:timetrek/pages/settings/account_page.dart';
import 'package:timetrek/pages/auth/login_page.dart';
import 'package:timetrek/pages/drawer/drawer.dart';
import 'package:timetrek/pages/drawer/home_page.dart';
import 'package:timetrek/pages/settings/feedback_page.dart';
import 'package:timetrek/services/auth_services.dart';
import 'package:timetrek/shared/constants.dart';
import 'package:timetrek/widgets/widgets.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      drawer: SideDrawer(),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            nextScreen(context, const HomePage());
          },
        ),
      ),

      body: ListView(
        children: <Widget>[

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.topLeft,
            child: const Text(
              'Settings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          SizedBox(height: 10,),

          ListTile(
            leading: Icon(Icons.manage_accounts_outlined),
            title: Text('Account'),
            onTap: () {
              nextScreen(context, AccountPage());
            },
          ),

          ListTile(
            leading: Icon(Icons.feedback_outlined),
            title: Text('Feedback'),
            onTap: () {
              nextScreen(context, FeedbackPage());
            },
          ),

          ListTile(
            leading: Icon(Icons.my_library_books_outlined),
            title: Text('Terms of Use'),
            onTap: () {
              // Navigate to the terms of use page
            },
          ),

          ListTile(
            leading: Icon(Icons.question_mark),
            title: Text('FAQs'),
            onTap: () {
              // Navigate to the FAQs page
            },
          ),

          ListTile(
            onTap: () async {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Logout"),
                      content: const Text("Are you sure you want to logout?"),
                      actions: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon:  Icon(
                            Icons.cancel,
                            color: Constants().impButtonColor,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await authService.signOut();
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                                    (route) => false);
                          },
                          icon: const Icon(
                            Icons.done,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    );
                  });
            },
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(Icons.logout),
            title: const Text(
              "Logout",
              style: TextStyle(color: Colors.black),
            ),
          )


        ],

      ),
    );
  }

}
