import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MarketOrdersSection extends StatefulWidget {
  const MarketOrdersSection({super.key});

  @override
  State<MarketOrdersSection> createState() => _MarketOrdersSectionState();
}

class _MarketOrdersSectionState extends State<MarketOrdersSection> {
  @override
  Widget build(BuildContext context) {
    AppLocalizations? appLocalizations = AppLocalizations.of(context);

    @override
    initState() {

    }

    return Column(
      children: [
        DefaultTabController(
          length: 2,
          child: TabBar(
            tabs: [
              Tab(child: Text(appLocalizations!.labelSell)),
              Tab(child: Text(appLocalizations!.labelBuy)),
            ],
          ),
        ),
      ]
    );
  }
}
