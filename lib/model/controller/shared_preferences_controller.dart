import 'package:eve_online_market_application/constants/enums/eve_regions_market.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesController with ChangeNotifier {
  static late SharedPreferences _preferences;

  Future<String> initController() async {
    _preferences = await SharedPreferences.getInstance();
    return "Shared Preferences Loaded";
  }

  Region? getMarketRegion() {
    String? regionString = _preferences.getString("market_region");
    return regionString != null ? Region.values.byName(regionString) : null;
  }

  void setMarketRegion(Region region) {
    String regionByName = region.toString().split(".").elementAt(1);
    _preferences.setString("market_region", regionByName);
  }

  void clear() {
    _preferences.clear();
  }
}