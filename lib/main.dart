import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import './screens/settings.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
        ),
        backgroundColor: Colors.blueGrey[900],
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              // do some{
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsWidget()),
              );
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                controller: fixed_no,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter a fixed number',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                controller: extension,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter option',
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  width: 300,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextField(
                      controller: number_to_dial,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter number to dial',
                      ),
                    ),
                  ),
                ),
                IconButton(
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
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final String callnow = "tel:" +
                      fixed_no.text +
                      "," +
                      extension.text +
                      "," +
                      number_to_dial.text;

                  print(callnow);
                  final call = Uri.parse(callnow);
                  if (await canLaunchUrl(call)) {
                    launchUrl(call);
                  } else {
                    throw 'Could not launch $call';
                  }
                },
                child: const Text('Call'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
