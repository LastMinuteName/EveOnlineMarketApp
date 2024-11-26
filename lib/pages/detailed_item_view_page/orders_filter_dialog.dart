import 'dart:async';

import 'package:eve_online_market_application/constants/enums/eve_regions_market.dart';
import 'package:eve_online_market_application/model/entity/map_region.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/controller/shared_preferences_controller.dart';
import '../../model/database/dbmodel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

typedef SetOrderFilter = Function(Set<int> orderFilter);

class OrdersFilterDialog extends StatefulWidget {
  final Set<int> selectedFilters;
  final SetOrderFilter callback;

  const OrdersFilterDialog({super.key, required this.selectedFilters, required this.callback});

  @override
  State<OrdersFilterDialog> createState() => _OrdersFilterDialogState();
}

class _OrdersFilterDialogState extends State<OrdersFilterDialog> {
  late Set<int> _selectedFilters;
  late final TextEditingController _textEditingController = TextEditingController();
  Timer? _searchDelayTimer;
  final int _delayDuration = 300;

  @override
  void initState() {
    _selectedFilters = widget.selectedFilters;
    super.initState();
  }

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
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: FutureBuilder(
          future: dbModel.readMapRegionsFromString(_textEditingController.text),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                      const SizedBox(height: 8.0),
                      ListTile(
                        title: TextField(
                          controller: _textEditingController,
                          decoration: InputDecoration.collapsed(
                              hintText: AppLocalizations.of(context)!.itemBrowserPageSearchHint
                          ),
                          onChanged: (String value) {
                            _resetSearchDelayTimer();
                          },
                        ),
                        trailing: IconButton(
                            onPressed: () {
                              _textEditingController.clear();
                              setState(() {});
                            },
                            icon: const Icon(Icons.close)
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: ListView.builder(
                          itemCount: mapRegions.length,
                          itemBuilder: (BuildContext context, int index) {
                            MapRegion region = mapRegions.values.elementAt(index);

                            return Card.filled(
                              color: Colors.transparent,
                              margin: EdgeInsets.zero,
                              child: CheckboxListTile(
                                value: _selectedFilters.contains(region.regionID),
                                onChanged: (bool? value) {
                                  setState(() {
                                    _selectedFilters.contains(region.regionID) ?
                                      _selectedFilters.remove(region.regionID) :
                                      _selectedFilters.add(region.regionID);
                                  });
                                },
                                controlAffinity: ListTileControlAffinity.leading,
                                title: Text(mapRegions.values.elementAt(index).regionName),
                              ),
                            );
                          }
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      SizedBox(
                        width: double.infinity,
                        child: Wrap(
                          alignment: WrapAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                widget.callback(_selectedFilters);
                                prefController.setOrdersFilter(_selectedFilters);
                                Navigator.pop(context);
                              },
                              child: Text(appLocalizations.setAsDefaultButtonText),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _selectedFilters.clear();
                                });
                              },
                              child: Text(appLocalizations.clearButton),
                            ),
                            ElevatedButton(
                              onPressed: (){
                                widget.callback(_selectedFilters);
                                Navigator.pop(context);
                              },
                              child: Text(appLocalizations.saveButtonText),
                            ),
                          ],
                        ),
                      )
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
      ),
    );
  }

  void _startSearchDelayTimer() {
    _searchDelayTimer = Timer(Duration(milliseconds: _delayDuration), () {
      setState(() {});
    });
  }

  void _resetSearchDelayTimer() {
    _searchDelayTimer?.cancel();
    _startSearchDelayTimer();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _searchDelayTimer?.cancel();
    super.dispose();
  }
}