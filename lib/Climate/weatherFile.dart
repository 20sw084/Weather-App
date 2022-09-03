import 'package:flutter/material.dart';
import '../utils/apiFile.dart' as util;
import 'package:http/http.dart' as http;
import 'dart:convert';

class Weather extends StatefulWidget {
  const Weather({Key? key}) : super(key: key);

  @override
  State<Weather> createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  void showStuff() async {
    Map data = await getWeather(util.apiId, util.defaultCity);
    print(data.toString());
  }

  String? _cityEntered; // City removed from the text field
  Future<void> _goToNextScreen(
    BuildContext context,
  ) async {
    Map? results = await Navigator.of(context).push(
      MaterialPageRoute<Map>(
        builder: (BuildContext context) {
          return ChangeCity();
        },
      ),
    );
    if (results != null && results.containsKey('enter')) {
      _cityEntered = results['enter'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App"),
        backgroundColor: Colors.red,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () async {
              await _goToNextScreen(context);
            },
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          const Center(
            child: Image(
              image: AssetImage('lib/images/umbrella.png'),
              height: 1200.0,
              width: 600.0,
              fit: BoxFit.fill,
            ),
          ),
          Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 10.9, 20.9, 0.0),
            child: Text(
              _cityEntered ?? util.defaultCity,
              // '${_cityEntered == null ? util.defaultCity : _cityEntered}',
              style: cityStyle(),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(30.0, 190.0, 0.0, 0.0),
            child: updateTempWidget(
              _cityEntered ?? util.defaultCity,
              // '${_cityEntered == null ? util.defaultCity : _cityEntered}',
            ),
          ),
        ],
      ),
    );
  }

  Future<Map> getWeather(String appId, String city) async {
    String apiUrl =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$appId&units=metric';
    http.Response response = await http.get(Uri.parse(apiUrl));
    return jsonDecode(response.body);
  }

  Widget updateTempWidget(String city) {
    return FutureBuilder(
      future: getWeather(util.apiId, city == null ? util.defaultCity : city),
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
        if (snapshot.hasData) {
          Map content = snapshot.data!;
          return Container(
            margin: const EdgeInsets.fromLTRB(30.0, 250.0, 0.0, 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ListTile(
                  title: Text(
                    "${content['main']['temp'].toString()} °C",
                    style: tempStyle(),
                  ),
                  subtitle: ListTile(
                    title: Text(
                      "Humidity: ${content['main']['humidity'].toString()} \n"
                      "Min: ${content['main']['temp_min'].toString()} \n"
                      "Max: ${content['main']['temp_max'].toString()}",
                      style: extraData(),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

// ignore: must_be_immutable
class ChangeCity extends StatelessWidget {
  final _cityFieldController = TextEditingController();

  ChangeCity({Key? key}) : super(key: key);
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
                title: FlatButton(
                  onPressed: () {
                    Navigator.pop(context, {
                      'enter': _cityFieldController.text,
                    });
                  },
                  textColor: Colors.white70,
                  color: Colors.red,
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

TextStyle cityStyle() {
  return const TextStyle(
    color: Colors.black,
    fontSize: 22.9,
    fontStyle: FontStyle.italic,
  );
}

TextStyle tempStyle() {
  return const TextStyle(
    color: Color.fromARGB(179, 12, 12, 238),
    fontSize: 49.9,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
  );
}

TextStyle extraData() {
  return const TextStyle(
    color: Color.fromARGB(179, 12, 12, 238),
    fontSize: 17.0,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
  );
}
