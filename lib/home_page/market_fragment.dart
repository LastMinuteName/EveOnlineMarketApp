import 'package:flutter/material.dart';

class MarketFragment extends StatefulWidget{
  const MarketFragment({super.key});

  @override
  State<MarketFragment> createState() => _MyMarketFragmentState();
}

class _MyMarketFragmentState extends State<MarketFragment>{
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Market"),
    );
  }
}