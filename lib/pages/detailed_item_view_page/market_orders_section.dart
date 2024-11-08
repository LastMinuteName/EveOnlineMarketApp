import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MarketOrdersSection extends StatelessWidget {
  const MarketOrdersSection({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations? appLocalizations = AppLocalizations.of(context);

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
