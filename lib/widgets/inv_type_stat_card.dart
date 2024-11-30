import 'package:eve_online_market_application/model/web_calls/eve_esi.dart';
import 'package:eve_online_market_application/widgets/market_stat.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/enums/eve_regions_market.dart';
import '../model/controller/shared_preferences_controller.dart';
import '../model/database/dbmodel.dart';
import '../model/entity/inv_type.dart';
import '../model/entity/market_history.dart';
import '../model/entity/market_stats.dart';
import '../model/web_calls/evetycoon.dart';
import '../utils/formatting.dart';
import '../utils/icon_grabber.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../utils/math.dart';

class InvTypeStatCard extends StatefulWidget {
  final int typeID;
  const InvTypeStatCard({super.key, required this.typeID});

  @override
  State<InvTypeStatCard> createState() => _InvTypeStatCardState();
}

class _InvTypeStatCardState extends State<InvTypeStatCard> {
  Region? _region;

  @override
  Widget build(BuildContext context) {
    DbModel dbModel = Provider.of<DbModel>(context);
    SharedPreferencesController prefController = Provider.of<SharedPreferencesController>(context);
    _region = _region ?? prefController.getMarketRegion();

    return Card(
      child: FutureBuilder(
        future: dbModel.readInvTypeByTypeID(widget.typeID),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          InvType invType = snapshot.data;

          return Column(
            children: [
              const SizedBox(height: 8),
              fetchInvTypeIcon(invType.typeID ?? 0),
              Text(
                invType.typeName,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              //_fivePercentAverageSection(),
              const SizedBox(height: 8),
              _marketAverageSection(),
            ],
          );
        }
      ),
    );
  }

  Widget _fivePercentAverageSection() {
    AppLocalizations? appLocalizations = AppLocalizations.of(context);
    Future marketStatsFuture = getMarketStats(typeID: widget.typeID, regionID: _region!.id);

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return FutureBuilder(
          future: marketStatsFuture,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            String? buyAvg;
            String? sellAvg;

            if(snapshot.hasData) {
              MarketStats marketStatsData = snapshot.data;
              buyAvg = toCommaSeparated(marketStatsData.buyAvgFivePercent);
              sellAvg = toCommaSeparated(marketStatsData.sellAvgFivePercent);
            }
            return Wrap(
              children: [
                MarketStat(
                  label: appLocalizations!.labelBuy,
                  price: buyAvg,
                ),
                MarketStat(
                  label: appLocalizations!.labelSell,
                  price: sellAvg,
                ),
              ],
            );
          }
        );
      }
    );
  }

  Widget _marketAverageSection() {
    AppLocalizations? appLocalizations = AppLocalizations.of(context);
    Future marketHistoryFuture = getMarketHistory(typeID: widget.typeID, regionID: _region!.id);

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return FutureBuilder(
          future: marketHistoryFuture,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            double? percentageChange;
            String? priceAverage;

            if (snapshot.hasData) {
              List<MarketHistory> marketHistoryData = snapshot.data;
              percentageChange = calculatePercentageChange(
                marketHistoryData[marketHistoryData.length - 2].average,
                marketHistoryData.last.average
              );
              priceAverage = toCommaSeparated(marketHistoryData.last.average);
            }

            return MarketStat(
              label: appLocalizations!.labelAverage,
              percentageChange: percentageChange,
              price: priceAverage,
            );
          }
        );
      }
    );
  }
}