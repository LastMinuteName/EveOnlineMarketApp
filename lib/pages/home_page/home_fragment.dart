import 'package:eve_online_market_application/widgets/inv_type_stat_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/database/dbmodel.dart';
import '../../model/entity/watchlist.dart';

class HomeFragment extends StatefulWidget{
  const HomeFragment({super.key});

  @override
  State<HomeFragment> createState() => _MyHomeFragmentState();
}

class _MyHomeFragmentState extends State<HomeFragment>{
  @override
  Widget build(BuildContext context) {
    DbModel dbModel = Provider.of<DbModel>(context);

    return FutureBuilder(
      future: dbModel.readWatchlistCategory("Default"),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        List<Watchlist> watchlist = snapshot.data;

        return GridView.count(
          crossAxisCount: 2,
          children: List.generate(watchlist.length, (index) {
            return InvTypeStatCard(typeID: watchlist[index].typeID);
          }),
        );
      }
    );
  }
}