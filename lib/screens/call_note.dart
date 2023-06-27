// import 'package:flutter/material.dart';
// import '../notes_data.dart';
// import '../notes.dart';

// NotesData notesData = NotesData();

// class CallNotes extends StatefulWidget {
//   const CallNotes({super.key});

//   @override
//   State<CallNotes> createState() => _CallNotesState();
// }

// class _CallNotesState extends State<CallNotes> {
//   List<Note> note = notesData.getAll();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color.fromRGBO(249, 253, 246, 1),
//       appBar: AppBar(
//         title: const Text(
//           "Dialer",
//           // style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Colors.blueGrey[900],
//         foregroundColor: Colors.white,
//       ),
//       body: Container(
//           margin: EdgeInsets.only(top: 30),
//           child: Column(
//             children: note,
//           )),
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../notes.dart';

class CallNotes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: NotesPage(),
    );
  }
}

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();

  static void addNewNote(BuildContext context, Note note) {
    print("in unscore fun");
    final _NotesPageState? state =
        context.findAncestorStateOfType<_NotesPageState>();
    state?.addNewNoteInternal(note);
  }
}

class _NotesPageState extends State<NotesPage> {
  List<Note> notes = [
    Note(
      title: 'Note 1',
      description: 'Content of Note 1',
    ),
    Note(
      title: 'Note 2',
      description: 'Content of Note 2',
    ),
    Note(
      title: 'Note 3',
      description: 'Content of Note 3',
    ),
  ];

  void _navigateToNotePage(Note note) async {
    final updatedNote = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NotePage(note: note)),
    );
    if (updatedNote != null) {
      setState(() {
        final index = notes.indexOf(note);
        if (index != -1) {
          notes[index] = updatedNote;
        }
      });
    }
  }

  void addNewNoteInternal(Note note) {
    print("in add note");
    setState(() {
      notes.add(note);
    });
    _navigateToNotePage(note);
  }

  @override
  Widget build(BuildContext context) {
    print(notes.length);
    print(notes);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Dialer",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return ListTile(
            title: Text(note.title),
            onTap: () => _navigateToNotePage(note),
          );
        },
      ),
    );
  }
}

class NotePage extends StatefulWidget {
  final Note note;

  const NotePage({Key? key, required this.note}) : super(key: key);

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(text: widget.note.description);
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() {
    final updatedNote = Note(
      title: widget.note.title,
      description: _contentController.text,
    );
    Navigator.pop(context, updatedNote);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note.title),
        actions: [
          IconButton(
            onPressed: _saveNote,
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: TextField(
          controller: _contentController,
          maxLines: null,
          decoration: InputDecoration(
            hintText: 'Enter content...',
          ),
        ),
      ),
    );
  }
}
