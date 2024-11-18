import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesController with ChangeNotifier {
  static late final SharedPreferences _preferences;

  Future initController() async {
    _preferences = await SharedPreferences.getInstance();
  }
}