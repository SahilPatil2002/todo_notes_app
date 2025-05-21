import 'package:flutter/material.dart';

class MyNoteScreen extends StatefulWidget {
  const MyNoteScreen({super.key});

  @override
  State<MyNoteScreen> createState() => _MyNoteScreenState();
}

class _MyNoteScreenState extends State<MyNoteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("My Notes"),
        
      ),
      body: const Center(
        child: Text(
          "No notes available",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}