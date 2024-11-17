import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_themes.dart';
import '../../model/database/dbmodel.dart';
import '../../model/entity/map_region.dart';
import '../../model/entity/market_order.dart';
import '../../utils/formatting.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget detailedOrderModal(Order order, String structureName, String secStatus, BuildContext context) {
  AppLocalizations? appLocalizations = AppLocalizations.of(context);
  CustomTheme? customTheme = Theme.of(context).extension<CustomTheme>();
  DbModel dbConn = Provider.of<DbModel>(context);

  return Container(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(appLocalizations!.priceLabel),
                    Text(toCommaSeparated(order.price))
                  ],
                )
            ),
            Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(appLocalizations!.minimumVolumeLabel),
                    Text(toCommaSeparated(order.minVolume))
                  ],
                )
            )
          ],
        ),
        Row(
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(appLocalizations!.remainingLabel),
                    Text(toCommaSeparated(order.volumeRemain))
                  ]
              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(appLocalizations!.volumeTotalLabel),
                    Text(toCommaSeparated(order.volumeTotal))
                  ]
              ),
            )
          ],
        ),
        Row(
          children: [
            Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(appLocalizations.locationLabel),
                    Text.rich(
                      TextSpan(
                          children: [
                            TextSpan(
                                text: "$secStatus ",
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: customTheme?.securityStatusColour(double.parse(secStatus)),
                                  fontWeight: FontWeight.bold,
                                )
                            ),
                            TextSpan(text: structureName),
                          ]
                      ),
                    ),
                  ],
                )
            ),
          ],
        ),
        Row(
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(appLocalizations!.regionLabel),
                    FutureBuilder(
                        future: dbConn.readMapRegions(regionID: order.regionID),
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          if(snapshot.hasData) {
                            Map<int, MapRegion> regionMap = snapshot.data;
                            return Text(regionMap[order.regionID]!.regionName);
                          }

                          return const CircularProgressIndicator();
                        }
                    ),
                  ]
              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(appLocalizations!.rangeLabel),
                    Text(order.range)
                  ]
              ),
            )
          ],
        ),
        Row(
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(appLocalizations!.orderCreationTIme),
                    Text(order.issued.toIso8601String())
                  ]
              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(appLocalizations!.timeRemainingLabel),
                    Text(order.duration.toString())
                  ]
              ),
            )
          ],
        ),
      ],
    ),
  );
}