//File contains an assortment of functions to get data from the eve ESI endpoint

import 'dart:convert';
import 'package:eve_online_market_application/model/entity/market_history.dart';
import 'package:http/http.dart' as http;
import '../entity/market_order.dart';

Future<List<MarketHistory>> getMarketHistory({required int typeID, required int regionID}) async {
  final response = await http.get(Uri.parse('https://esi.evetech.net/latest/markets/$regionID/history/?type_id=$typeID'));
  List<MarketHistory> result = [];

  if (response.statusCode == 200) {
    List<dynamic> decodedResponse = jsonDecode(response.body);

    for (Map<String, dynamic> element in decodedResponse) {
      result.add(MarketHistory.fromJson(element));
    }
  }
  else {
    throw Exception('Market History fetch returned code ${response.statusCode}');
  }

  return result;
}