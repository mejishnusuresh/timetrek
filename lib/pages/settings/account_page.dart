import 'package:flutter/material.dart';
import 'package:timetrek/pages/auth/login_page.dart';
import 'package:timetrek/pages/drawer/settings_page.dart';
import 'package:timetrek/services/auth_services.dart';
import 'package:timetrek/shared/constants.dart';
import 'package:timetrek/widgets/widgets.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            nextScreen(context, const SettingsPage());
          },
        ),
      ),

      body: ListView(
        children: <Widget>[

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.topLeft,
            child: const Text(
              'Account Settings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          SizedBox(height: 10,),

          ListTile(
            onTap: () async {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Delete Account"),
                      content: const Text("Are you sure you want to Delete your Account?"),
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
                            await authService.deleteUserAccount();
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
            leading: const Icon(Icons.delete_forever_outlined),
            title: const Text(
              "Delete Account",
              style: TextStyle(color: Colors.black),
            ),
          )


        ],

      ),
    );
  }

}
