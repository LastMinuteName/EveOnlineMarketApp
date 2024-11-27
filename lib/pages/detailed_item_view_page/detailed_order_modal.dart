import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  DbModel _dbConn = Provider.of<DbModel>(context);

  Duration orderTimeRemaining = order.issued.add(Duration(days: order.duration)).difference(DateTime.now());
  int otrSeconds = orderTimeRemaining.inSeconds % 60;
  int otrMinutes = orderTimeRemaining.inMinutes % 60;
  int otrHours = orderTimeRemaining.inHours % 24;
  int otrDays = orderTimeRemaining.inDays;

  return Container(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              flex: 1,
              child: Text(
                "${appLocalizations!.detailedOrderTitle}${order.orderID}",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              )
            )
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appLocalizations!.priceLabel,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                  Text(
                    appLocalizations!.minimumVolumeLabel,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(toCommaSeparated(order.minVolume))
                ],
              )
            )
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appLocalizations!.remainingLabel,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                  Text(
                    appLocalizations!.volumeTotalLabel,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(toCommaSeparated(order.volumeTotal))
                ]
              ),
            )
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appLocalizations.locationLabel,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
        const SizedBox(height: 8),
        Row(
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appLocalizations!.regionLabel,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    FutureBuilder(
                      future: _dbConn.readMapRegions(regionID: order.regionID),
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
                  Text(
                    appLocalizations!.rangeLabel,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(order.range)
                ]
              ),
            )
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appLocalizations!.orderCreationTIme,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(DateFormat('dd MMM yyyy | HH:mm:ss').format(order.issued))
                ]
              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appLocalizations!.timeRemainingLabel,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text("$otrDays Days ${otrHours.toString().padLeft(2,"0")}:${otrMinutes.toString().padLeft(2,"0")}:${otrSeconds.toString().padLeft(2,"0")}"),
                ]
              ),
            )
          ],
        ),
      ],
    ),
  );
}