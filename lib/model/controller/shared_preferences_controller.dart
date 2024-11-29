import 'package:eve_online_market_application/constants/enums/eve_regions_market.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eve_online_market_application/constants/shared_preferences_constants.dart' as pref_constants;

class SharedPreferencesController with ChangeNotifier {
  static late SharedPreferences _preferences;

  Future<String> initController() async {
    _preferences = await SharedPreferences.getInstance();
    return "Shared Preferences Loaded";
  }

  Region getMarketRegion() {
    String? regionString = _preferences.getString(pref_constants.MARKET_REGION);
    return regionString != null ? Region.values.byName(regionString) : Region.theForge;
  }

  void setMarketRegion(Region region) {
    String regionByName = region.toString().split(".").elementAt(1);
    _preferences.setString(pref_constants.MARKET_REGION, regionByName);
  }

  Set<int> getOrdersFilter() {
    List<String>? ordersFilterList = _preferences.getStringList(pref_constants.ORDERS_FILTER);
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

    _preferences.setStringList(pref_constants.ORDERS_FILTER, ordersFilterList);
  }

  void clear() {
    _preferences.clear();
  }
}