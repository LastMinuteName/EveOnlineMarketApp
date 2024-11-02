import 'dart:convert';
import '../entity/market_order.dart';
import 'package:http/http.dart' as http;

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
