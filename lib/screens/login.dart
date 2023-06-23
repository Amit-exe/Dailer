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
        'http://${Url.text}/pbxlogin.py?l=${Username.text}&p=${Password.text}&a=login';
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
    return SafeArea(
<<<<<<< HEAD
      child:SingleChildScrollView(
=======
>>>>>>> 3073f31edb094b34584946a218364ec5866142ab
      child: Container(
        margin: EdgeInsets.only(top:50),
        child: Column(children: [
          Padding(
            
            padding: const EdgeInsets.fromLTRB(0, 20, 0 , 25),
            child: Image.asset('./images/logo2.png'),
          ),
          InputFieldMaker('Enter url', Url, TextInputType.url),
          InputFieldMaker('Username', Username, TextInputType.text),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: TextField(
              obscureText: true,
              controller: Password,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                 
            minimumSize: const Size.fromHeight(50), // NEW
                ),
                onPressed: () async {
                  bool? isloginvalid;
                  await fetchData();
                  _saveValuesToPreferences();
                  print("hello");
                  print(_response);
                  if (_response.isNotEmpty) {
                    _response = _response.replaceAll("'", '"');
                    Map<String, dynamic> mapData = jsonDecode(_response);
                    print(mapData);
                    print(mapData['number']);
          
                    if (mapData['status'] == 'login success') {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setString('number1', mapData['number']);
                      isloginvalid = true;
                    } else {
                      isloginvalid = false;
                    }
          
                    print(isloginvalid);
                  }
          
                  if (isloginvalid == true) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MainDialer()),
                    );
                  }
                },
                child: Text('Login')),
          )
        ]),
      ),
<<<<<<< HEAD
      ),
=======
>>>>>>> 3073f31edb094b34584946a218364ec5866142ab
    );
  }
}
