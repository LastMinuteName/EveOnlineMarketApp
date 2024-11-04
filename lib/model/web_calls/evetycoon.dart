import 'dart:convert';
import '../entity/market_order.dart';
import 'package:http/http.dart' as http;

import '../entity/market_stats.dart';

Future<MarketOrders> getMarketOrders({required int typeID}) async {
  final response = await http.get(Uri.parse('https://evetycoon.com/api/v1/market/orders/$typeID'));

  MarketOrders result;

  if (response.statusCode == 200) {
    Map<String, dynamic> decodedResponse = jsonDecode(response.body);

    result = MarketOrders.fromJson(decodedResponse);
  }
  else {
    throw Exception('Market History fetch returned code ${response.statusCode}');
  }

  return result;
}

Future<MarketStats> getMarketStats({required int typeID, required int regionID}) async {
  final response = await http.get(Uri.parse('https://evetycoon.com/api/v1/market/stats/$regionID/$typeID'));

  MarketStats result;

  if (response.statusCode == 200) {
    Map<String, dynamic> decodedResult = jsonDecode(response.body);

    result = MarketStats.fromJson(decodedResult);
  }
  else {
    throw Exception("Market Stats fetch returned code ${response.statusCode}");
  }

  return result;
}
