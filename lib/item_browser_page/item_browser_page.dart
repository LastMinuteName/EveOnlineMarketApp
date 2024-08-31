import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../model/database/dbmodel.dart';
import 'package:path/path.dart';
import 'package:eve_online_market_application/utils/icon_grabber.dart';

import '../utils/reusable_widgets.dart';

class ItemBrowserPage extends StatefulWidget {
  const ItemBrowserPage({super.key});

  @override
  State<ItemBrowserPage> createState() => _ItemBrowserPageState();
}

class _ItemBrowserPageState extends State<ItemBrowserPage> {
  List<Map> itemNavigationPath = [
    {
      "marketGroupID": -1,
      "marketGroupName": "Browse",
      "hasTypes": 0
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

    for (int i = 0; i < itemNavigationPath.length; i++) {
      listViewContent.add(Center(
        child: SizedBox(
          height: 30,
          child: TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero
              )
            ),
            onPressed: () {if (i != itemNavigationPath.length - 1)backtrackPathTo(itemNavigationPath[i]["marketGroupID"]); },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                itemNavigationPath[i]["marketGroupName"],
                style: const TextStyle(
                  color: Colors.black,
                ),
              )
            )
          )
        )
      ));

      if (i != itemNavigationPath.length - 1) {
        listViewContent.add(Center(child: Text(">")));
      }
    }

    return Container(
      height: 30,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: listViewContent
      ),
    );
  }

  Widget marketList(BuildContext context) {
    if (itemNavigationPath.last["hasTypes"] == 1) {
      return invTypesList(context);
    }

    return invMarketGroupList(context);
  }

  FutureBuilder invMarketGroupList(BuildContext context) {
    DbModel dbConn = Provider.of<DbModel>(context);

    return FutureBuilder(
      future: dbConn.readInvMarketGroups(parentGroupID: itemNavigationPath.last["marketGroupID"]),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        Widget body;

        if (snapshot.connectionState == ConnectionState.waiting) {
          body = centeredCircularProgressIndicator();
          return body;
        }

        if (snapshot.hasData) {
          body = ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                dense: true,
                visualDensity: const VisualDensity(vertical: 4),
                onTap: (){addPath(snapshot.data[index]);},
                leading: SizedBox(
                    width: 64,
                    height: 64,
                    child: fetchMarketGroupIcon(snapshot.data[index]["iconID"] ?? 0)
                ),
                title: Text(snapshot.data[index]["marketGroupName"]),
              );
            },
          );
        }
        else {
          body = centeredCircularProgressIndicator();
        }

        return body;
      }
    );
  }

  FutureBuilder invTypesList(BuildContext context) {
    DbModel dbConn = Provider.of<DbModel>(context);

    return FutureBuilder(
        future: dbConn.readInvTypesGroup(itemNavigationPath.last["marketGroupID"].toString()),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          Widget body;

          if (snapshot.connectionState == ConnectionState.waiting) {
            body = centeredCircularProgressIndicator();
            return body;
          }

          if (snapshot.hasData) {
            body = ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  dense: true,
                  visualDensity: const VisualDensity(vertical: 4),
                  onTap: (){},
                  leading: SizedBox(
                      width: 64,
                      height: 64,
                      child: fetchInvTypeIcon(snapshot.data[index]["typeID"] ?? 0)
                  ),
                  title: Text(snapshot.data[index]["typeName"]),
                );
              },
            );
          }
          else {
            body = centeredCircularProgressIndicator();
          }

          return body;
        }
    );
  }

  void addPath(Map invMarketGroup) {
    setState(() {
      itemNavigationPath.add(
        {
          "marketGroupID": invMarketGroup["marketGroupID"],
          "marketGroupName": invMarketGroup["marketGroupName"],
          "hasTypes": invMarketGroup["hasTypes"]
        }
      );
    });
  }

  void backtrackPathTo(int marketGroupID) {
    bool backtracked = false;

    while (backtracked == false) {
      if (itemNavigationPath.last["marketGroupID"] == marketGroupID) {
        backtracked = true;
      }
      else {
        itemNavigationPath.removeLast();
      }
    }

    setState(() {});
  }
}