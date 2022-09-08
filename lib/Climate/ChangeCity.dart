// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:weather_app/main.dart';
import 'weatherFile.dart';

class ChangeCity extends StatefulWidget {
  ChangeCity({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WeathaState();
}

class _WeathaState extends State<ChangeCity> {
  var _cityFieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('Change City'),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          const Center(
            child: Image(
              image: AssetImage('lib/images/snow.png'),
              height: 1200.0,
              width: 600.0,
              fit: BoxFit.fill,
            ),
          ),
          ListView(
            children: <Widget>[
              ListTile(
                title: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Enter City',
                  ),
                  controller: _cityFieldController,
                  keyboardType: TextInputType.text,
                ),
              ),
              ListTile(
                title: OutlinedButton(
                  onPressed: () {
                    setState(
                      () {
                        Navigator.pop(
                          context,
                          {
                            'enter': _cityFieldController.text,
                          },
                        );
                        // main();
                      },
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    primary: Colors.red,
                  ),
                  child: const Text(
                    'Get Weather',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
