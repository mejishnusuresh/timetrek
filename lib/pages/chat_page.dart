import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timetrek/pages/group_Info_page.dart';
import 'package:timetrek/services/database_services.dart';
import 'package:timetrek/widgets/message_tile.dart';
import 'package:timetrek/widgets/widgets.dart';

class ChatPage extends StatefulWidget {

  final String groupId;
  final String groupName;
  final String userName;
  final String activityId;
  final String activityName;
  final String activityPlace;
  final String activityTime;

  const ChatPage({
    super.key,
    required this.groupId,
    required this.groupName,
    required this.userName,
    required this.activityId,
    required this.activityName,
    required this.activityPlace,
    required this.activityTime,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  TextEditingController activityNameController = TextEditingController();
  TextEditingController activityPlaceController = TextEditingController();
  TextEditingController activityDNTController = TextEditingController();

  String admin = "";
  String userId ="";
  String? activityName;
  Stream? activity;
  String type = "";
  bool _isLoading = false;
  bool _showActivity = true;

  @override
  void initState() {
    getChatandAdmin();
    fetchActivity();
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (_scrollController.hasClients && chats != null) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  // string manipulation
  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  getChatandAdmin() {
    DatabaseService().getChats(widget.groupId).then((val) {
      setState(() {
        chats = val;
      });
    });
    DatabaseService().getGroupAdmin(widget.groupId).then((val) {
      setState(() {
        admin = val;
      });
    });
  }

  Future fetchActivity() async {
    try{
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('groups').doc(widget.groupId).get();
      Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
      activityNameController.text = userData['activityName'];
      activityPlaceController.text = userData['activityPlace'];
      activityDNTController.text = userData['activityDate'];
      type=userData['type'];

      print(activityNameController.text);
      print(activityPlaceController.text);
      print(activityDNTController.text);
    } catch (error) {
      setState(() {
      });
      print(error);
      // Handle the error appropriately
    }
  }

  Future submitActivity() async {
    try {
        await FirebaseFirestore.instance.collection('groups').doc(widget.groupId).update({
          'activityName': activityNameController.text,
          'activityPlace': activityPlaceController.text,
          'activityDate': activityDNTController.text,
        });
    } catch (error) {
      setState(() {
      });
      print(error);
      // Handle the error appropriately
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(widget.groupName),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(
                    context,
                    GroupInfo(
                      groupId: widget.groupId,
                      groupName: widget.groupName,
                      adminName: admin,
                    ));
              },
              icon: const Icon(Icons.info))
        ],
      ),
      body: Stack(
        children: <Widget>[

          Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/bg/bgimage1.jpg'),
                  fit: BoxFit.cover,
                  opacity: 0.7,
                ),
            ),
          ),

          Positioned.fill(
            child: Column(
              children: [




                Container(
                  alignment: Alignment.topCenter,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    width: MediaQuery.of(context).size.width,
                    height: 120,
                    color: Colors.grey[700],



                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                const SizedBox(
                                  width: 125,
                                  height: 25,
                                  child: Text(
                                    'Activity Name:',
                                    style: TextStyle(color: Colors.white, fontSize: 16),
                                  ),
                                ),
                                SizedBox(
                                  width: 240,
                                  height: 25,
                                  child: TextFormField(
                                    controller: activityNameController,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: textInputDecoration,
                                    onChanged: (newValue) {
                                      submitActivity(); // Update Firebase on text change
                                    },
                                  ),
                                ),

                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                const SizedBox(
                                  width: 125,
                                  height: 25,
                                  child: Text(
                                    'Activity Place:',
                                    style: TextStyle(color: Colors.white, fontSize: 16),
                                  ),
                                ),
                                SizedBox(
                                  width: 240,
                                  height: 25,
                                  child: TextFormField(
                                    controller: activityPlaceController,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: textInputDecoration,
                                    onChanged: (newValue) {
                                      submitActivity(); // Update Firebase on text change
                                    },
                                    ),
                                  ),

                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                const SizedBox(
                                  width: 125,
                                  height: 25,
                                  child: Text(
                                    'Activity Time:',
                                    style: TextStyle(color: Colors.white, fontSize: 16),
                                  ),
                                ),
                                SizedBox(
                                  width: 240,
                                  height: 25,
                                  child: TextFormField(
                                    controller: activityDNTController,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: textInputDecoration,
                                    onChanged: (newValue) {
                                      submitActivity(); // Update Firebase on text change
                                    },
                                  ),
                                ),

                              ],
                            ),

                          ],
                        ),
                      )







                  ),
                ),

                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: chatMessages(), // Show chat messages here
                  ),
                ),

                Container(
                  alignment: Alignment.bottomCenter,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20,),
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    color: Colors.grey[700],
                    child: Row(
                        children: [
                          Expanded(
                              child: TextFormField(
                                controller: messageController,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  hintText: "Send a message...",
                                  hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                                  border: InputBorder.none,
                                ),
                              )
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          GestureDetector(
                            onTap: () {
                              sendMessage();
                            },
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Center(
                                  child: Icon(
                                    Icons.send,
                                    color: Colors.white,
                                  )),
                            ),
                          )
                        ]
                    ),
                  ),
                ),

              ],
            ),
          ),

        ],

      ),
    );
  }

  chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snapshot) {
        if (_scrollController != null && snapshot.hasData) {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
          });

          return ListView.builder(
            controller: _scrollController,
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              return MessageTile(
                  message: snapshot.data.docs[index]['message'],
                  sender: snapshot.data.docs[index]['sender'],
                  sentByMe: widget.userName == snapshot.data.docs[index]['sender']);
            },
          );
        } else {
          return Container();
        }
      },
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": widget.userName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseService().sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        messageController.clear();
      });
    }
  }
}