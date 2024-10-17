import 'package:eve_online_market_application/model/entity/market_history.dart';
import 'package:eve_online_market_application/utils/formatting.dart';
import 'package:flutter/material.dart';
import 'package:eve_online_market_application/model/web_calls/eve_esi.dart';

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
    return FutureBuilder(
      future: _marketHistoryFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        Widget latestAverage = CircularProgressIndicator();
        Widget latestHighest = CircularProgressIndicator();
        Widget latestLowest = CircularProgressIndicator();

        if (snapshot.hasData) {
          List<MarketHistory> marketHistoryData = snapshot.data;

          if (marketHistoryData.isEmpty) {
            return Text('There is no historical market data for this item');
          }
          else {
            latestAverage = Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: toCommaSeparated(marketHistoryData.last.average)),
                ],
              ),
            );

            latestHighest = Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: toCommaSeparated(marketHistoryData.last.highest)),
                ],
              ),
            );

            latestLowest = Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: toCommaSeparated(marketHistoryData.last.lowest)),
                ],
              ),
            );
          }
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
                    "Lowest",
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  latestLowest,
                ],
              ),
              Column(
                children: [
                  Text(
                    "Average",
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  latestAverage,
                ],
              ),Column(
                children: [
                  Text(
                    "Highest",
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  latestHighest,
                ],
              )
            ],
          )
        );
      }
    );
  }
  
}