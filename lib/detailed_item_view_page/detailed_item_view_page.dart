import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DetailedItemViewPage extends StatefulWidget {
  const DetailedItemViewPage({super.key});

  @override
  State<DetailedItemViewPage> createState() => _DetailedItemViewPageState();
}

class _DetailedItemViewPageState extends State<DetailedItemViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)
        ),
        title: Text(AppLocalizations.of(context)!.itemBrowserPageTitle),
        actions: [
          IconButton(
              onPressed: (){
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
              icon: const Icon(Icons.home)
          ),
        ],
      ),
    );
  }
}