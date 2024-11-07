import 'package:eve_online_market_application/model/entity/market_history.dart';
import 'package:eve_online_market_application/utils/formatting.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../app_themes.dart';

const List<int> timeframeDiff = [
  7, // week
  31, // month
  365, // year
  9999, // all
];

class MarketHistoryGraph extends StatefulWidget {
  const MarketHistoryGraph({super.key, required this.marketHistoryFuture});
  final Future marketHistoryFuture;

  @override
  State<MarketHistoryGraph> createState() => _MarketHistoryGraphState();
}

class _MarketHistoryGraphState extends State<MarketHistoryGraph> {
  final List<bool> _selectedTimeframe = <bool>[true, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        graph(),
        timeFrameSelector(),
      ],
    );
  }

  Widget graph() {
    return FutureBuilder(
      future: widget.marketHistoryFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        var flSpotData, marketHistory;
        if (snapshot.hasData) {
          (flSpotData, marketHistory) = marketHistoryToLineChartData(snapshot.data);
        }

        return AspectRatio(
          aspectRatio: 4/3,
          child: LineChart(
            LineChartData(
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  fitInsideHorizontally: true,
                  fitInsideVertically: true,
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((LineBarSpot touchedSpot) {
                      return LineTooltipItem(
                          '',
                          Theme.of(context).textTheme.bodySmall!,
                          children: [
                            TextSpan(text: '${toCommaSeparated(marketHistory![touchedSpot.spotIndex].average)}\n'),
                            TextSpan(text: DateFormat('dd MMM yyyy').format(marketHistory![touchedSpot.spotIndex].date)),
                          ]
                      );
                    }).toList();
                  }
                )
              ),
              borderData: FlBorderData(
                show: true,
              ),
              titlesData: const FlTitlesData(show: false),
              gridData: const FlGridData(
                show: false,
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: snapshot.hasData ? flSpotData : [],
                  dotData: const FlDotData(
                    show: false,
                  ),
                  color: Color.lerp(Theme.of(context).colorScheme.primary, Theme.of(context).extension<CustomTheme>()!.valueIncrease, 0.5),
                ),
              ],
              clipData: const FlClipData.all(),
            ),
          ),
        );
      }
    );
  }

  Widget timeFrameSelector() {
    AppLocalizations? appLocalizations = AppLocalizations.of(context);
    List<Widget> timeframes = [
      Text("Week"),
      Text("Month"),
      Text("Year"),
      Text("All"),
    ];

    return ToggleButtons(
      direction: Axis.horizontal,
      onPressed: (int index) {
        setState(() {
          for(int i = 0; i < _selectedTimeframe.length; i++) {
            _selectedTimeframe[i] = i == index;
          }
        });
      },
      isSelected: _selectedTimeframe,
      children: timeframes,
    );
  }

  (List<FlSpot>, List<MarketHistory>) marketHistoryToLineChartData(List<MarketHistory> data) {
    List<FlSpot> marketHistoryFlSpot = [];
    List<MarketHistory> marketHistory = [];
    int selectedTimeframeIndex = 4;
    DateTime timeframeForComparison;

    for(int i = 0; i < _selectedTimeframe.length; i++) {
      if(_selectedTimeframe[i] == true) {
        selectedTimeframeIndex = i;
      }
    }

    timeframeForComparison = data.last.date.subtract(Duration(days: timeframeDiff[selectedTimeframeIndex]));

    for(int i = 0; i < data.length; i++) {
      if (data[i].date.millisecondsSinceEpoch >= timeframeForComparison.millisecondsSinceEpoch) {
        marketHistory.add(data[i]);
        marketHistoryFlSpot.add(
          FlSpot(
            data[i].date.millisecondsSinceEpoch.toDouble(),
            data[i].average
          )
        );
      }
    }

    return (marketHistoryFlSpot, marketHistory);
  }
}
