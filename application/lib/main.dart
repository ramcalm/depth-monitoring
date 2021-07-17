import 'package:apicall/chartdata.dart';
import 'package:apicall/chartfinal.dart';
import "package:flutter/material.dart";
import 'dart:convert' as convert;
import "package:http/http.dart" as http;
import 'package:charts_flutter/flutter.dart' as charts;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var url = Uri.parse(
      'https://api.thingspeak.com/channels/1218388/feeds.json?api_key=IQQOFO3OI3CQVNXE&results=5');
  var data;
  var _jsonresponse;
  List<ChartData> _cd;

  Future<void> _getdata() async {
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonresp = convert.jsonDecode(response.body);
      var data = jsonresp['feeds'];
      setState(() {
        _jsonresponse = data;
        print(_jsonresponse);
        print(_jsonresponse.length);
      });
      List<ChartData> temp = [];
      if (_jsonresponse.length > 0) {
        for (int i = 0; i < _jsonresponse.length; i++) {
          temp.add(new ChartData(
              x: _jsonresponse[i]["created_at"],
              y: int.parse(_jsonresponse[i]["field1"]),
              barColor: charts.ColorUtil.fromDartColor(Colors.blue)));
        }
        setState(() {
          _cd = temp;
          print(_cd.length);
        });
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  Widget _getWidgets() {
    if (_jsonresponse == null || _jsonresponse.length == 0)
      return Text(
        "No Data",
        style: TextStyle(fontSize: 20),
      );
    var time = _jsonresponse[_jsonresponse.length - 1]["created_at"];
    var depth = _jsonresponse[_jsonresponse.length - 1]["field1"];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          child: ChartFinal(
            data: _cd,
          ),
        ),
        SizedBox(
          width: 20.0,
          height: 20.0,
        ),
        Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Water Depth(cm): $depth',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
        SizedBox(
          width: 20.0,
          height: 20.0,
        ),
        Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Date Updated: ${time.substring(0, 10)}',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
        SizedBox(
          width: 20.0,
          height: 10.0,
        ),
        Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Time Updated: ${time.substring(11, 19)}',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _getWidgets(),
            SizedBox(
              width: 20.0,
              height: 20.0,
            ),
            ElevatedButton(
              onPressed: _getdata,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Get Current Depth',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
