import 'package:flutter/material.dart';
import 'package:music_tool/tabs/tempoflasher.dart';

class Second extends StatefulWidget {
  @override
  Tab2State createState() => new Tab2State();
}

class Tab2State extends State<Second> with TickerProviderStateMixin {
  AnimationController _mcontroller;
  int _durationMillis = 500;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mcontroller = AnimationController(value: 0.0, lowerBound: 0.0, upperBound: 10.0, duration: Duration(seconds: 1), vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    TempoFlasher t = new TempoFlasher(250);
    return new Container(
      child: new Center(
        child: t
      ),
    );
  }
}
