import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timetrek/helper/helper_function.dart';
import 'package:timetrek/pages/add_profile_page.dart';
import 'package:timetrek/services/auth_services.dart';
import 'package:timetrek/services/database_services.dart';
import 'package:timetrek/widgets/widgets.dart';

class OTPVerif extends StatefulWidget {

  late final String email;
  final String password;

  OTPVerif({
    super.key,
    required this.email,
    required this.password,
  });

  @override

  State<OTPVerif> createState() => _OTPVerifState();
}

class _OTPVerifState extends State<OTPVerif> {

  AuthService authService = AuthService();
  DatabaseService databaseService = DatabaseService();

  List<TextEditingController> otpControllers = List.generate(4, (_) => TextEditingController());
  String generatedOTP = "1234"; // Replace with your generated OTP

  bool _isLoading = false;

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    for (var controller in otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor),
        )
          : SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: bgBoxDecoration2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  const SizedBox(height: 150.0),

                  const Text(
                    'OTP Verification',
                    style: TextStyle(fontSize: 24.0,color: Colors.white),
                  ),

                  const SizedBox(height: 16.0),

                  Container(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Send on ',
                          style: TextStyle(fontSize: 18.0,color: Colors.white),
                        ),
                        Text(
                          widget.email,
                          style: TextStyle(fontSize: 18.0,color: Colors.white),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32.0),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      4,
                          (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: SizedBox(
                          width: 45.0,
                          height: 55,
                          child: TextField(
                            controller: otpControllers[index],
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 18.0),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white30,
                              counterText: '',
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10)
                              ),
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty && index < 3) {
                                FocusScope.of(context).nextFocus();
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32.0),

                  const Text(
                    'Dont receive the code?  Resend',
                    style: TextStyle(fontSize: 14.0,color: Colors.white),
                  ),

                  const SizedBox(height: 425.0),

                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)
                          )
                      ),
                      child: const Text(
                        "Confirm",
                        style:
                        TextStyle(
                            color: Colors.white,
                            fontSize: 16
                        ),
                      ),
                      onPressed: () {

                        String enteredOTP = otpControllers
                            .map((controller) => controller.text)
                            .join();
                        if (enteredOTP == generatedOTP) {
                          register(context);
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Invalid OTP'),
                                content: const Text('Please enter the correct 4-digit OTP.'),
                                actions: [
                                  ElevatedButton(
                                    child: const Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),

                  const SizedBox(height: 8.0),

                ],
              ),
            ),
          ),
        ),
    );
  }

  void register(BuildContext context) async {
    String userId;
    setState(() {
      _isLoading = true;
    });

    try {
      await authService.registerUserWithEmailandPassword(widget.email, widget.password).then((value) async {
        if (value == true) {
          // Saving the shared preference state
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(widget.email);

          // Get the user's ID from the created account
          UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: widget.email,
            password: widget.password,
          );
          userId = userCredential.user!.uid;

          // Redirect to the AddProfile if the data is added successfully
          nextScreenReplace(context, AddProfile(userId: userId));
        } else {
          showSnackbar(context, Colors.red, value);
        }
        setState(() {
          _isLoading = false;
        });
      });
    } catch (e) {
      // Handle any errors that occurred during registration
      print('Registration error: $e');
      showSnackbar(context, Colors.red, 'An error occurred during registration');
      setState(() {
        _isLoading = false;
      });
    }
  }
}