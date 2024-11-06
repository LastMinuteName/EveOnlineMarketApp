import 'package:eve_online_market_application/model/entity/market_history.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MarketHistoryGraph extends StatefulWidget {
  const MarketHistoryGraph({super.key, required this.marketHistoryFuture});
  final Future marketHistoryFuture;

  @override
  State<MarketHistoryGraph> createState() => _MarketHistoryGraphState();
}

class _MarketHistoryGraphState extends State<MarketHistoryGraph> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.marketHistoryFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return AspectRatio(
          aspectRatio: 4/3,
          child: LineChart(
            LineChartData(
              borderData: FlBorderData(
                show: false,
              ),
              titlesData: FlTitlesData(
                topTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    reservedSize: 40,
                    showTitles: true,
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    reservedSize: 22,
                    showTitles: true,
                  ),
                ),
              ),
              gridData: FlGridData(
                show: false,
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: snapshot.hasData ? marketHistoryToLineChartData(snapshot.data) : [],
                  dotData: const FlDotData(
                    show: false,
                  ),
                  color: Colors.green,
                ),
              ],
            )
          ),
        );
      }
    );
  }

  List<FlSpot> marketHistoryToLineChartData(List<MarketHistory> data) {
    List<FlSpot> marketHistoryFlSpot = [];

    for(int i = data.length - 1; i > data.length - 1 - 7; i--) {
      marketHistoryFlSpot.add(
        FlSpot(
          data[i].date.millisecondsSinceEpoch.toDouble(),
          data[i].average
        )
      );
    }

    return marketHistoryFlSpot;
  }
}
