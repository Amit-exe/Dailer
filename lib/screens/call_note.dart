import 'package:flutter/material.dart';

class CallNotes extends StatefulWidget {
  const CallNotes({super.key});

  @override
  State<CallNotes> createState() => _CallNotesState();
}

class _CallNotesState extends State<CallNotes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Dialer",
          // style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
      ),
      body: Container(
          margin: EdgeInsets.only(top: 30),
          child: Column(
            children: [Text("hello")],
          )),
    );
  }
}
