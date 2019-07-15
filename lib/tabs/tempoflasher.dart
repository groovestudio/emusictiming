import 'package:flutter/material.dart';

class TempoFlasher extends StatefulWidget {
  final int _tempoInMillis;

  const TempoFlasher(this._tempoInMillis);

  @override
  TempoFlasherState createState() => new TempoFlasherState();
}

class TempoFlasherState extends State<TempoFlasher> with SingleTickerProviderStateMixin {
  AnimationController _mcontroller;
  int _durationMillis = null; // 500;

  @override
  void initState() {
    print("tempoInMillis: ${widget._tempoInMillis}");
    _durationMillis = widget._tempoInMillis;
    // TODO: implement initState
    super.initState();
    _mcontroller = AnimationController(value: 0.0, lowerBound: 0.0, upperBound: 10.0, duration: Duration(seconds: 1), vsync: this);
    _mcontroller.repeat(period: Duration(milliseconds: _durationMillis)).orCancel;

  }

  @override
  void dispose() {
    _mcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
        onTap: () {
          final status = _mcontroller.status;
          if(status==AnimationStatus.forward || status==AnimationStatus.reverse) {
            _mcontroller.reset();
          }
          else {
//            _mcontroller.animateTo(
//              100.0,
//              curve: Curves.easeOutExpo,
//            );
            _mcontroller.repeat(period: Duration(milliseconds: _durationMillis)).orCancel;
          }
        },
        child: AnimatedBuilder(
            animation: _mcontroller,
            builder: (context, child) {
              //double opacity = (_mcontroller.value * 10) / 100;
              double opacity = getSafeOpacity((100 - (_mcontroller.value * 10)) / 100);
              return Opacity(
                opacity: opacity,
                child: Container(
                    color: Colors.teal[200],
                    //constraints: BoxConstraints.expand(),
                    height: 80.0,
                    width: 30.0,
                    child: child
                ),
              );
//              return Container(
//                child: child,
//                height: 200, //_mcontroller.value,
//                width: 200, //_mcontroller.value,
//                color: Color.fromRGBO(21,101,192 ,opacity);
//              );
            },
            child: Container(
              //color: Colors.deepOrange[800],
              //constraints: BoxConstraints.expand(),
              height: 50.0,
              width: 50.0,
//              decoration: BoxDecoration(
//                border: Border.all(
//                  color: Colors.deepOrange[900],
//                  width: 1.0,
//                ),
//              ),
            )
//        child: new Column(
//          // center the children
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            new Icon(
//              Icons.adb,
//              size: 160.0,
//              color: Colors.green,
//            ),
//            new Text("Second Tab")
//          ],
//        ),
      ),
    );
  }

  double getSafeOpacity(val) {
    if(val<0.0)
      return 0.0;
    else if(val>1.0)
      return 1.0;
    else
      return val;
  }
}
