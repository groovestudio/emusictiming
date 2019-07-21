import 'package:flutter/material.dart';
import 'package:music_tool/tabs/calculate_view.dart';
import 'package:music_tool/tabs/settings_view.dart';
import 'package:music_tool/tabs/reference_view.dart';
import 'package:music_tool/tabs/timechart.dart';
import 'package:music_tool/tabs/tempoflasher.dart';
import 'package:music_tool/tabs/state_inherited.dart';

void main() {

  runApp(new MaterialApp(
      title: "eMusic Timing Tool",
      theme: new ThemeData(
        primarySwatch: Colors.teal,
        brightness: Brightness.dark,
      ),
      home: new MyHome()));
}

class MyHome extends StatefulWidget {
  @override
  MyHomeState createState() => new MyHomeState();
}

// SingleTickerProviderStateMixin is used for animation
class MyHomeState extends State<MyHome> with SingleTickerProviderStateMixin {
  /*
   *-------------------- Setup Tabs ------------------*
   */
  // Create a tab controller
  TabController controller;
  final Color _xcolor = Colors.teal[400];

  @override
  void initState() {
    super.initState();

    // Initialize the Tab Controller
    controller = new TabController(length: 3, vsync: this);

    int minBPM = 60;
    int maxBPM = 180;
    for (var i = minBPM; i <= maxBPM; i+=1) {
      int bpm = i;
      double hz = bpmToHz(bpm);
      if(hz.toString().length<=4) {
        timecharts.add(
            new Timechart(
              bpm: bpm,
              hz: hz,
//              hz2: hz * 2,
//              hz4: hz * 4,
//              hzH: hz / 5,
              ms: bpmToMs(bpm),
            )
        );
      }
    }

  }

  @override
  void dispose() {
    // Dispose of the Tab Controller
    controller.dispose();
    super.dispose();
  }

  TabBar getTabBar() {
    return new TabBar(
      tabs: <Tab>[
        new Tab(
          // set icon to the tab
          icon: new Tooltip(
            message: 'Calculate Timing & See History',
            child: new Icon(Icons.library_music),
          )
        ),
        new Tab(
          icon: new Icon(Icons.assignment),
        ),
        new Tab(
          icon: new Icon(Icons.settings ),
        ),
      ],
      // setup the controller
      controller: controller,
    );
  }

  TabBarView getTabBarView(var tabs) {
    return new TabBarView(
      // Add tabs as widgets
      children: tabs,
      // set the controller
      controller: controller,
    );
  }

  /*
   *-------------------- Setup the page by setting up tabs in the body ------------------*
   */
  @override
  Widget build(BuildContext context) {
    return new AppContextInheritedWidget(
      child: new Scaffold(
      // Appbar
        appBar: new AppBar(
          // Title
            title: new Text("eMusic Timing Tool"),
            // Set the background color of the App Bar
            backgroundColor: _xcolor,
            // Set the bottom property of the Appbar to include a Tab Bar
            bottom: getTabBar()),
        // Set the TabBar view as the body of the Scaffold
        body: SafeArea( // SafeArea uses device specific analysis to make sure that no content is obscured from view
          child: getTabBarView(<Widget>[new CalculateView(), new ReferenceView(), new SettingsView()])
        )
      )
    );
  }

