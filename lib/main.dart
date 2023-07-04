import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './screens/login.dart';
import 'package:two_stage_d/db/notes_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Create an instance of NotesDatabase
  final notesDatabase = NotesDatabase.instance;

  // Open the database
  await notesDatabase.database;

  // Print the table schema
  notesDatabase.printTableSchema();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        // resizeToAvoidBottomInset : false,
        appBar: AppBar(
          title: const Text(
            "Dialer",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blueGrey[900],
        ),
        body: LoginWidget());
  }
}
