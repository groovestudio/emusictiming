import 'package:flutter/material.dart';
import 'timechart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:music_tool/main.dart';

class CalculateView extends StatefulWidget {
  @override
  CalculateViewState createState() => new CalculateViewState();
}

class CalculateViewState extends State<CalculateView> {
  double rate = 0.0;
  String unit = 'BPM';
  List<Row> results = [];
  List<Timechart> _timechartsUser = [];
  List<String> lItems = ["1","2","Third","4"];
  List<int> tapArray = [];
  var textController = new TextEditingController();

  @override
  initState() {
    super.initState();
    getHistory();
  }

  @override
  Widget build(BuildContext context) {

    return new Container(
      constraints: BoxConstraints.expand(
        height: Theme.of(context).textTheme.display1.fontSize * 1.1 + 200.0,
      ),
      padding: const EdgeInsets.all(8.0),
      //color: Colors.teal.shade700,
      alignment: Alignment.center,
      child: new Column(
        children: <Widget>[
          new Row(
            children: [
              new Flexible(
                child: new TextField(
                  // autofocus: true, // this immediately raises the keyboard, so not sure if this is preferable
                  keyboardType: TextInputType.number,
                  controller: textController,
                  onChanged: (String value) {
                    try {
                      rate = double.parse(value);
                    } catch (exception) {
                      rate = 0.0;
                    }
                  },
                  decoration: new InputDecoration(labelText: "Enter a Tempo / Rate"),
                ),
              ),
              new DropdownButton<String>(
                value: unit,
                onChanged: (String newValue) {
                  setState(() {
                    unit = newValue;
                  });
                },
                items: <String>['BPM', 'HZ', 'MS']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                      value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              new Padding(
                padding: EdgeInsets.all(10.0),
                child: new MaterialButton(
                  height: 30.0,
                  minWidth: 50.0,
                  color: Colors.teal, //Theme.of(context).primaryColor,
                  textColor: Colors.grey[300],
                  child: new Text("Tap"),
                  onPressed: () {
                    tapArray.add(new DateTime.now().millisecondsSinceEpoch);
                    print("tapping - size: ${tapArray.length}, array: $tapArray");
                    int startTime = new DateTime.now().millisecondsSinceEpoch - (10 * 1000);  // just use the last 10 seconds of tap data
                    int priorTime;
                    int sum = 0;
                    int count = 0;
                    for(var time in tapArray) {
                      if(time>startTime && priorTime!=null) {
                        sum += time-priorTime;
                        count++;
                      }
                      priorTime = time;
                    }
                    if(count>0) {
                      print("avg: ${sum/count}, bpm: ${MyHomeState.msToBpm((sum/count).toDouble())}");
                      setState(() {
                        print("setting rate and unit state");
                        rate = MyHomeState.msToBpm((sum/count).toDouble());
                        textController.text = rate.toInt().toString();
                        unit = "BPM";
                      });

                    }
                    else
                      print("no avg");
                  },
                  splashColor: Colors.tealAccent,
                )
              )
//              new Padding(
//                padding: EdgeInsets.all(10.0),
//                child: new RaisedButton(
//                  child: new Text("Tap"),
//                  onPressed: () {
//                    tapArray.add(new DateTime.now().millisecondsSinceEpoch);
//                    print("tapping - size: ${tapArray.length}, array: ${tapArray}");
//                    List<int> intervals = [];
//                    int startTime = new DateTime.now().millisecondsSinceEpoch - (20 * 1000);
//                    int priorTime = null;
//                    int sum = 0;
//                    int count = 0;
//                    for(var time in tapArray) {
//
//                      if(time>startTime && priorTime!=null) {
//                        //intervals.add(time-priorTime);
//                        sum += time-priorTime;
//                        count++;
//                      }
//                      priorTime = time;
//                    }
//                    if(count>0)
//                      print("avg: ${sum/count}, bpm: ${MyHomeState.msToBpm((sum/count).toInt())}");
//                    else
//                      print("no avg");
//                  }
//                ),
//              )
            ]
          ),

          new Padding(
            padding: const EdgeInsets.all(16.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                    new RaisedButton(
                        child: new Text("Calculate"),
                        onPressed: () {
                          // Calculate
                          double bpm;
                          double hz;
                          double ms;
                          if(unit=='BPM') {
                            if(rate<30 || rate>300) {
                              final snackBar = SnackBar(content: Text('Value must be between 30-300'));
                              return;
                            }
                            bpm = rate;
                            hz = bpm/60;
                            ms = (60 * 1000) / bpm;
                          }
                          else if(unit=='HZ') {
                            if(rate<0.5 || rate>6) {
                              final snackBar = SnackBar(content: Text('Value must be between 0.5-6'));
                              return;
                            }
                            hz = rate;
                            bpm = hz * 60;
                            ms = (60 * 1000) / bpm;

                          }
                          else if(unit=='MS') {

                            if(rate<30 || rate>3000) {
                              final snackBar = SnackBar(content: Text('Value must be between 30-3000'));
                              return;
                            }
                            ms = rate;
                            bpm = (60 * 1000) / ms;
                            hz = bpm/60;
                          }
                          else {
                            return;
                          }

                          Timechart timechart = new Timechart(
                            //text: "#{i} bpm",
                            bpm: bpm,
                            hz: hz,
                            ms: ms,
                          );

                          setState(() {
                            _timechartsUser.insert(0, timechart);
                          });

                          _saveHistory(rate, unit);

                          // TODO how to remove focus from the value text field upon calculate (so keyboard hides)?
                          // does not work: Focus.clear(context);

                        },
                    ),

                    new RaisedButton(
                      child: new Text("Clear History"),
                      textColor: Colors.grey[300],
                      onPressed: () {
                        print("Clear history clearing timechart state");
                        setState(() {
                          _timechartsUser.removeRange(0, _timechartsUser.length);
                          tapArray.clear();
                        });
                        _clearHistory();

                      }, // onPressed
                    ),
              ]
            )
          ),
          new Expanded(
            child: new DefaultTextStyle(
              style: new TextStyle(
                inherit: true,
//                fontSize: 11.0,
//                //fontWeight: FontWeight.bold,
//                //decoration: TextDecoration.underline,
//                decorationColor: Colors.red,
//                decorationStyle: TextDecorationStyle.wavy,
//                color: Colors.blue
              ),
              child: new ListView.builder(
                  itemCount: _timechartsUser.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return Dismissible(
                      child: MyHomeState.buildRow(_timechartsUser[index]),
                      key: Key(index.toString()),
                      background: Container(
                        color: Colors.red,
                      ),
                      onDismissed: (direction) {
//                        setState(() {
//                          _timechartsUser.removeAt(index);
//                        });
                        _removeHistoryItem(index);
                      }
                    );
                  }
              )
            )
          ),
        ],
      ),
    );
  }

  _saveHistory(rate, unit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> historyList = (prefs.getStringList('history') ?? List<String>()) ;

    // flytter List<int> historyVals = historyList.map((i)=> int.parse(i)).toList();
    historyList.insert(0, rate.toString() + ':' + unit);
    // may need to do this in an async method - await prefs.setStringList('history', myListOfStrings);
    await prefs.setStringList('history', historyList);
    if(historyList.length>10)
      historyList.removeAt(11);
    print('after save history list  $historyList');

  }

  _removeHistoryItem(index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> historyList = (prefs.getStringList('history') ?? List<String>()) ;
    historyList.removeAt(index);
    await prefs.setStringList('history', historyList);
    print("removeHistoryItem: $index");
  }

  _clearHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('history');  // could also do: prefs.clear();
    print('after clear history, just removed history from prefs');
  }

  Future<List> getHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> historyList = (prefs.getStringList('history') ?? List<String>()) ;

    // flytter List<int> historyVals = historyList.map((i)=> int.parse(i)).toList();
    print('get history list  $historyList');

    for (var pair in historyList) {
      print('getHistory processing $pair');
      List<String> split = pair.split(':');
      // TODO, need to check the unit - split.last
      double bpm = double.parse(split.first);
      double hz = bpm/60;
      Timechart timechart = new Timechart(
        bpm: bpm,
        hz: hz,
        ms: (60 * 1000) / bpm,
      );

      setState(() {
        _timechartsUser.add(timechart);
      });
    }

    return historyList;
  }

}
