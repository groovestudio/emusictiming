import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:music_tool/tabs/state_inherited.dart';

class SettingsView extends StatefulWidget {
  @override
  SettingsViewState createState() => new SettingsViewState();
}

class SettingsViewState extends State<SettingsView> {
  AnimationController _mcontroller;
  String hzPrecision = '2';
  String msPrecision = '2';
  String bpmPrecision = '2';
  String showMetronome = 'Yes';

  @override
  void initState() {
    super.initState();

    print("SettingsView initState started");
    getSettings();

  }

  @override
  Widget build(BuildContext context) {

    print("SettingsView build started");
    final AppContextInheritedWidgetState state = AppContextInheritedWidget.of(context);
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
                  new Expanded(
                    //color: Colors.deepOrange,
                    child: new Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: new Text("SETTINGS"),
                    )
                  ),
                ]
              ),
              new Row(
                children: [
                  new Expanded(
                    //color: Colors.deepOrange,
                      child: new Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: new Text("Hz Decimal Places:"),
                      )
                  ),
                  new Expanded(
                    child: new DropdownButton<String>(
                      value: hzPrecision,
                      onChanged: (String newValue) {
                        setState(() {
                          hzPrecision = newValue;
                        });
                        _saveSettings();
                        state.add('settings_hzprecision', hzPrecision);
//                        state.add('settings_msprecision', msPrecision);
//                        state.add('settings_bpmprecision', bpmPrecision);
//                        state.add('settings_showmetronome', showMetronome.);
                      },
                      items: <String>['0', '1', '2', '3']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      //decoration: new InputDecoration(labelText: "Decimal Places for Hz"),
                    )
                  )
                ]
              ),
              new Row(
                  children: [
                    new Expanded(
                      //color: Colors.deepOrange,
                        child: new Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: new Text("Ms Decimal Places:"),
                        )
                    ),
                    new Expanded(
                        child: new DropdownButton<String>(
                          value: msPrecision,
                          onChanged: (String newValue) {
                            setState(() {
                              msPrecision = newValue;
                            });
                            _saveSettings();
                          },
                          items: <String>['0', '1', '2', '3']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          //decoration: new InputDecoration(labelText: "Decimal Places for Hz"),
                        )
                    )
                  ]
              ),
              new Row(
                  children: [
                    new Expanded(
                      //color: Colors.deepOrange,
                        child: new Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: new Text("BPM Decimal Places:"),
                        )
                    ),
                    new Expanded(
                        child: new DropdownButton<String>(
                          value: bpmPrecision,
                          onChanged: (String newValue) {
                            setState(() {
                              bpmPrecision = newValue;
                            });
                            _saveSettings();
                          },
                          items: <String>['0', '1', '2', '3']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          //decoration: new InputDecoration(labelText: "Decimal Places for Hz"),
                        )
                    )
                  ]
              ),
              new Row(
                  children: [
                    new Expanded(
                      //color: Colors.deepOrange,
                        child: new Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: new Text("Show Metronome:"),
                        )
                    ),
                    new Expanded(
                        child: new DropdownButton<String>(
                          value: showMetronome,
                          onChanged: (String newValue) {
                            setState(() {
                              showMetronome = newValue;
                            });
                            _saveSettings();
                          },
                          items: <String>['Yes', 'No']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          //decoration: new InputDecoration(labelText: "Decimal Places for Hz"),
                        )
                    )
                  ]
              )

            ]
        )
    );
  }

  _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('settings_hzprecision', hzPrecision);
    await prefs.setString('settings_msprecision', msPrecision);
    await prefs.setString('settings_bpmprecision', bpmPrecision);
    await prefs.setString('settings_showmetronome', showMetronome);
    //print('after save history list  $historyList');

    print("Just saved settings, hzPrecision: " + hzPrecision);
  }

  Future getSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      hzPrecision = (prefs.getString('settings_hzprecision') ?? '2') ;
      msPrecision = (prefs.getString('settings_msprecision') ?? '2') ;
      bpmPrecision = (prefs.getString('settings_bpmprecision') ?? '2') ;
      showMetronome = (prefs.getString('settings_showmetronome') ?? 'Yes') ;
    });
    print("Just GOT settings, hzPrecision: " + hzPrecision);
  }
}
