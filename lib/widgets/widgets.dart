import 'package:flutter/material.dart';

InputDecoration textInputDecoration = InputDecoration(

  labelStyle: const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w300,
  ),

  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
  ),

  focusedBorder:const OutlineInputBorder(
    borderSide:  BorderSide (
        color: Colors.blue,
        width: 2
    ),
  ),
  enabledBorder:const OutlineInputBorder(
    borderSide:  BorderSide (
        color: Colors.white,
        width: 2
    ),
  ),
  errorBorder:const OutlineInputBorder(
    borderSide:  BorderSide (
        color: Colors.red,
        width: 2
    ),


  ),

);

const bgBoxDecoration = BoxDecoration(

  gradient: LinearGradient(

    colors: [Color(0xFF4B39EF), Color(0xFFEE8B60)],
    stops: [0, 1],
    begin: AlignmentDirectional(0.87, -1),
    end: AlignmentDirectional(-0.87, 1),
  ),

);

const bgBoxDecoration2 = BoxDecoration(

  gradient: LinearGradient(
    colors: [Color(0xFF3a6186),Color(0xFF89253e)],
    //colors: [Color(0xFFC31432), Color(0xFF240B36)],
    stops: [0, 1],
    begin: AlignmentDirectional(0.87, -1),
    end: AlignmentDirectional(-0.87, 1),
  ),

);

// #c31432
// →
// #240b36

void nextScreen(context, page){

  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => page
      )
  );
}

void nextScreenReplace(context, page) {
  Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => page
      )
  );
}

void showSnackbar(context, color, message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontSize: 14),
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: "OK",
          onPressed: () {},
          textColor: Colors.white,
        ),
      ),
    );

}
