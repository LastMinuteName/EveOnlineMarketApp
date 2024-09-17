import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../model/data/invTypes.dart';
import '../utils/icon_grabber.dart';
import '../utils/reusable_widgets.dart';
import '../model/database/dbmodel.dart';

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
        title: Text(AppLocalizations.of(context)!.itemBrowserPageTitle),
        actions: [
          IconButton(
              onPressed: (){
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
              icon: const Icon(Icons.home)
          ),
        ],
      ),
      body: body(),
    );
  }

  Widget body() {
    DbModel dbConn = Provider.of<DbModel>(context);

    FutureBuilder body = FutureBuilder(
      future: dbConn.readInvTypesByTypeID(widget.typeID),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        Widget body;

        if (snapshot.connectionState == ConnectionState.waiting) {
          return centeredCircularProgressIndicator();
        }

        if (snapshot.hasData) {
          item = snapshot.data;
          return titleCard();
        }
        else {
          return centeredCircularProgressIndicator();
        }
      },
    );

    return body;
  }

  Widget titleCard() {
    Widget titleCard = Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          height: 128,
          width: 128,
          child: fetchInvTypeIcon(item!.typeID),
        ),
        Flexible(
          child: Text(
            item!.typeName,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
    return titleCard;
  }

  Widget actionSegment() {
    Widget actionSegment = Row(
      children: [
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

  Widget description() {
    return Placeholder();
  }

  Widget marketAverages() {
    return Placeholder();
  }

  Widget buySellOrders() {
    return Placeholder();
  }


}