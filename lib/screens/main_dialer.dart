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

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                // Perform logout actions here
                // ...

                // Close the app
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
            ),
          ],
        );
      },
    );
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
              // do some{
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => SettingsWidget()),
              // );
              _showLogoutConfirmation(context);
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
            Row(
              children: [
                Container(
                  width: 300,
                  child: InputFieldMaker('Enter number to dial', number_to_dial,
                      TextInputType.phone),
                ),
                IconButton(
                  style: ButtonStyle(iconSize: MaterialStateProperty.all(20)),
                  icon: const Icon(Icons.contact_page),
                  onPressed: () async {
                    final PhoneContact contact =
                        await FlutterContactPicker.pickPhoneContact();
                    print(contact.phoneNumber!.number);
                    number_to_dial.text = contact.phoneNumber!.number!;
                  },
                ),
              ],
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
      title: number_to_dial.text,
      isImportant: true,
      number: 3,
      description: "Outgoing call",
      createdTime: DateTime.now(),
    );

    await NotesDatabase.instance.create(note);
  }
}
