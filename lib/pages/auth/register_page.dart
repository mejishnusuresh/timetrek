import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:timetrek/helper/helper_function.dart';
import 'package:timetrek/pages/add_profile_page.dart';
import 'package:timetrek/pages/auth/otp_verify_page.dart';
import 'package:timetrek/pages/auth/login_page.dart';
import 'package:timetrek/services/auth_services.dart';
import 'package:timetrek/widgets/widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  bool _isLoading = false;
  bool _isPasswordVisible = true;
  final formKey = GlobalKey<FormState>();

  String email = "";
  String password = "";
  String confirmPassword = "";
  String type= 'user';

  AuthService authService = AuthService();

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
                                'assets/images/register.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30.0),

                        //welcomeback text
                        const Text(
                          'Create your account to plan and explore! ',
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

                        // Password text field
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
                            ),
                          ),
                          textInputAction: TextInputAction.next,
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

                        const SizedBox(height: 15.0),

                        // Confirm password text field
                        TextFormField(
                          obscureText: true,
                          decoration: textInputDecoration.copyWith(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "Confirm Password", // Updated label text
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Theme
                                  .of(context)
                                  .primaryColor,
                            ),
                          ),
                          textInputAction: TextInputAction.done,
                          validator: (val) {
                            if (val !=
                                password) { // Compare with the password field
                              return "Passwords do not match";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (val) {
                            setState(() {
                              confirmPassword = val;
                            });
                          },
                        ),

                        const SizedBox(height: 90.0),

                        //sign in button
                        SizedBox(
                          height: 50,
                          width: double.infinity,
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
                                  fontSize: 16
                              ),
                            ),
                            onPressed: () {
                              register();
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
                              text: "Already have an account? ",
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 14),
                              children: <TextSpan>[
                                TextSpan(
                                    text: "Login now",
                                    style: const TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        nextScreen(context, const LoginPage());
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
          ),
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  Future<void> register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      nextScreenReplace(context,  OTPVerif(email: email, password: password));

    }
  }
}