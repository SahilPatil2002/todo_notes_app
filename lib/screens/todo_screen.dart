import 'package:flutter/material.dart';

class MyTodoScreen extends StatefulWidget {
  const MyTodoScreen({super.key});

  @override
  State<MyTodoScreen> createState() => _MyTodoScreenState();
}

class _MyTodoScreenState extends State<MyTodoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("TO-DO List"),
        
      ),
      body: const Center(
        child: Text(
          "No todos available",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}