import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:two_stage_d/db/notes_database.dart';
import 'package:two_stage_d/model/note.dart';
import 'package:two_stage_d/screens/edit_note_page.dart';
import 'package:two_stage_d/screens/note_detail_page.dart';
import 'package:two_stage_d/widget/note_card_widget.dart';

class CallNotes extends StatefulWidget {
  @override
  _CallNotesState createState() => _CallNotesState();
}

class _CallNotesState extends State<CallNotes> {
  late List<Note> notes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    testinit();
    refreshNotes();
  }

  @override
  void dispose() {
    // NotesDatabase.instance.close();

    super.dispose();
  }

  Future testinit() async {
    WidgetsFlutterBinding.ensureInitialized();
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);

    this.notes = await NotesDatabase.instance.readAllNotes();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            'Notes',
            style: TextStyle(fontSize: 24),
          ),
          actions: [Icon(Icons.search), SizedBox(width: 12)],
        ),
        body: Center(
          child: isLoading
              ? CircularProgressIndicator()
              : notes.isEmpty
                  ? Text(
                      'No Notes',
                    )
                  : buildNotes(),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddEditNotePage()),
            );

            refreshNotes();
          },
        ),
      );

  Widget buildNotes() => StaggeredGridView.countBuilder(
        padding: EdgeInsets.all(8),
        itemCount: notes.length,
        staggeredTileBuilder: (index) => StaggeredTile.fit(4),
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: (context, index) {
          final note = notes[index];

          return GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NoteDetailPage(noteId: note.id!),
              ));

              refreshNotes();
            },
            child: NoteCardWidget(note: note, index: index),
          );
        },
      );
}
