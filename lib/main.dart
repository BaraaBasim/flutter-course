// ignore_for_file: must_call_super

import 'package:contacts_01/ui/new_note_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/note.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'notes app'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var notes = [];
  List<String> notestobesaved = [];

  void removeNote(NoteModel note, int index) {
    notes.remove(note);
    notestobesaved.removeAt(index);
    setState(() {});
  }

  Widget noteItemView(NoteModel note, index) {
    return Card(
      child: InkWell(
        onTap: () {
          openNewNote(noteModel: note);
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  note.content,
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Expanded(
                child: Container(),
              ),
              IconButton(
                icon: Icon(Icons.remove_circle_outline),
                onPressed: () => removeNote(note, index),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNotesList() {
    return ListView.builder(
      itemBuilder: (_context, index) => noteItemView(notes[index], index),
      itemCount: notes.length,
    );
  }

  void insertNewNote() {
    notes.add(NoteModel('New note ${notes.length}'));
    notestobesaved.add(NoteModel('New note ${notes.length}').content);
    setState(() {});
  }

  void openNewNote({NoteModel? noteModel}) {
    NoteModel _note = noteModel ?? NoteModel('');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewNotePage(_note)),
    ).then((value) async {
      if (noteModel == null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        notestobesaved.add(_note.content);
        notes.add(_note);
        await prefs.setStringList('notes', notestobesaved);
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();

    getnotes();
  }

  void getnotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    notestobesaved = (prefs.getStringList('notes') ?? []);
    for (int i = 0; i < notestobesaved.length; i++) {
      notes.add(NoteModel(notestobesaved[i]));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('notes app'),
      ),
      body: buildNotesList(),
      floatingActionButton: FloatingActionButton(
        onPressed: openNewNote,
        child: const Icon(Icons.add),
      ),
    );
  }
}