  static Widget buildRow(Timechart timechart) {

    //print('buildRow processing $timechart');
    return new Container(
      //margin: const EdgeInsets.all(30.0),
      //padding: const EdgeInsets.all(10.0),
      decoration: new BoxDecoration(
          border: new Border(top: BorderSide(color: Colors.cyan[200]))
      ),
      child: new Padding(
        key: Key(timechart.text()),
        padding: const EdgeInsets.all(0.0),
        child: new ExpansionTile(
          title: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Text("${timechart.bpm} bpm", textAlign: TextAlign.start),
//              new Text("${timechart.bpm} bpm\n" +
//                  "${timechart.bpm * 0.5} bpm (1/2x)\n"
//                      "${timechart.bpm * 2} bpm (2x)\n"
//              ),
              new Text("${formatDouble(timechart.hz)} hz", textAlign: TextAlign.start),
//              new Text("${formatDouble(timechart.hz * 0.5)} hz (1/2x)\n" +
//                  "${formatDouble(timechart.hz)} hz (1x)\n" +
//                  "${formatDouble(timechart.hz * 2)} hz (2x)\n" +
//                  "${formatDouble(timechart.hz * 4)} hz (4x)\n" +
//                  "${formatDouble(timechart.hz * 8)} hz (8x)"),
              new Text("${formatDouble(timechart.ms)} ms", textAlign: TextAlign.start)
//              new Text("${timechart.ms.toStringAsFixed(2)} ms\n" +
//                  "${(timechart.ms * 1/2).toStringAsFixed(2)} ms (1/2x)\n"
//                      "${(timechart.ms * 2).toStringAsFixed(2)} ms (2x)\n"
//              )
            ],
          ), // Row - title
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    new Text("${formatDouble(timechart.bpm * 0.25)} bpm (1/4x)"),
                    new Text("${formatDouble(timechart.bpm * 0.5)} bpm (1/2x)"),
                    new Text("${formatDouble(timechart.bpm * 1.0)} bpm (1x)", style: TextStyle(fontWeight: FontWeight.bold)),
                    new Text("${formatDouble(timechart.bpm * 2.0)} bpm (2x)"),
                    new Text("${formatDouble(timechart.bpm * 4.0)} bpm (4x)"),
                    new Text("${formatDouble(timechart.bpm * 8.0)} bpm (8x)")
                  ]
                ),
                new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      new Text("${formatDouble(timechart.hz * 0.25)} hz (1/4x)"),
                      new Text("${formatDouble(timechart.hz * 0.5)} hz (1/2x)"),
                      new Text("${formatDouble(timechart.hz * 1.0)} hz (1x)", style: TextStyle(fontWeight: FontWeight.bold)),
                      new Text("${formatDouble(timechart.hz * 2.0)} hz (2x)"),
                      new Text("${formatDouble(timechart.hz * 4.0)} hz (4x)"),
                      new Text("${formatDouble(timechart.hz * 8.0)} hz (8x)"),
                    ]
                ),
                new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //                    new Text("${timechart.ms.toStringAsFixed(2)} ms"),
                    //                    new Text("${(timechart.ms * 1/2).toStringAsFixed(2)} ms (1/2x)"),
                    //                    new Text("${(timechart.ms * 2).toStringAsFixed(2)} ms (2x)"),
                    new Text("${formatDouble(timechart.ms * 0.25)} ms (1/4x)"),
                    new Text("${formatDouble(timechart.ms * 0.5)} ms (1/2x)"),
                    new Text("${formatDouble(timechart.ms * 1.0)} ms (1x)", style: TextStyle(fontWeight: FontWeight.bold)),
                    new Text("${formatDouble(timechart.ms * 2.0)} ms (2x)"),
                    new Text("${formatDouble(timechart.ms * 4.0)} ms (4x)"),
                    new Text("${formatDouble(timechart.ms * 8.0)} ms (8x)"),
                  ]
                ),
                new TempoFlasher(timechart.ms.toInt())
//                new Container(
//                  width: 50,
//                  height: 50,
//                  decoration: BoxDecoration(
//                    color: Colors.tealAccent,
//  //                  image: DecorationImage(
//  //                    image: ExactAssetImage('images/flowers.jpeg'),
//  //                    fit: BoxFit.cover,
//  //                  ),
//                    border: Border.all(
//                      color: Colors.teal,
//                      width: 2.0,
//                    ),
//                  ),
//                )
                  //new Text("99 comments"),
                  //new IconButton(
                  //  icon: new Icon(Icons.launch),
                  //),
              ],
            ),
          ],
        )
      ),
    );
  }

  static String formatDouble(double n) {
    String numberStr = n.toString();
    if(n==n.toInt()) {
      //print("formatDouble1: ${n.toInt().toString()} / ${n.toString()}");
      return n.toInt().toString();
    }
    else if(numberStr.contains('.')) {
      List<String> numberSplit = numberStr.split('.');
      if((numberSplit.last!=null)&&(numberSplit.last.length<=2)) {
        //print("formatDouble2: ${n.toString()}");
        return n.toString();
      }
      else {
        //print("formatDouble3: ${n.toStringAsFixed(3)} / ${n.toString()}");
        return n.toStringAsFixed(3);   // (n.truncateToDouble() == n ? 0 : 2);
      }
    }
    else {
      //print("formatDouble4: ${n.toInt().toString()} / ${n.toString()}");
      return n.toInt().toString();
    }
  }

  static String OLDformatDouble(double n) {
    if((n%1)==0)
      return n.toInt().toString();
    else if((n%1).toString().length<=4)
      return n.toString();
    else
      return n.toStringAsFixed(3);   // (n.truncateToDouble() == n ? 0 : 2);
  }

  static double bpmToHz(int bpm) {
    return (bpm / 60).toDouble();
  }
  static double bpmToMs(int bpm) {
    return ((60 * 1000) / bpm).toDouble();
  }
  // MyHomeState.msToBpm
  static double msToBpm(int ms) {
    return (60 / (ms / 1000)).toDouble();
  }
}
