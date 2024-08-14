import 'package:flutter/material.dart';

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
          title: Text("Test"),
          trailing: Icon(Icons.arrow_right),
        ),
        ListTile(
          leading: SizedBox(
            width: 64,
            height: 64,
            child: Placeholder(),
          ),
          title: Text("Test2"),
          trailing: Icon(Icons.arrow_right),
        ),
      ],
    );
  }
}