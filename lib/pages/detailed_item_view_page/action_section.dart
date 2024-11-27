import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/database/dbmodel.dart';
import '../../model/entity/watchlist.dart';

class ActionSection extends StatefulWidget {
  final bool watchlisted;
  final int typeID;
  const ActionSection({super.key, required this.typeID, required this.watchlisted});

  @override
  State<ActionSection> createState() => _ActionSectionState();
}

class _ActionSectionState extends State<ActionSection> {
  late bool _watchlisted = widget.watchlisted;

  @override
  Widget build(BuildContext context) {
    DbModel dbConn = Provider.of<DbModel>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          onPressed: () async {
            int result = _watchlisted ?
              await dbConn.deleteWatchlist(Watchlist(typeID: widget.typeID, category: "Default")) :
              await dbConn.insertWatchlist(Watchlist(typeID: widget.typeID));

            if (result != 0) {
              setState(() {
                _watchlisted = !_watchlisted;
              });
            }
          },
          child: Column(
            children: [
              _watchlisted ?
              const Icon(Icons.favorite_outlined) :
              const Icon(Icons.favorite_outline),
              const Text("Watchlist"),
            ],
          ),
        )
      ],
    );
  }
}
