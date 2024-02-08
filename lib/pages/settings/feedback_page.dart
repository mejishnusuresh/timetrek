import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timetrek/pages/drawer/settings_page.dart';
import 'package:timetrek/widgets/widgets.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {

  late String userId;
  final _formKey = GlobalKey<FormState>();
  final feedbackController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void _submitFeedback() async {
    if (_formKey.currentState!.validate()) {
      final feedback = feedbackController.text;
      final email = emailController.text;
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final feedbackId = userId;

      await FirebaseFirestore.instance.collection('feedback').add({
        'feedback': feedback,
        'feedbackId': userId,
        'sender': email,
        'time': timestamp,
      });

      feedbackController.clear();
      emailController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Feedback submitted')),
      );
    }
  }

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

      body: SingleChildScrollView(
          child: Column(
            children: [

              Padding(
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: feedbackController,
                        decoration: InputDecoration(labelText: 'Feedback'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your feedback';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),
                      //email
                      TextFormField(
                        decoration: InputDecoration(labelText: "Your Email",),
                        controller: emailController,
                      ),
                      SizedBox(height: 16.0),
                      ElevatedButton(
                          onPressed: _submitFeedback,
                          child: Text('Submit Feedback'),
                      ),
                    ],
                  ),
                ),
              ),
            ]

          ),
      )
    );
  }

  Future fetchUserData() async {
    setState(() {
    });
    User? user = FirebaseAuth.instance.currentUser;
    userId = user!.uid;
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
    emailController.text = userData['email'];
    setState(() {
    });
  }


}