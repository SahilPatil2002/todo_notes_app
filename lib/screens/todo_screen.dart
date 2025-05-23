import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Task {
  String title;
  bool isdone;
  Task({required this.title, this.isdone = false});
}

class MyTodoScreen extends StatefulWidget {
  const MyTodoScreen({super.key});

  @override
  State<MyTodoScreen> createState() => _MyTodoScreenState();
}

class _MyTodoScreenState extends State<MyTodoScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController taskController = TextEditingController();
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void addTask() {
    String taskText = taskController.text.trim();
    if (_formKey.currentState!.validate()) {
      setState(() {
        tasks.add(Task(title: taskText));
        taskController.clear();
        _saveTasks();
      });
    }
  }

  void _saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> taskList =
        tasks
            .map(
              (task) =>
                  jsonEncode({'title': task.title, 'isdone': task.isdone}),
            )
            .toList();
    prefs.setStringList('tasks', taskList);
  }

  void _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedTasks = prefs.getStringList('tasks');

    if (savedTasks != null) {
      setState(() {
        tasks =
            savedTasks.map((item) {
              final json = jsonDecode(item);
              return Task(title: json['title'], isdone: json['isdone']);
            }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: Text("My TO-DO List", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.05),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: taskController,
                      validator:
                          (value) =>
                              (value == null || value.trim().isEmpty)
                                  ? 'Please enter a task'
                                  : null,
                      decoration: const InputDecoration(
                        hintText: 'What do you want to do?',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColor,
                    ),
                    child: IconButton(
                      icon:  Icon(Icons.add, color: Colors.white),
                      onPressed: addTask,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child:
                tasks.isEmpty
                    ? const Center(
                      child: Text(
                        "To-do list is empty!",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: Key(tasks[index].title + index.toString()),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            alignment: Alignment.centerRight,
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          onDismissed: (direction) {
                            setState(() {
                              tasks.removeAt(index);
                              _saveTasks();
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: const [
                                    Icon(
                                      Icons.delete_outline,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'Task deleted',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                                backgroundColor: Colors.redAccent,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                margin: const EdgeInsets.all(16.0),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.05),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      tasks[index].isdone =
                                          !tasks[index].isdone;
                                      _saveTasks();
                                    });
                                  },
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color:
                                          tasks[index].isdone
                                              ? primaryColor
                                              : Colors.transparent,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: primaryColor),
                                    ),
                                    child:
                                        tasks[index].isdone
                                            ? const Icon(
                                              Icons.check,
                                              size: 16,
                                              color: Colors.white,
                                            )
                                            : null,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    tasks[index].title,
                                    style: TextStyle(
                                      fontSize: 16,
                                      decoration:
                                          tasks[index].isdone
                                              ? TextDecoration.lineThrough
                                              : null,
                                      color:
                                          tasks[index].isdone
                                              ? Colors.grey
                                              : Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
