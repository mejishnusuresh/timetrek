import 'package:firebase_auth/firebase_auth.dart';
import 'package:timetrek/helper/helper_function.dart';
import 'package:timetrek/services/database_services.dart';

class AuthService {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // login
  Future loginWithUserNameandPassword(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password))
          .user!;

      if (user != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // register
  Future registerUserWithEmailandPassword(
      String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password,))
          .user!;

      if (user != null) {
        // call our database service to update the user data.
        await DatabaseService(uid: user.uid).savingUserData(email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // //google sign in
  // signInWithGoogle() async {
  //
  //   //begin interactive sign in process
  //   final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
  //
  //   //obtain auth details from request
  //   final GoogleSignInAuthentication gAuth = await gUser!.authentication;
  //
  //   //create new credential for user
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: gAuth.accessToken,
  //     idToken: gAuth.idToken,
  //   );
  //
  //   //sign in
  //   return await FirebaseAuth.instance.signInWithCredential(credential);
  //
  // }

  // signout
  Future signOut() async {
    try {
      await HelperFunctions.saveUserLoggedInStatus(false);
      await HelperFunctions.saveUserEmailSF("");
      await HelperFunctions.saveUserNameSF("");
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }

  //delete user account
  Future deleteUserAccount() async {
    try {
      User? user = firebaseAuth.currentUser;

      if (user != null) {
        // Delete user data from the database
        await DatabaseService(uid: user.uid).deleteUserData();

        // Delete the user account
        await user.delete();

        // Sign out the user
        await signOut();

        return true;
      }
    } catch (e) {
      return e.toString(); // Return the error message if any
    }
  }
}
