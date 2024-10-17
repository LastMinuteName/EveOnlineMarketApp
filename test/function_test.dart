import 'package:eve_online_market_application/model/entity/market_history.dart';
import 'package:eve_online_market_application/model/web_calls/eve_esi.dart';

void main() async {
  List<MarketHistory> response = await getMarketHistory(typeID: 17478, regionID: 10000002);

  for (var element in response) {
    print(element.toString());
  }
}