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

  Set<int> getOrdersFilter() {
    List<String>? ordersFilterList = _preferences.getStringList("orders_filter");
    Set<int> ordersFilterSet = {};

    if (ordersFilterList != null) {
      for (var element in ordersFilterList) {
        ordersFilterSet.add(int.parse(element));
      }
    }

    return ordersFilterSet;
  }

  void setOrdersFilter(Set<int> ordersFilterSet) {
    List<String> ordersFilterList = [];

    for (var regionID in ordersFilterSet) {
      ordersFilterList.add(regionID.toString());
    }

    _preferences.setStringList("orders_filter", ordersFilterList);
  }

  void clear() {
    _preferences.clear();
  }
}