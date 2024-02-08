import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  // reference for our collections
  final CollectionReference userCollection =
  FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection =
  FirebaseFirestore.instance.collection("groups");

  // saving the userdata
  Future savingUserData(String email) async {
    return await userCollection.doc(uid).set({
      "fullName": "",
      "email": email,
      "type": "",
      "groups": [],
      "phone": "",
      "bio": "",
      "gender": "",
      "profession": "",
      "place": "",
      "profilePic": "",
      "uid": uid,
    });
  }

  // getting user data
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
    await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  // get user groups
  getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }
  //get all groups
  Future<QuerySnapshot> getAllGroups() async {
    return await FirebaseFirestore.instance.collection('groups').get();
  }  z


  // creating a group
  Future createGroup(String fullName, String id, String groupName) async {
    DocumentReference groupDocumentReference = await groupCollection.add({
      "groupName": groupName,
      "groupIcon": "",
      "admin": "${id}_$fullName",
      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": "",
      "activityId":"",
      "activityName":"",
      "activityDate":"",
      "activityPlace":"",

    });

    // update the members
    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$fullName"]),
      "groupId": groupDocumentReference.id,
    });

    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      "groups":
      FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])
    });
  }

  // getting the chats
  getChats(String groupId) async {
    return groupCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  Future getGroupAdmin(String groupId) async {
    DocumentReference d = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }

  // get group members
  getGroupMembers(groupId) async {
    return groupCollection.doc(groupId).snapshots();
  }

  // search
  searchByName(String groupName) {
    return groupCollection.where("groupName", isEqualTo: groupName).get();
  }

  // function -> bool
  Future<bool> isUserJoined(
      String groupName, String groupId, String fullName) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> groups = await documentSnapshot['groups'];
    if (groups.contains("${groupId}_$groupName")) {
      return true;
    } else {
      return false;
    }
  }

  // toggling the group join/exit
  Future toggleGroupJoin(
      String groupId, String fullName, String groupName) async {
    // doc reference
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);

    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];

    // if user has our groups -> then remove then or also in other part re join
    if (groups.contains("${groupId}_$groupName")) {
      await userDocumentReference.update({
        "groups": FieldValue.arrayRemove(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayRemove(["${uid}_$fullName"])
      });
    } else {
      await userDocumentReference.update({
        "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayUnion(["${uid}_$fullName"])
      });
    }
  }

  // send message
  sendMessage(String groupId, Map<String, dynamic> chatMessageData) async {
    groupCollection.doc(groupId).collection("messages").add(chatMessageData);
    groupCollection.doc(groupId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString(),
    });
  }

  // delete user data
  Future deleteUserData() async {
    try {
      if (uid != null) {
        await userCollection.doc(uid).delete();
      }
    } catch (e) {
      print("Error deleting user data: $e");
    }
  }

  // delete a group
  Future deleteGroup(String groupId) async {
    try {
      DocumentReference groupDocumentReference = groupCollection.doc(groupId);

      // Delete the group document
      await groupDocumentReference.delete();

      // Delete the subcollection of messages
      QuerySnapshot messagesSnapshot =
      await groupDocumentReference.collection('messages').get();
      for (QueryDocumentSnapshot messageSnapshot in messagesSnapshot.docs) {
        await messageSnapshot.reference.delete();
      }

      // Remove the group ID from users' groups list
      QuerySnapshot userSnapshots =
      await userCollection.where("groups", arrayContains: groupId).get();
      for (QueryDocumentSnapshot userSnapshot in userSnapshots.docs) {
        Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;

        if (userData != null && userData.containsKey('groups')) {
          List<dynamic> userGroups = List.from(userData['groups']);
          userGroups.remove(groupId);
          await userSnapshot.reference.update({'groups': userGroups});
        }
      }
    } catch (e) {
      print("Error deleting group: $e");
    }
  }
}




