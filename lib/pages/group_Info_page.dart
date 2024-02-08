import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timetrek/pages/drawer/home_page.dart';
import 'package:timetrek/services/database_services.dart';
import 'package:timetrek/shared/constants.dart';
import 'package:timetrek/widgets/widgets.dart';

class GroupInfo extends StatefulWidget {

  final String groupId;
  final String groupName;
  final String adminName;

  const GroupInfo({
    super.key,
    required this.groupId,
    required this.groupName,
    required this.adminName
  });

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {

  Stream? members;

  @override
  void initState() {
    getMembers();
    super.initState();
  }

  getMembers() async {
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupMembers(widget.groupId)
        .then((val) {
      setState(() {
        members = val;
      });
    });
  }

  String getName(String r) {
    int underscoreIndex = r.indexOf("_");
    if (underscoreIndex != -1 && underscoreIndex < r.length - 1) {
      return r.substring(underscoreIndex + 1);
    }
    return "Invalid Name";
  }

  String getId(String res) {
    int underscoreIndex = res.indexOf("_");

    if (underscoreIndex != -1) {
      return res.substring(0, underscoreIndex);
    }
    return "Invalid ID";
  }

  @override
  Widget build(BuildContext context) {

    bool isAdmin = FirebaseAuth.instance.currentUser?.uid == getId(widget.adminName);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme
            .of(context)
            .primaryColor,
        title: const Text("Group Info"),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Exit"),
                        content:
                        const Text("Are you sure you exit the group? "),
                        actions: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.cancel,
                              color: Colors.red,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              DatabaseService(
                                  uid: FirebaseAuth
                                      .instance.currentUser!.uid)
                                  .toggleGroupJoin(
                                  widget.groupId,
                                  getName(widget.adminName),
                                  widget.groupName)
                                  .whenComplete(() {
                                nextScreenReplace(context, const HomePage());
                              });
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
              icon: const Icon(Icons.exit_to_app))
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Theme
                      .of(context)
                      .primaryColor
                      .withOpacity(0.2)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme
                        .of(context)
                        .primaryColor,
                    child: Text(
                      widget.groupName.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Group: ${widget.groupName}",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text("Admin: ${getName(widget.adminName)}")
                    ],
                  )
                ],
              ),
            ),
            memberList(),

            SizedBox(height: 20,),

            isAdmin
              ? Container(
                height: 50,
                width: 350,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Theme
                        .of(context)
                        .primaryColor
                        .withOpacity(0.8)
                ),
                child: GestureDetector(
                  onTap: () async {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Delete Group"),
                            content: const Text(
                                "Are you sure you want to Delete Group?"),
                            actions: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  Icons.cancel,
                                  color: Constants().impButtonColor,
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  // Delete group
                                  await DatabaseService().deleteGroup(widget.groupId);

                                  // Toggle group join
                                  await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                                      .toggleGroupJoin(
                                    widget.groupId,
                                    getName(widget.adminName),
                                    widget.groupName,
                                  )
                                      .whenComplete(() {
                                    // Navigate to home page
                                    nextScreenReplace(context, const HomePage());
                                  });
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
                  child: Center(
                    child: const Text(
                      'Delete Group',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
              :Container(),

          ],
        ),
      ),
    );
  }

  Widget memberList() {
    return StreamBuilder(
      stream: members,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          final membersData = snapshot.data?['members'];
          if (membersData != null && membersData.length > 0) {
            return ListView.builder(
              itemCount: membersData.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final member = membersData[index];
                if (member is String && member.isNotEmpty) {
                  String name = getName(member);
                  String id = getId(member);
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5, vertical: 10),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Theme
                            .of(context)
                            .primaryColor,
                        child: Text(
                          getName(member).substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(getName(member)),
                      subtitle: Text(getId(member)),
                    ),
                  );
                } else {
                  return const Center(
                    child: Text("NO MEMBERS"),
                  );
                }
              },
            );
          } else {
            return const Center(
              child: Text("NO MEMBERS"),
            );
          }
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Error: ${snapshot.error}"),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Theme
                  .of(context)
                  .primaryColor,
            ),
          );
        }
      },
    );
  }
}