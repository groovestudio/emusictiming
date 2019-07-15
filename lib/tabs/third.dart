import 'dart:convert';
import 'timechart.dart';
import 'package:flutter/material.dart';
import 'package:music_tool/main.dart';

class Third extends StatefulWidget {
  @override
  MyAppState createState() => new MyAppState();
}

class MyAppState extends State<Third> {
  List<Timechart> _timecharts = timecharts;

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Column(
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Expanded(
                  //color: Colors.deepOrange,
                  child: new Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: new Text("Quick Reference - tempos with evenly divisible hz:"),
                  )
              )
            ]
          ),
          new Expanded(
            child: new ListView(
              children: _timecharts.map(MyHomeState.buildRow).toList(),
            )
          ),
        ]
      )
    );
  }
}
