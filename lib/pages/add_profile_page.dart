import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:timetrek/pages/drawer/home_page.dart';
import 'package:timetrek/services/auth_services.dart';
import 'package:timetrek/services/database_services.dart';
import 'package:timetrek/widgets/widgets.dart';

class AddProfile extends StatefulWidget {
  final String userId;

  const AddProfile({
    super.key,
    required this.userId,
  });

  @override
  _AddProfileState createState() => _AddProfileState();
}

class _AddProfileState extends State<AddProfile> {

  AuthService authService = AuthService();
  DatabaseService databaseService = DatabaseService();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String? selectedPlace;
  String? selectedGender;
  String? selectedType;

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

  Set<String> types = {
    'User',
    'Agent',
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

                  const SizedBox(height: 60),

                  Container(
                    alignment: Alignment.topLeft,
                    child: const Text(
                      'Add Profile',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  //type
                  SizedBox(
                    width: 370,
                    height: 55,
                    child: DropdownButtonFormField<String>(
                      value: selectedType,
                      onChanged: (type) {
                        setState(() {
                          selectedType = type;
                        });
                      },
                      items: types.map((type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.admin_panel_settings_outlined,
                          size: 20,
                          color: Theme.of(context).primaryColor,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.transparent),
                        ),
                        hintText: "Type",
                        alignLabelWithHint: true,
                        border: InputBorder.none,
                        fillColor: Theme.of(context).primaryColor.withOpacity(0.5),
                        filled: true,
                      ),
                      validator: (value) {
                        if (value == null) {
                          return 'Please select an item';
                        }
                        return null;
                      },
                    ),
                  ),

                  const SizedBox(height: 15),

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

                  textField(
                    enabled: false,
                    hindText: "Email",
                    icon: Icons.email,
                    inputType: TextInputType.emailAddress,
                    maxLines: 1,
                    controller: emailController,
                  ),

                  const SizedBox(height: 15),

                  textField(
                    hindText: "Phone",
                    icon: Icons.phone,
                    inputType: TextInputType.phone,
                    maxLines: 1,
                    controller: phoneController,
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
                  const SizedBox(height: 150),

                  //lets go
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          submitProfile();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: const Text(
                        'Let\'s GO',
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
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
      ),
    );
  }

  Future fetchUserData() async {
    setState(() {
      _isLoading = true;
    });

    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(widget.userId).get();

    // Get the user's data from the snapshot
    Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
    emailController.text = userData['email'];
    setState(() {
      _isLoading = false;
    });
  }

  Future submitProfile() async {
    try{
      if (formKey.currentState!.validate()) {
        setState(() {
          _isLoading = true;
        });

        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .update({

          'type': selectedType,
          'fullName': fullNameController.text,
          'gender':selectedGender,
          'phone': phoneController.text,
          'place': selectedPlace,
        });

        nextScreenReplace(context, const HomePage());
      }
    }catch (error) {
      setState(() {
        _isLoading = false;
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
    super.dispose();
  }

}
