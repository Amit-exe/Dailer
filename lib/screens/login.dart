import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../components/input_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './navigation.dart';
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
  bool remember_me = false;
  String _response = '';
  String url = "";

  var alertStyle = AlertStyle(
    animationType: AnimationType.grow,
    isCloseButton: false,
    descStyle: TextStyle(fontWeight: FontWeight.w400),
    // animationDuration: Duration(milliseconds: 200),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
      side: BorderSide(
        color: Colors.grey,
      ),
    ),
  );

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
    String username = prefs.getString('username') ?? '';
    String password = prefs.getString('password') ?? '';
    setState(() {
      Url.text = server_url;
      Password.text = password;
      Username.text = username;
    });

    bool? checkboxValue = prefs.getBool('checkboxValue');
    if (checkboxValue != null) {
      setState(() {
        remember_me = checkboxValue;
      });
    }
  }

  Future<void> _saveValuesToPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('server_url', Url.text);
  }

  Future<void> _saveLoginCreds(String username, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('password', password);
  }

  Future<void> updateCheckboxValue(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('checkboxValue', value);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 50),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 25),
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
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              child: Row(
                children: [
                  Checkbox(
                    value: this.remember_me,
                    onChanged: (bool? value) {
                      setState(() {
                        remember_me = value!;
                      });
                      if (remember_me) {
                        _saveLoginCreds(Username.text, Password.text);
                      } else {
                        _saveLoginCreds("", "");
                      }
                      updateCheckboxValue(remember_me);
                    },
                  ),
                  Text('Remember me'),
                ],
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
                        MaterialPageRoute(builder: (context) => AppBarPage()),
                      );
                    } else {
                      Alert(
                              style: alertStyle,
                              type: AlertType.error,
                              context: context,
                              title: "Invalid Login",
                              desc: "Incorrect Password or username")
                          .show();
                    }
                  },
                  child: Text('Login')),
            )
          ]),
        ),
      ),
    );
  }
}
