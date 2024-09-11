import 'dart:async';
import 'package:eve_online_market_application/detailed_item_view_page/detailed_item_view_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../model/database/dbmodel.dart';
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
  final TextEditingController _textEditingController = TextEditingController();
  Timer? _searchDelayTimer;
  final int _delayDuration = 300;

  @override
  Widget build(BuildContext context) {
    Widget body = Column(
      children: [
        Expanded(child: _marketList(context))
      ],
    );

    return Scaffold(
      appBar: _isSearching ? _pageAppBarSearching(context) : _pageAppBar(context),
      body: body,
    );
  }

  AppBar _pageAppBar(BuildContext context) {
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
              _isSearching = true;
            });},
            icon: const Icon(Icons.search)
        ),
      ],
      bottom: _marketDirectories(),
    );
  }

  AppBar _pageAppBarSearching(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: TextField(
        autofocus: true,
        controller: _textEditingController,
        decoration: InputDecoration.collapsed(
            hintText: AppLocalizations.of(context)!.itemBrowserPageSearchHint
        ),
        onChanged: (String value) {
          _resetSearchDelayTimer();
        },
      ),
      actions: [
        IconButton(
          onPressed: () {
            _textEditingController.clear();

            setState(() {
              _isSearching = false;
            });
          },
          icon: const Icon(Icons.close),
        ),
      ],
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
        listViewContent.add(const Center(child: Text(">")));
      }
    }

    return PreferredSize(
      preferredSize: const Size.fromHeight(30),
      child: SizedBox(
        height: 30,
        child: ScrollConfiguration(
          behavior: const ScrollBehavior(),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: listViewContent
          ),
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
    Future<List> futureData = dbConn.readInvTypesByTypeName(_textEditingController.text);

    return _listBuilder(futureData, 1);
  }

  FutureBuilder _invMarketGroupList(BuildContext context) {
    DbModel dbConn = Provider.of<DbModel>(context);
    Future<List> futureData = dbConn.readInvMarketGroups(parentGroupID: _itemNavigationPath.last["marketGroupID"]);

    return _listBuilder(futureData, 0);
  }

  FutureBuilder _invTypesList(BuildContext context) {
    DbModel dbConn = Provider.of<DbModel>(context);
    Future<List> futureData = dbConn.readInvTypesGroup(_itemNavigationPath.last["marketGroupID"].toString());

    return _listBuilder(futureData, 1);
  }

  FutureBuilder _listBuilder(Future<List> futureCallback, int listType) {
    return FutureBuilder(
        future: futureCallback,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          Widget body;

          if (snapshot.connectionState == ConnectionState.waiting) {
            body = centeredCircularProgressIndicator();
            return body;
          }

          if (snapshot.hasData) {
            body = ScrollConfiguration(
              behavior: const ScrollBehavior(),
              child: ListView.builder(
                physics: const ClampingScrollPhysics(),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  Image icon;
                  Text title;
                  Function onTapCallback;

                  //listType 0 = invMarketGroup | 1 = invTypes | ? = error
                  switch(listType) {
                    case 0:
                      icon = fetchMarketGroupIcon(snapshot.data[index]["iconID"] ?? 0);
                      title = Text(snapshot.data[index]["marketGroupName"]);
                      onTapCallback = () {_addPath(snapshot.data[index]);};
                    case 1:
                      icon = fetchInvTypeIcon(snapshot.data[index]["typeID"] ?? 0);
                      title = Text(snapshot.data[index]["typeName"]);
                      onTapCallback = () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const DetailedItemViewPage(),
                          ),
                        );
                      };
                    default:
                      throw const FormatException('Unsupported listType');
                  }

                  return ListTile(
                    dense: true,
                    visualDensity: const VisualDensity(vertical: 4),
                    onTap: (){onTapCallback();},
                    leading: SizedBox(
                      width: 64,
                      height: 64,
                      child: icon,
                    ),
                    title: title,
                  );
                },
              ),
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

  void _startSearchDelayTimer() {
    _searchDelayTimer = Timer(Duration(milliseconds: _delayDuration), () {
      setState(() {});
    });
  }

  void _resetSearchDelayTimer() {
    _searchDelayTimer?.cancel();
    _startSearchDelayTimer();
  }
}