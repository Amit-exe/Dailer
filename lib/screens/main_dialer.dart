import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../components/input_field.dart';
import '../db/notes_database.dart';
import '../model/note.dart';
import './settings.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:two_stage_d/components/logout_function.dart';

class MainDialer extends StatefulWidget {
  const MainDialer({super.key});

  @override
  State<MainDialer> createState() => _MainDialerState();
}

class _MainDialerState extends State<MainDialer> {
  final fixed_no = TextEditingController();
  final extension = TextEditingController();
  final number_to_dial = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    fixed_no.dispose();
    extension.dispose();
    number_to_dial.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadValuesFromPreferences();
  }

  Future<void> _loadValuesFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String number1 = prefs.getString('number1') ?? '';
    String number2 = prefs.getString('number2') ?? '';

    setState(() {
      fixed_no.text = number1;
      extension.text = number2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Dialer",
          style: TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueGrey[900],
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () {
              showLogoutConfirmation(context);
            },
          )
        ],
      ),
      backgroundColor: Color.fromRGBO(249, 253, 246, 1),
      body: Container(
        margin: EdgeInsets.only(top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            InputFieldMaker(
                'Enter a fixed number', fixed_no, TextInputType.phone),
            InputFieldMaker('Enter option', extension, TextInputType.phone),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: TextFormField(
                controller: number_to_dial,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter number to dial',
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.contact_page,
                    ),
                    onPressed: () async {
                      final PhoneContact contact =
                          await FlutterContactPicker.pickPhoneContact();
                      print(contact.phoneNumber!.number);
                      number_to_dial.text = contact.phoneNumber!.number!;
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50), // NEW
                  ),
                  onPressed: () async {
                    final String callnow = "tel:" +
                        fixed_no.text +
                        ",," +
                        extension.text +
                        ",," +
                        number_to_dial.text +
                        "#";

                    await FlutterPhoneDirectCaller.callNumber(callnow);
                    // print(callnow);
                    // final call = Uri.parse(callnow);
                    // if (await canLaunchUrl(call)) {
                    //   launchUrl(call);
                    // } else {
                    //   throw 'Could not launch $call';
                    // }
                    await addNote();
                  },
                  child: const Text('Call'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future addNote() async {
    final note = Note(
      title: "${number_to_dial.text} -Outgoing call",
      isImportant: true,
      number: 0,
      description: "",
      createdTime: DateTime.now(),
    );

    await NotesDatabase.instance.create(note);
  }
}
