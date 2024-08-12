import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:eve_online_market_application/home_page/home_fragment.dart';
import 'package:eve_online_market_application/home_page/market_fragment.dart';
import 'package:eve_online_market_application/home_page/more_fragment.dart';

import '../model/dbmodel.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text([
            AppLocalizations.of(context)!.homePageHomeTitle,
            AppLocalizations.of(context)!.homePageMarketTitle,
            AppLocalizations.of(context)!.homePageMoreTitle
          ][currentPageIndex],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: 'Market',
          ),
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: 'More',
          ),
        ],
      ),
      body: [
        HomeFragment(),
        MarketFragment(),
        MoreFragment(),
      ][currentPageIndex],
    );
  }
}