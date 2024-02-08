import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:timetrek/helper/helper_function.dart';
import 'package:timetrek/pages/auth/forgot_password_page.dart';
import 'package:timetrek/pages/auth/register_page.dart';
import 'package:timetrek/pages/drawer/home_page.dart';
import 'package:timetrek/services/auth_services.dart';
import 'package:timetrek/services/database_services.dart';
import 'package:timetrek/widgets/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool _isPasswordVisible = true;
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _isLoading = false;
  AuthService authService = AuthService();

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }
  void _navigateToForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const ForgotPasswordPage()
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: _isLoading
          ? Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor),
          )
          : LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: bgBoxDecoration,
                child: Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [

                        const SizedBox(height: 50.0),

                        //timetrek logo
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 200,
                              height: 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Image.asset(
                                'assets/icons/logotexticon.png',
                                width: 250,
                                height: 180,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 50.0),

                        //image
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 360,
                              height: 160,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Image.asset(
                                'assets/images/login.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30.0),

                        //welcomeback text
                        const Text(
                          'Login now to see what they are talking!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 30.0),

                        //email text field
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                            labelText: "Email",
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Icon(
                              Icons.email,
                              color: Theme
                                  .of(context)
                                  .primaryColor,
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          onChanged: (val) {
                            setState(() {
                              email = val;
                            });
                          },

                          // check tha validation
                          validator: (val) {
                            return RegExp(
                                r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                                .hasMatch(val!)
                                ? null
                                : "Please enter a valid email";
                          },
                        ),

                        const SizedBox(height: 15.0),

                        //password text field
                        TextFormField(
                          obscureText: _isPasswordVisible,
                          decoration: textInputDecoration.copyWith(
                              filled: true,
                              fillColor: Colors.white,
                              labelText: "Password",
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Theme
                                    .of(context)
                                    .primaryColor,
                              ),
                              suffixIcon: GestureDetector(
                                onTap: _togglePasswordVisibility,
                                child: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                              )
                          ),
                          textInputAction: TextInputAction.done,
                          validator: (val) {
                            if (val!.length < 6) {
                              return "Password must be at least 6 characters";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (val) {
                            setState(() {
                              password = val;
                            });
                          },
                        ),

                        //forgot password
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: _navigateToForgotPassword,
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 120.0),

                        //sign in button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Theme
                                    .of(context)
                                    .primaryColor,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)
                                )
                            ),
                            child: const Text(
                              "Sign In",
                              style:
                              TextStyle(
                                  color: Colors.white,
                                  fontSize: 18
                              ),
                            ),
                            onPressed: () {
                              login();
                            },
                          ),
                        ),

                        const SizedBox(height: 30.0),

                        //OR continue with divider
                        const Row(
                          children: [
                            Expanded(
                              child: Divider(
                                thickness: 1,
                                color: Colors.black,
                              ),
                            ),
                            // Padding(
                            //   padding: EdgeInsets.symmetric(horizontal: 10.0),
                            //   child: Text(
                            //     'Or Continue with',
                            //     //textAlign: TextAlign.center,
                            //     style: TextStyle(
                            //       fontFamily: 'Plus Jakarta Sans',
                            //       color: Colors.white60,
                            //       fontSize: 14,
                            //       fontWeight: FontWeight.w500,
                            //     ),
                            //   ),
                            // ),
                            Expanded(
                              child: Divider(
                                thickness: 1,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),

                        // const SizedBox(height: 15.0),
                        //
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //
                        //     //continue with google
                        //     GestureDetector(
                        //       onTap: () => AuthService().signInWithGoogle(),
                        //       child: Container(
                        //         width: 45,
                        //         height: 45,
                        //         padding: const EdgeInsets.all(2.0),
                        //         decoration: BoxDecoration(
                        //           border: Border.all(color: Colors.white),
                        //           borderRadius: BorderRadius.circular(16),
                        //           color: Colors.grey[200],
                        //         ),
                        //         child: Image.asset(
                        //           'assets/icons/google.png',
                        //           height: 15,
                        //         ),
                        //       ),
                        //     ),
                        //
                        //     const SizedBox(width: 15.0),
                        //
                        //     //continue with appple
                        //     GestureDetector(
                        //       //onTap: () => AuthService().signInWithApple(),
                        //       child: Container(
                        //         width: 45,
                        //         height: 45,
                        //         padding: const EdgeInsets.all(2.0),
                        //         decoration: BoxDecoration(
                        //           border: Border.all(color: Colors.white),
                        //           borderRadius: BorderRadius.circular(16),
                        //           color: Colors.grey[200],
                        //         ),
                        //         child: Image.asset(
                        //           'assets/icons/apple.png',
                        //           height: 15,
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),

                        const SizedBox(height: 15.0),

                        //not a member sign up
                        Text.rich(
                            TextSpan(
                              text: "Don't have an account? ",
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 14),
                              children: <TextSpan>[
                                TextSpan(
                                    text: "Register here",
                                    style: const TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        nextScreen(
                                            context, const RegisterPage());
                                      }
                                ),
                              ],
                            )
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          )
    );
  }

  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      final value = await authService.loginWithUserNameandPassword(email, password);
      if (value == true) {
        final snapshot = await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).gettingUserData(email);
        // saving the values to our shared preferences
        await HelperFunctions.saveUserLoggedInStatus(true);
        await HelperFunctions.saveUserEmailSF(email);
        await HelperFunctions.saveUserNameSF(snapshot.docs[0]['userName']);
        nextScreenReplace(context, const HomePage());
      } else {
        showSnackbar(context, Colors.red, value);
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}