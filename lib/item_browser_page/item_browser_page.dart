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
  List<Map> _itemNavigationPath = [
    {
      "marketGroupID": -1,
      "marketGroupName": "Browse",
      "hasTypes": 0
    }
  ];

  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    Widget body = Column(
      children: [
        Expanded(child: _marketList(context))
      ],
    );

    return Scaffold(
      appBar: pageAppBar(context),
      body: body,
    );
  }

  AppBar pageAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back)
      ),
      title: Text(AppLocalizations.of(context)!.itemBrowserPageTitle),
      actions: [
        IconButton(
            onPressed: (){setState(() {
              _isSearching = !_isSearching;
            });},
            icon: const Icon(Icons.search)
        ),
      ],
      bottom: _marketDirectories(),
    );
  }

  PreferredSize _marketDirectories() {
    List<Widget> listViewContent = [];

    for (int i = 0; i < _itemNavigationPath.length; i++) {
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
            onPressed: () {if (i != _itemNavigationPath.length - 1)_backtrackPathTo(_itemNavigationPath[i]["marketGroupID"]); },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                _itemNavigationPath[i]["marketGroupName"],
                style: const TextStyle(
                  color: Colors.black,
                ),
              )
            )
          )
        )
      ));

      if (i != _itemNavigationPath.length - 1) {
        listViewContent.add(Center(child: Text(">")));
      }
    }

    return PreferredSize(
      preferredSize: const Size.fromHeight(30),
      child: Container(
        height: 30,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: listViewContent
        ),
      )
    );
  }

  Widget _marketList(BuildContext context) {
    if (_isSearching) {
      return _invTypesSearchList(context);
    }

    if (_itemNavigationPath.last["hasTypes"] == 1) {
      return _invTypesList(context);
    }

    return _invMarketGroupList(context);
  }

  Widget _invTypesSearchList(BuildContext context) {
    DbModel dbConn = Provider.of<DbModel>(context);

    return FutureBuilder(
        future: dbConn.readInvTypesByTypeName(""),
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

  FutureBuilder _invMarketGroupList(BuildContext context) {
    DbModel dbConn = Provider.of<DbModel>(context);

    return FutureBuilder(
      future: dbConn.readInvMarketGroups(parentGroupID: _itemNavigationPath.last["marketGroupID"]),
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
                onTap: (){_addPath(snapshot.data[index]);},
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

  FutureBuilder _invTypesList(BuildContext context) {
    DbModel dbConn = Provider.of<DbModel>(context);

    return FutureBuilder(
        future: dbConn.readInvTypesGroup(_itemNavigationPath.last["marketGroupID"].toString()),
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

  void _addPath(Map invMarketGroup) {
    setState(() {
      _itemNavigationPath.add(
        {
          "marketGroupID": invMarketGroup["marketGroupID"],
          "marketGroupName": invMarketGroup["marketGroupName"],
          "hasTypes": invMarketGroup["hasTypes"]
        }
      );
    });
  }

  void _backtrackPathTo(int marketGroupID) {
    bool backtracked = false;

    while (backtracked == false) {
      if (_itemNavigationPath.last["marketGroupID"] == marketGroupID) {
        backtracked = true;
      }
      else {
        _itemNavigationPath.removeLast();
      }
    }

    setState(() {});
  }
}