import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:shared_preferences/shared_preferences.dart';

class _AppContextInherited extends InheritedWidget {
  _AppContextInherited({
    Key key,
    @required Widget child,
    @required this.data,
  }) : super(key: key, child: child);

  final AppContextInheritedWidgetState data;

  @override
  bool updateShouldNotify(_AppContextInherited oldWidget) {
    return true;
  }
}

class AppContextInheritedWidget extends StatefulWidget {
  AppContextInheritedWidget({
    Key key,
    this.child,
  }): super(key: key);

  final Widget child;

  @override
  AppContextInheritedWidgetState createState() => new AppContextInheritedWidgetState();

  static AppContextInheritedWidgetState of(BuildContext context){
    return (context.inheritFromWidgetOfExactType(_AppContextInherited) as _AppContextInherited).data;
  }
}

class AppContextInheritedWidgetState extends State<AppContextInheritedWidget>{

  HashMap _appContext = new HashMap<String, String>();

  /// Getter (number of items)
  int get appContextCount => _appContext.length;

  /// Helper method to add an Item
  void add(String key, String value){
    setState((){
      _appContext[key] = value;
    });
  }

  /// Helper method to add an Item
  String get(String key){
    return _appContext[key];
  }

  @override
  void initState() {
    super.initState();

    print("AppContextInheritedWidgetState initState started");
    getSettings();
  }

  @override
  Widget build(BuildContext context){
    return new _AppContextInherited(
      data: this,
      child: widget.child,
    );
  }

  Future getSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _appContext['settings_hzprecision'] = (prefs.getString('settings_hzprecision') ?? '2') ;
      _appContext['settings_msprecision'] = (prefs.getString('settings_msprecision') ?? '2') ;
      _appContext['settings_bpmprecision'] = (prefs.getString('settings_bpmprecision') ?? '2') ;
      _appContext['settings_showmetronome'] = (prefs.getString('settings_showmetronome') ?? '2') ;
    });

    print("AppContextInheritedWidgetState Just GOT settings, hzPrecision: " + _appContext['settings_hzprecision']);
  }
}
