import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/input_field.dart';

class SettingsWidget extends StatefulWidget {
  @override
  _SettingsWidget createState() => _SettingsWidget();
}

class _SettingsWidget extends State<SettingsWidget> {
  TextEditingController _number1Controller = TextEditingController();
  TextEditingController _number2Controller = TextEditingController();

  @override
  void dispose() {
    _number1Controller.dispose();
    _number2Controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadValuesFromPreferences();
  }

  Future<void> _loadValuesFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String number1 = prefs.getString('number1') ?? '';
    String number2 = prefs.getString('number2') ?? '';

    setState(() {
      _number1Controller.text = number1;
      _number2Controller.text = number2;
    });
  }

  Future<void> _saveValuesToPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('number1', _number1Controller.text);
    await prefs.setString('number2', _number2Controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Dialer",
        ),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Column(
        children: [
          InputFieldMaker(
              'Enter a fixed number', _number1Controller, TextInputType.number),
          InputFieldMaker(
              'Enter option', _number1Controller, TextInputType.number),
          ElevatedButton(
            onPressed: () {
              int number1 = int.tryParse(_number1Controller.text) ?? 0;
              int number2 = int.tryParse(_number2Controller.text) ?? 0;
              // Do something with the numbers
              print('Number 1: $number1, Number 2: $number2');

              _saveValuesToPreferences();

              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
