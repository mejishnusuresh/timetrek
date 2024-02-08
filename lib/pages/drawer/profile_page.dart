import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:timetrek/pages/drawer/home_page.dart';
import 'package:timetrek/services/auth_services.dart';
import 'package:timetrek/services/database_services.dart';
import 'package:timetrek/shared/constants.dart';
import 'package:timetrek/widgets/widgets.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    Key? key,
  }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthService authService = AuthService();
  DatabaseService databaseService = DatabaseService();

  late String userId;
  final formKey = GlobalKey<FormState>();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController professionController = TextEditingController();
  String? selectedPlace;
  String? selectedGender;

  Set<String> places = {
    'Thiruvananthapuram',
    'Kollam',
    'Pathanamthitta',
    'Alappuzha',
    'Kottayam',
    'Idukki',
    'Ernakulam',
    'Thrissur',
    'Palakkad',
    'Malappuram',
    'Kozhikode',
    'Wayanad',
    'Kannur',
    'Kasaragod',
  };
  Set<String> genders = {
    'Male',
    'Female',
    'Other',
  };

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          color: Colors.black,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            nextScreen(context, const HomePage());
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: formKey,
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Column(
                children: [

                  //editprofile
                  Container(
                    alignment: Alignment.topLeft,
                    child: const Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  //fullName
                  textField(
                    hindText: "Full Name",
                    icon: Icons.account_circle,
                    inputType: TextInputType.name,
                    maxLines: 1,
                    controller: fullNameController,
                    enabled: true,
                  ),

                  const SizedBox(height: 15),

                  //gender
                  SizedBox(
                    width: 370,
                    height: 55,
                    child: DropdownButtonFormField<String>(
                      value: selectedGender,
                      onChanged: (gender) {
                        setState(() {
                          selectedGender = gender;
                        });
                      },
                      items: genders.map((gender) {
                        return DropdownMenuItem<String>(
                          value: gender,
                          child: Text(gender),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          MdiIcons.genderMaleFemale,
                          size: 20,
                          color: Theme.of(context).primaryColor,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.transparent),
                        ),
                        hintText: "Gender",
                        alignLabelWithHint: true,
                        border: InputBorder.none,
                        fillColor: Theme.of(context).primaryColor.withOpacity(0.5),
                        filled: true,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  //email
                  textField(
                    enabled: false,
                    hindText: "Email",
                    icon: Icons.email,
                    inputType: TextInputType.emailAddress,
                    maxLines: 1,
                    controller: emailController,
                  ),

                  const SizedBox(height: 15),

                  //phone
                  textField(
                    hindText: "Phone",
                    icon: Icons.phone,
                    inputType: TextInputType.phone,
                    maxLines: 1,
                    controller: phoneController,
                    enabled: true,
                  ),

                  const SizedBox(height: 15),

                  //bio
                  textField(
                    hindText: "Bio",
                    icon: Icons.settings_accessibility,
                    inputType: TextInputType.text,
                    maxLines: 3,
                    controller: bioController,
                    enabled: true,
                  ),

                  const SizedBox(height: 15),

                  //profession
                  textField(
                    hindText: "Profession",
                    icon: Icons.work,
                    inputType: TextInputType.text,
                    maxLines: 1,
                    controller: professionController,
                    enabled: true,
                  ),

                  const SizedBox(height: 15),

                  //place
                  SizedBox(
                    width: 370,
                    height: 55,
                    child: DropdownButtonFormField<String>(
                      value: selectedPlace,
                      onChanged: (place) {
                        setState(() {
                          selectedPlace = place;
                        });
                      },
                      items: places.map((place) {
                        return DropdownMenuItem<String>(
                          value: place,
                          child: Text(place),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          MdiIcons.mapMarker,
                          size: 20,
                          color: Theme.of(context).primaryColor,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.transparent),
                        ),
                        hintText: "Place",
                        alignLabelWithHint: true,
                        border: InputBorder.none,
                        fillColor: Theme.of(context).primaryColor.withOpacity(0.5),
                        filled: true,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  //updatebutton
                  SizedBox(
                    width: 370,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        submitProfile();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        backgroundColor: Constants().impButtonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: const Text(
                        'UPDATE',
                        style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 2.2,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget textField({
    required bool enabled,
    required String hindText,
    required IconData icon,
    required TextInputType inputType,
    required int maxLines,
    required TextEditingController controller,
  }) {
    return TextFormField(
      enabled: enabled,
      cursorColor: Theme.of(context).primaryColor,
      controller: controller,
      keyboardType: inputType,
      maxLines: maxLines,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        hintText: hindText,
        alignLabelWithHint: true,
        border: InputBorder.none,
        fillColor: Theme.of(context).primaryColor.withOpacity(0.5),
        filled: true,
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter $hindText";
        }
        return null;
      },
    );
  }

  Future fetchUserData() async {
    setState(() {
    });

    User? user = FirebaseAuth.instance.currentUser;
    userId = user!.uid;

    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();

    Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;

    fullNameController.text = userData['fullName'];
    selectedGender = userData['gender'];
    emailController.text = userData['email'];
    phoneController.text = userData['phone'];
    bioController.text = userData['bio'];
    professionController.text = userData['profession'];
    selectedPlace = userData['place'];

    setState(() {
    });
  }

  Future submitProfile() async {
    try {
      if (formKey.currentState!.validate()) {
        setState(() {
        });

        await FirebaseFirestore.instance.collection('users').doc(userId).update({
          'fullName': fullNameController.text,
          'gender': selectedGender,
          'phone': phoneController.text,
          'bio': bioController.text,
          'profession': professionController.text,
          'place': selectedPlace,
        });

        nextScreenReplace(context, const HomePage());
      }
    } catch (error) {
      setState(() {
      });
      print(error);
      // Handle the error appropriately
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    bioController.dispose();
    professionController.dispose();
    super.dispose();
  }
}
