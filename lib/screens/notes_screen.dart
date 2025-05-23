import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_notes_app/screens/note_detail_screen.dart';

class Note {
  String title;
  String content;
  Note({required this.title, required this.content});
}

class MyNoteScreen extends StatefulWidget {
  const MyNoteScreen({super.key});

  @override
  State<MyNoteScreen> createState() => _MyNoteScreenState();
}

class _MyNoteScreenState extends State<MyNoteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  List<Note> notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  void _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final noteList =
        notes
            .map(
              (note) =>
                  jsonEncode({'title': note.title, 'content': note.content}),
            )
            .toList();
    await prefs.setStringList('notes', noteList);
  }

  void _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final savedNotes = prefs.getStringList('notes');
    if (savedNotes != null) {
      setState(() {
        notes =
            savedNotes.map((item) {
              final json = jsonDecode(item);
              return Note(title: json['title'], content: json['content']);
            }).toList();
      });
    }
  }

  void _addNote() {
    if (_titleController.text.trim().isEmpty &&
        _contentController.text.trim().isEmpty)
      return;
    setState(() {
      notes.add(
        Note(
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
        ),
      );
      _titleController.clear();
      _contentController.clear();
      _saveNotes();
    });
    Navigator.pop(context);
  }

  void _showAddNoteDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder:
          (context) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 20,
              right: 20,
              top: 30,
            ),
            child: SingleChildScrollView(
              child: SizedBox(
                height:
                    MediaQuery.of(context).size.height *
                    0.55, // 55% of screen height
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Create a New Note",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _titleController,
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.title_rounded),
                        hintText: 'Note Title',
                        filled: true,
                        fillColor: Color.fromARGB(255, 219, 236, 250),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: TextField(
                        controller: _contentController,
                        style: const TextStyle(fontSize: 15),
                        maxLines: null,
                        expands: true,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.notes_rounded),
                          hintText: 'Type your thoughts here...',

                          filled: true,
                          fillColor: Color.fromARGB(255, 219, 236, 250),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: _addNote,
                        icon: Icon(Icons.save_alt_rounded),
                        label: Text("Save Note"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 24,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  void _deleteNote(int index) {
    setState(() {
      notes.removeAt(index);
      _saveNotes();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Note deleted', style: TextStyle(fontWeight: FontWeight.bold)),
            Icon(Icons.delete, color: Colors.white),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor:  Colors.red,
      ),
    );
  }

  void _editNote(Note note, int index) async {
    final result = await Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => NoteDetailPage(note: notes[index]),
  ),
);

// Handle result properly
if (result == 'delete') {
  setState(() {
    notes.removeAt(index);
    _saveNotes(); // your SharedPreferences update method
  });
} else if (result is Note) {
  setState(() {
    notes[index] = result;
    _saveNotes();
  });
}

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Notes",style: TextStyle(fontWeight: FontWeight.bold), ), centerTitle: true),
      body: Stack(
        children: [
          notes.isEmpty
              ?  Center(
                child: Text(
                  "No notes available!",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              )
              : ListView.builder(
                padding:  EdgeInsets.all(12),
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return Dismissible(
                    key: Key(note.title + index.toString()),
                    direction: DismissDirection.endToStart,
                    background: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        alignment: Alignment.centerRight,
                        color: Colors.red,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                    ),
                    onDismissed: (direction) => _deleteNote(index),
                    child: GestureDetector(
                      onTap: () => _editNote(note, index),
                      child: Card(
                        elevation: 4,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: Text(
                            note.title.isEmpty ? "No Title" : note.title,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            note.content.isEmpty
                                ? "No Content"
                                : note.content,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

          // Your custom black "Add New Note" button
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: GestureDetector(
                onTap: _showAddNoteDialog,
                child: Container(
                  height: 55,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                  ), // horizontal padding
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(
                      30,
                    ), // more rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.draw, color: Colors.white),
                      SizedBox(width: 12),
                      Text(
                        "Add New Note",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
