import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timetrek/helper/helper_function.dart';
import 'package:timetrek/pages/drawer/drawer.dart';
import 'package:timetrek/services/auth_services.dart';
import 'package:timetrek/services/database_services.dart';
import 'package:timetrek/widgets/group_tile.dart';
import 'package:timetrek/widgets/widgets.dart';

class GroupTab extends StatefulWidget {
  const GroupTab({super.key});

  @override
  State<GroupTab> createState() => _GroupTabState();
}

class _GroupTabState extends State<GroupTab> {

  String userId ="";
  String fullName = "";
  String email = "";
  String type = "";
  AuthService authService = AuthService();
  late Stream groups;
  String groupName = "";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    gettingUserData();
    fetchUserData();
  }

  // string manipulation
  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  gettingUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
    // getting the list of snapshots in our stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  Future fetchUserData() async {
    setState(() {
    });
    User? user = FirebaseAuth.instance.currentUser;
    userId = user!.uid;
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
    fullName = userData['fullName'];
    type = userData['type'];
    print(type);
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      drawer: SideDrawer(),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Groups",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        actions: const [
          // Switch(
          //   activeColor: Colors.lightGreen,
          //   activeTrackColor: Colors.cyan,
          //   inactiveThumbColor: Colors.blueGrey.shade600,
          //   inactiveTrackColor: Colors.grey.shade400,
          //   splashRadius: 50.0,
          //   value: _showGroups,
          //   onChanged: (value) {
          //     setState(() {
          //       _showGroups = value;
          //     });
          //   },
          // ),
          SizedBox(width: 16),
        ],

        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.person,
                color: Colors.white,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),



      body: groupList(),

      floatingActionButton: type=="Agent" ? null : FloatingActionButton(
        onPressed: () {
          popUpDialog(context);
        },
        elevation: 0,
        tooltip: "Create Group",
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(
          Icons.group_add,
          color: Colors.white,
          size: 30,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

    );
  }

  groupList() {
    // if (!_showGroups) {
    //   return const SizedBox.shrink(); // If switch is off, don't show any groups
    // }
    return FutureBuilder(
      // Introduce a delay using Future.delayed
      future: Future.delayed( const Duration(milliseconds: 100)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        } else {
          return StreamBuilder(
            stream: groups,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data['groups'] != null) {
                  if (snapshot.data['groups'].length != 0) {
                    return ListView.builder(
                      itemCount: snapshot.data['groups'].length,
                      itemBuilder: (context, index) {
                        int reverseIndex = snapshot.data['groups'].length - index - 1;
                        return GroupTile(
                            groupId: getId(snapshot.data['groups'][reverseIndex]),
                            groupName: getName(snapshot.data['groups'][reverseIndex]),
                            fullName: snapshot.data['fullName']);
                      },
                    );
                  } else {
                    return noGroupWidget();
                  }
                } else {
                  return noGroupWidget();
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor),
                );
              }
            },
          );
        }
      }
    );
  }

  noGroupWidget() {
    if (type=="Agent") {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              "You've not joined any groups, Search for groups to join ",
              textAlign: TextAlign.center,
            )
          ],
        ),
      );
    }else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                popUpDialog(context);
              },
              child: Icon(
                Icons.add_circle,
                color: Colors.grey[700],
                size: 75,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "You've not joined any groups, tap on the add icon to create a group or search ",
              textAlign: TextAlign.center,
            )
          ],
        ),
      );
    }
  }

  popUpDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: ((context, setState) {
            return AlertDialog(
              title: const Text(
                "Create a group",
                textAlign: TextAlign.left,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _isLoading == true
                      ? Center(
                    child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor),
                  )
                      : TextField(
                    onChanged: (val) {
                      setState(() {
                        groupName = val;
                      });
                    },
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(20)),
                        errorBorder: OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(20)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(20))),
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor),
                  child: const Text("CANCEL"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (groupName != "") {
                      setState(() {
                        _isLoading = true;
                      });
                      DatabaseService(
                          uid: FirebaseAuth.instance.currentUser!.uid)
                          .createGroup(fullName,
                          FirebaseAuth.instance.currentUser!.uid, groupName)
                          .whenComplete(() {
                        _isLoading = false;
                      });
                      Navigator.of(context).pop();
                      showSnackbar(
                          context, Colors.green, "Group created successfully.");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor),
                  child: const Text("CREATE"),
                )
              ],
            );
          }));
        }
    );
  }

}

