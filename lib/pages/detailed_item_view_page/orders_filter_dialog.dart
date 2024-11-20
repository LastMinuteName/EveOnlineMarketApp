import 'package:eve_online_market_application/model/entity/map_region.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/controller/shared_preferences_controller.dart';
import '../../model/database/dbmodel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrdersFilterDialog extends StatefulWidget {
  const OrdersFilterDialog({super.key});

  @override
  State<OrdersFilterDialog> createState() => _OrdersFilterDialogState();
}

class _OrdersFilterDialogState extends State<OrdersFilterDialog> {
  @override
  Widget build(BuildContext context) {
    /// 1. have detailed item view page check to see if order filters data exists in sharedpreferences
    /// 2. if contains data then create a map with the selected regions as a key entry in the map, else create empty map
    /// 3. query database for all regions and use the returned map to generate the checkboxlisttiles
    /// 4. when generating checkboxlisttiles compare the regions map to the selected regions to determine which checkboxes are checked
    /// 5. checkboxlisttile onchanged callback should update the selected regions map in app memory and checkbox values should change to reflect that
    /// 6a. if user saves the changes, use callback function provided by caller to setstate and update their local selected regions in memory then pop navigator
    /// 6b. if user sets as default with changes, write to sharedPreferences for future use and then perform 6a
    DbModel dbModel = Provider.of<DbModel>(context);
    AppLocalizations? appLocalizations = AppLocalizations.of(context);
    SharedPreferencesController prefController = Provider.of<SharedPreferencesController>(context);

    return Dialog(
      child: FutureBuilder(
        future: dbModel.readMapRegions(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          Set<int> selectedFilters = prefController.getOrdersFilter();

          if (snapshot.hasData) {
            Map<int, MapRegion> mapRegions = snapshot.data;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      appLocalizations!.selectRegionTitle,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: ListView.builder(
                        itemCount: mapRegions.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CheckboxListTile(
                            value: selectedFilters.contains(mapRegions.values.elementAt(index).regionID),
                            onChanged: (bool? value) {  },
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text(mapRegions.values.elementAt(index).regionName),
                          );
                        }
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          else {
            return const Center(child: CircularProgressIndicator());
          }
        }
      ),
    );
  }
}
