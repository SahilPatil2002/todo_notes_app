import 'package:flutter/material.dart';
import 'package:todo_notes_app/screens/notes_screen.dart';

class NoteDetailPage extends StatefulWidget {
  final Note note;
  const NoteDetailPage({super.key, required this.note});

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  late TextEditingController titleController;
  late TextEditingController contentController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.note.title);
    contentController = TextEditingController(text: widget.note.content);
  }

  void _saveNote() {
  final trimmedTitle = titleController.text.trim();
  final trimmedContent = contentController.text.trim();

  if (trimmedTitle.isEmpty && trimmedContent.isEmpty) {
    // Explicitly return a special signal to delete
    Navigator.pop(context, 'delete');
    return;
  }

  final updatedNote = Note(
    title: trimmedTitle,
    content: trimmedContent,
  );

  Navigator.pop(context, updatedNote);
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F2),
      body: Column(
        children: [
          // Custom Top Bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios_new_rounded, size: 22),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Edit Note",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: _saveNote,
                    icon: const Icon(Icons.check_circle_rounded, size: 28, color: Colors.green),
                    tooltip: "Save",
                  ),
                ],
              ),
            ),
          ),

          // Editable Note Body
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    cursorColor: Colors.black,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: const InputDecoration(
                      hintText: "Title",
                      border: InputBorder.none,
                    ),
                  ),
                  const Divider(thickness: 1.2),
                  Expanded(
                    child: TextField(
                      controller: contentController,
                      maxLines: null,
                      cursorColor: Colors.black,
                      expands: true,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                      decoration: const InputDecoration(
                        hintText: "Start typing your note...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
