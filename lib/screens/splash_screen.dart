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
            fontSize: 32,
            color: Colors.black,
            letterSpacing: 1.5,
            fontFamily: 'serrif',
          ),
        ),
      ),
    );
  }
}
