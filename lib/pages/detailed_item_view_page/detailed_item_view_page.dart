import 'package:eve_online_market_application/model/entity/watchlist.dart';
import 'package:eve_online_market_application/pages/detailed_item_view_page/action_section.dart';
import 'package:eve_online_market_application/pages/detailed_item_view_page/market_averages_section.dart';
import 'package:eve_online_market_application/pages/detailed_item_view_page/market_orders_section.dart';
import 'package:eve_online_market_application/utils/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_themes.dart';
import '../../constants/enums/eve_regions_market.dart';
import '../../model/entity/inv_type.dart';
import '../../model/web_calls/eve_esi.dart';
import '../../model/web_calls/evetycoon.dart';
import '../../utils/icon_grabber.dart';
import '../../widgets/reusable_widgets.dart';
import '../../model/database/dbmodel.dart';

class DetailedItemViewPage extends StatefulWidget {
  final int typeID;
  const DetailedItemViewPage({super.key, required this.typeID});

  @override
  State<DetailedItemViewPage> createState() => _DetailedItemViewPageState();
}

class _DetailedItemViewPageState extends State<DetailedItemViewPage> {
  InvType? item;
  late Future _marketOrdersFuture;

  @override
  initState() {
    super.initState();
    _marketOrdersFuture = getMarketOrders(typeID: widget.typeID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)
        ),
        actions: [
          IconButton(
              onPressed: (){
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
              icon: const Icon(Icons.home)
          ),
        ],
      ),
      body: _body(),
    );
  }

  Widget _body() {
    DbModel dbConn = Provider.of<DbModel>(context);

    FutureBuilder body = FutureBuilder(
      future: Future.wait([
        dbConn.readInvTypeByTypeID(widget.typeID),
        dbConn.readWatchlistTypeID(widget.typeID)
      ]),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return centeredCircularProgressIndicator();
        }

        if (snapshot.hasData) {
          item = snapshot.data[0];
          List<Watchlist> watchlist = snapshot.data[1];

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
              child: Column(
                children: [
                  const SizedBox(height: 8.0),
                  _titleCard(),
                  const SizedBox(height: 8.0),
                  ActionSection(typeID: widget.typeID, watchlisted: watchlist.isNotEmpty),
                  const SizedBox(height: 8.0),
                  _description(),
                  const SizedBox(height: 16.0),
                  MarketAveragesSection(typeID: widget.typeID),
                  const SizedBox(height: 16.0),
                  MarketOrdersSection(marketOrdersFuture: _marketOrdersFuture),
                ],
              ),
            ),
          );
        }
        else {
          return centeredCircularProgressIndicator();
        }
      },
    );

    return body;
  }

  Widget _titleCard() {
    CustomTheme? customTheme = Theme.of(context).extension<CustomTheme>();
    GlobalKey;
    Widget titleCard = Row(
      children: [
        SizedBox(
          height: 128,
          width: 128,
          child: fetchInvTypeIcon(item!.typeID),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            item!.typeName,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
    return titleCard;
  }

  Widget _description() {
    return ExpandableText(
      text: item!.description,
      maxLines: 4,
      overflow: TextOverflow.fade,
    );
  }
}