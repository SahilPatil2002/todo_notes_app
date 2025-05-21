import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_notes_app/main.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Future.delayed(const Duration(seconds: 3), () {
    //   Get.off(() =>  MyHomePage());
    // });

    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          'Welcome to Todo Notes',
          style: TextStyle(
            // decorationStyle: TextDecorationStyle.dashed,
            // decoration: TextDecoration.underline,
            fontSize: 32,
            // fontWeight: FontWeight.bold,
            color: Colors.black,
            letterSpacing: 1.5,
            fontFamily: 'serrif',
          ),
        ),
      ),
    );
  }
}
