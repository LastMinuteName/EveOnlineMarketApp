import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../model/database/dbmodel.dart';
import 'package:path/path.dart';
import 'package:eve_online_market_application/utils/icon_grabber.dart';

class ItemBrowserPage extends StatefulWidget {
  const ItemBrowserPage({super.key});

  @override
  State<ItemBrowserPage> createState() => _ItemBrowserPageState();
}

class _ItemBrowserPageState extends State<ItemBrowserPage> {
  List<Map> itemNavigationPath = [
    {
      "parentGroupID": "NULL",
      "marketGroupName": "Browse"
    }
  ];

  @override
  Widget build(BuildContext context) {
    Widget body = Column(
      children: [
        marketDirectories(context),
        Expanded(child: marketList(context))
      ],
    );

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
              onPressed: (){},
              icon: const Icon(Icons.search)
          ),
        ],
      ),
      body: body,
    );
  }

  Widget marketDirectories(BuildContext context) {
    List<Widget> listViewContent = [];

    itemNavigationPath.forEach((element) {
      listViewContent.add(Text(element["marketGroupName"]));
    });

    return Container(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: listViewContent
      ),
    );
  }

  Widget marketList(BuildContext context) {
    DbModel dbConn = Provider.of<DbModel>(context);

    return FutureBuilder(
      future: dbConn.readInvMarketGroups(parentGroupID: itemNavigationPath.last["parentGroupID"]),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        Widget body;

        if (snapshot.hasData) {
          body = ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: SizedBox(
                    width: 64,
                    height: 64,
                    child: fetchMarketGroupIcon(snapshot.data![index]["iconID"] ?? 0)
                ),
                title: Text(snapshot.data![index]["marketGroupName"]),
              );
            },
          );
        }
        else {
          body = SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(),
          );
        }

        return body;
      }
    );
  }
}