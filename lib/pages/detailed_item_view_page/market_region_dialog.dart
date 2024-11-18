import 'package:eve_online_market_application/model/controller/shared_preferences_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/enums/eve_regions_market.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

typedef SetRegion = Function(Region selectedRegion);

class MarketRegionDialog extends StatefulWidget {
  final Region? currentRegion;
  final SetRegion callback;
  const MarketRegionDialog({super.key, required this.currentRegion, required this.callback});

  @override
  State<MarketRegionDialog> createState() => _MarketRegionDialogState();
}

class _MarketRegionDialogState extends State<MarketRegionDialog> {
  Region? _selectedRegion;

  @override
  void initState() {
    _selectedRegion = widget.currentRegion;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? appLocalizations = AppLocalizations.of(context);
    SharedPreferencesController _prefController = Provider.of<SharedPreferencesController>(context);

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              appLocalizations!.selectRegionTitle,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            for (Region region in Region.values)
              ListTile(
                title: Text(region.name),
                leading: Radio<Region>(
                  value: region,
                  groupValue: _selectedRegion,
                  onChanged: (Region? value) {
                    setState(() {
                      _selectedRegion = value;
                    });
                  },
                ),
                onTap: () {
                  setState(() {
                    _selectedRegion = region;
                  });
                },
              ),
            SizedBox(
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      widget.callback(_selectedRegion!);
                      _prefController.setMarketRegion(_selectedRegion!);
                      Navigator.pop(context);
                    },
                    child: Text("Set As Default"),
                  ),
                  ElevatedButton(
                    onPressed: (){
                      widget.callback(_selectedRegion!);
                      Navigator.pop(context);
                    },
                    child: Text("Save"),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}