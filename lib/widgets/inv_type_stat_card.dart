import 'package:eve_online_market_application/model/web_calls/eve_esi.dart';
import 'package:eve_online_market_application/widgets/reusable_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/enums/eve_regions_market.dart';
import '../model/controller/shared_preferences_controller.dart';
import '../model/database/dbmodel.dart';
import '../model/entity/inv_type.dart';
import '../model/web_calls/evetycoon.dart';
import '../utils/icon_grabber.dart';

class InvTypeStatCard extends StatefulWidget {
  final int typeID;
  const InvTypeStatCard({super.key, required this.typeID});

  @override
  State<InvTypeStatCard> createState() => _InvTypeStatCardState();
}

class _InvTypeStatCardState extends State<InvTypeStatCard> {
  Future? _marketHistoryFuture;
  Future? _marketStatsFuture;
  Region? _region;

  @override
  Widget build(BuildContext context) {
    DbModel dbModel = Provider.of<DbModel>(context);
    SharedPreferencesController prefController = Provider.of<SharedPreferencesController>(context);
    _region = _region ?? prefController.getMarketRegion();
    _marketHistoryFuture ?? getMarketHistory(typeID: widget.typeID, regionID: _region!.id);
    _marketStatsFuture ?? getMarketStats(typeID: widget.typeID, regionID: _region!.id);

    return Card(
      child: FutureBuilder(
        future: dbModel.readInvTypeByTypeID(widget.typeID),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
            return CircularProgressIndicator();
          }

          InvType invType = snapshot.data;

          return ListTile(
            leading: fetchInvTypeIcon(invType.typeID ?? 0),
            title: Text(invType.typeName),
          );
        }
      ),
    );
  }
}