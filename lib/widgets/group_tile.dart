import 'package:flutter/material.dart';
import 'package:timetrek/pages/chat_page.dart';
import 'package:timetrek/widgets/widgets.dart';

class GroupTile extends StatefulWidget {

  final String fullName;
  final String groupId;
  final String groupName;

  const GroupTile({
    super.key,
    required this.fullName,
    required this.groupId,
    required this.groupName
  });

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nextScreen(
            context,
            ChatPage(
              groupId: widget.groupId,
              groupName: widget.groupName,
              userName: widget.fullName,
              activityId: '',
              activityPlace: '',
              activityName: '',
              activityTime: '',
            ));

      },
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white, // Set your desired background color
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor.withOpacity(0.2), // Shadow color
                spreadRadius: 2, // Spread radius
                blurRadius: 5, // Blur radius
                offset: Offset(0, 3), // Offset in the x, y direction
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                widget.groupName.substring(0, 1).toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
            title: Text(
              widget.groupName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "Join the conversation as ${widget.fullName}",
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ),
      ),
    );
  }
}