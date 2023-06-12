import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import '../components/input_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './main_dialer.dart';
import 'package:http/http.dart' as http;

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final Url = TextEditingController();
  final Username = TextEditingController();
  final Password = TextEditingController();

  String _response = '';
  String url = "";

  Future<void> fetchData() async {
    url =
        'http://${Url.text}/pbxlogin.py?l=${Username.text}&p=${Password.text}&action=login';
    print(url);
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        _response = response.body;
        print("type");
        print(_response.runtimeType);
      });
    } else {
      setState(() {
        _response = 'Error: ${response.statusCode}';
      });
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    Url.dispose();
    Username.dispose();
    Password.dispose();
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
    String server_url = prefs.getString('server_url') ?? '';

    setState(() {
      Url.text = server_url;
    });
  }

  Future<void> _saveValuesToPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('server_url', Url.text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        InputFieldMaker('Enter url', Url, TextInputType.url),
        InputFieldMaker('Username', Username, TextInputType.text),
        InputFieldMaker('Password', Password, TextInputType.visiblePassword),
        ElevatedButton(
            onPressed: () async {
              fetchData();
              _saveValuesToPreferences();
              print("hello");
              print(_response);
              if (_response.isNotEmpty) {
                _response = _response.replaceAll("'", '"');
                Map<String, dynamic> mapData = jsonDecode(_response);
                print(mapData);
                print(mapData['number']);

                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString('number1', mapData['number']);
              }
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MainDialer()),
              );
            },
            child: Text('Login'))
      ]),
    );
  }
}
