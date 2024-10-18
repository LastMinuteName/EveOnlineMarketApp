import 'package:eve_online_market_application/model/entity/market_history.dart';
import 'package:eve_online_market_application/utils/formatting.dart';
import 'package:eve_online_market_application/utils/math.dart';
import 'package:flutter/material.dart';
import 'package:eve_online_market_application/model/web_calls/eve_esi.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../app_themes.dart';
import '../../constants/enums/eve_regions_market.dart';



class MarketAveragesSection extends StatefulWidget {
  final int typeID;
  const MarketAveragesSection({super.key, required this.typeID});

  @override
  State<MarketAveragesSection> createState() => _MarketAveragesSection();
}

class _MarketAveragesSection extends State<MarketAveragesSection> {
  late Future _marketHistoryFuture;

  @override
  initState() {
    _marketHistoryFuture = getMarketHistory(typeID: widget.typeID, regionID: Region.theForge.id);
  }

  @override
  Widget build(BuildContext context) {
    CustomTheme? customTheme = Theme.of(context).extension<CustomTheme>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Market Averages",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8.0),
        marketHistoryLatest(),
      ],
    );
  }

  Widget marketHistoryLatest() {
    CustomTheme? customTheme = Theme.of(context).extension<CustomTheme>();

    return FutureBuilder(
      future: _marketHistoryFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        AppLocalizations? appLocalizations = AppLocalizations.of(context);

        List<Map<String, dynamic?>> latestMarketHistory = [
          {
            "label": appLocalizations?.labelLowest,
            "price": null,

          },
          {
            "label": appLocalizations?.labelAverage,
            "price": null,
          },
          {
            "label": appLocalizations?.labelHighest,
            "price": null,
          }
        ];

        if (snapshot.hasData) {
          List<MarketHistory> marketHistoryData = snapshot.data;

          print(marketHistoryData.last.toString());
          print(marketHistoryData[marketHistoryData.length - 2].toString());

          if (marketHistoryData.isEmpty) {
            return Text('There is no historical market data for this item');
          }
          else {
            latestMarketHistory[0]["price"] = toCommaSeparated(marketHistoryData.last.lowest);
            latestMarketHistory[1]["price"] = toCommaSeparated(marketHistoryData.last.average);
            latestMarketHistory[2]["price"] = toCommaSeparated(marketHistoryData.last.highest);

            if (marketHistoryData.length > 1) {
              latestMarketHistory[0]["percentageChange"] = percentageChange(marketHistoryData[marketHistoryData.length - 2].lowest, marketHistoryData.last.lowest);
              latestMarketHistory[1]["percentageChange"] = percentageChange(marketHistoryData[marketHistoryData.length - 2].average, marketHistoryData.last.average);
              latestMarketHistory[2]["percentageChange"] = percentageChange(marketHistoryData[marketHistoryData.length - 2].highest, marketHistoryData.last.highest);
            }
          }
        }
        else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return SizedBox(
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.spaceEvenly,
            children: latestMarketHistory.map((element) =>
              Column(
                children: [
                  Text(
                    element["label"]!,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if(element["price"] != null) Text(
                    element["percentageChange"].toStringAsFixed(2),
                    style: TextStyle(
                      color: element["percentageChange"] > 0 ?
                        Theme.of(context).extension<CustomTheme>()?.valueIncrease :
                        Theme.of(context).extension<CustomTheme>()?.valueDecrease
                    ),
                  ),
                  element["price"] == null ? const CircularProgressIndicator() : Text(element["price"]!),
                ],
              ),
            ).toList(),
          )
        );
      }
    );
  }
}