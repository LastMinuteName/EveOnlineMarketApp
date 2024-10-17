import 'package:eve_online_market_application/pages/item_browser_page/item_browser_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MarketFragment extends StatefulWidget{
  const MarketFragment({super.key});

  @override
  State<MarketFragment> createState() => _MyMarketFragmentState();
}

class _MyMarketFragmentState extends State<MarketFragment>{
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: SizedBox(
            width: 64,
            height: 64,
            child: Placeholder(),
          ),
          title: Text(AppLocalizations.of(context)!.itemBrowserPageTitle),
          trailing: Icon(Icons.arrow_right),
          onTap: (){
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ItemBrowserPage(),
              ),
            );
          },
        ),
      ],
    );
  }
}