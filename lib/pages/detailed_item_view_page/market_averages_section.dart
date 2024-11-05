import 'package:eve_online_market_application/model/entity/market_history.dart';
import 'package:eve_online_market_application/utils/formatting.dart';
import 'package:eve_online_market_application/utils/math.dart';
import 'package:flutter/material.dart';
import 'package:eve_online_market_application/model/web_calls/eve_esi.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../app_themes.dart';
import '../../constants/enums/eve_regions_market.dart';
import '../../model/entity/market_stats.dart';
import '../../model/web_calls/evetycoon.dart';



class MarketAveragesSection extends StatefulWidget {
  final Future marketHistoryFuture;
  final Future marketStatsFuture;
  const MarketAveragesSection({super.key, required this.marketHistoryFuture, required this.marketStatsFuture});

  @override
  State<MarketAveragesSection> createState() => _MarketAveragesSection();
}

class _MarketAveragesSection extends State<MarketAveragesSection> {
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
        marketHistoryLatestSection(),
        const SizedBox(height: 8.0),
        fivePercentAverageSection(),
      ],
    );
  }

  Widget marketHistoryLatestSection() {
    CustomTheme? customTheme = Theme.of(context).extension<CustomTheme>();
    AppLocalizations? appLocalizations = AppLocalizations.of(context);

    Widget body = FutureBuilder(
      future: widget.marketHistoryFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        List<Map<String, dynamic>> latestMarketHistory = [
          {
            "label": appLocalizations!.labelLowest,
            "price": null,

          },
          {
            "label": appLocalizations!.labelAverage,
            "price": null,
          },
          {
            "label": appLocalizations!.labelHighest,
            "price": null,
          }
        ];

        if (snapshot.hasData) {
          List<MarketHistory> marketHistoryData = snapshot.data;

          if (marketHistoryData.isEmpty) {
            return Text(appLocalizations!.noMarketHistory);
          }
          else {
            latestMarketHistory[0]["price"] = toCommaSeparated(marketHistoryData.last.lowest);
            latestMarketHistory[1]["price"] = toCommaSeparated(marketHistoryData.last.average);
            latestMarketHistory[2]["price"] = toCommaSeparated(marketHistoryData.last.highest);

            if (marketHistoryData.length > 1) {
              latestMarketHistory[0]["percentageChange"] = calculatePercentageChange(marketHistoryData[marketHistoryData.length - 2].lowest, marketHistoryData.last.lowest);
              latestMarketHistory[1]["percentageChange"] = calculatePercentageChange(marketHistoryData[marketHistoryData.length - 2].average, marketHistoryData.last.average);
              latestMarketHistory[2]["percentageChange"] = calculatePercentageChange(marketHistoryData[marketHistoryData.length - 2].highest, marketHistoryData.last.highest);
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
                  if(element["price"] != null) Text.rich(
                    TextSpan(
                      style: TextStyle(
                        color: element["percentageChange"] > 0 ?
                          Theme.of(context).extension<CustomTheme>()?.valueIncrease :
                          Theme.of(context).extension<CustomTheme>()?.valueDecrease
                      ),
                      children: [
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: element["percentageChange"] > 0 ?
                          Icon(
                            Icons.arrow_upward,
                            color: customTheme?.valueIncrease,
                          ) :
                          Icon(
                            Icons.arrow_downward,
                            color: customTheme?.valueDecrease,
                          ),
                        ),
                        TextSpan(text: "${element["percentageChange"].toStringAsFixed(2)}%"),
                      ]
                    )
                  ),
                  element["price"] == null ? const CircularProgressIndicator() : Text(element["price"]!),
                ],
              ),
            ).toList(),
          )
        );
      }
    );

    return Column(
      children: [
        Text(
          appLocalizations!.marketHistory,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        body
      ],
    );
  }

  Widget fivePercentAverageSection() {
    AppLocalizations? appLocalizations = AppLocalizations.of(context);

    Widget body = FutureBuilder(
      future: widget.marketStatsFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        Text? buyAvg;
        Text? sellAvg;

        if(snapshot.hasData) {
          MarketStats marketStatsData = snapshot.data;
          buyAvg = Text(toCommaSeparated(marketStatsData.buyAvgFivePercent));
          sellAvg = Text(toCommaSeparated(marketStatsData.sellAvgFivePercent));
        }
        else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return SizedBox(
          width: double.infinity,
          child: Wrap(
              alignment: WrapAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      appLocalizations!.buy,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    buyAvg ?? const CircularProgressIndicator(),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      appLocalizations!.sell,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    sellAvg ?? const CircularProgressIndicator(),
                  ],
                ),
              ]
          ),
        );
      }
    );

    return Column(
      children: [
        Text(
          appLocalizations!.currentPricesFivePercent,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        body,
      ],
    );
  }
}