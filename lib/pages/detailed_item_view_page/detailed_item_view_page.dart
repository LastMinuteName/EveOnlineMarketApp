import 'package:eve_online_market_application/pages/detailed_item_view_page/market_averages_section.dart';
import 'package:eve_online_market_application/utils/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../app_themes.dart';
import '../../model/entity/inv_types.dart';
import '../../utils/icon_grabber.dart';
import '../../utils/reusable_widgets.dart';
import '../../model/database/dbmodel.dart';

class DetailedItemViewPage extends StatefulWidget {
  final int typeID;
  const DetailedItemViewPage({super.key, required this.typeID});

  @override
  State<DetailedItemViewPage> createState() => _DetailedItemViewPageState();
}

class _DetailedItemViewPageState extends State<DetailedItemViewPage> {
  InvTypes? item;

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
      future: dbConn.readInvTypesByTypeID(widget.typeID),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return centeredCircularProgressIndicator();
        }

        if (snapshot.hasData) {
          item = snapshot.data;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
              child: Column(
                children: [
                  const SizedBox(height: 8.0),
                  _titleCard(),
                  const SizedBox(height: 8.0),
                  _actionSegment(),
                  const SizedBox(height: 8.0),
                  _description(),
                  const SizedBox(height: 16.0),
                  MarketAveragesSection(typeID: widget.typeID),
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

  Widget _actionSegment() {
    Widget actionSegment = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          onPressed: () {  },
          child: Column(
            children: [
              Icon(Icons.favorite_outline),
              Text("Watchlist"),
            ],
          ),
        ),
        TextButton(
          onPressed: () {  },
          child: Column(
            children: [
              Icon(Icons.favorite),
              Text("Watchlist"),
            ],
          ),
        )
      ],
    );

    return actionSegment;
  }

  Widget _description() {
    return ExpandableText(
      text: item!.description,
      maxLines: 4,
      overflow: TextOverflow.fade,
    );
  }

  Widget _buySellOrders() {
    return Placeholder();
  }


}