import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../model/database/dbmodel.dart';

class ItemBrowserPage extends StatefulWidget {
  const ItemBrowserPage({super.key});

  @override
  State<ItemBrowserPage> createState() => _ItemBrowserPageState();
}

class _ItemBrowserPageState extends State<ItemBrowserPage> {
  @override
  Widget build(BuildContext context) {
    DbModel dbConn = Provider.of<DbModel>(context);

    return FutureBuilder(
      future: dbConn.readInvMarketGroups(parentGroupID: "NULL"),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        Widget body = Column();

        if (snapshot.hasData) {
          body = ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
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

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: (){},
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
    );
  }
}