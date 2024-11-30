import 'package:flutter/material.dart';
import '../app_themes.dart';

class MarketStat extends StatelessWidget {
  String label;
  double? percentageChange;
  String? price;

  MarketStat({
    super.key,
    required this.label,
    this.price,
    this.percentageChange,
  });

  @override
  Widget build(BuildContext context) {
    CustomTheme? customTheme = Theme.of(context).extension<CustomTheme>();

    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        if(price != null && percentageChange!= null) Text.rich(
            TextSpan(
                style: TextStyle(
                    color: percentageChange! > 0 ?
                    Theme.of(context).extension<CustomTheme>()?.valueIncrease :
                    Theme.of(context).extension<CustomTheme>()?.valueDecrease
                ),
                children: [
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: percentageChange! > 0 ?
                    Icon(
                      Icons.arrow_upward,
                      color: customTheme?.valueIncrease,
                    ) :
                    Icon(
                      Icons.arrow_downward,
                      color: customTheme?.valueDecrease,
                    ),
                  ),
                  TextSpan(text: "${percentageChange!.toStringAsFixed(2)}%"),
                ]
            )
        ),
        price == null ? const CircularProgressIndicator() : Text(price!),
      ],
    );
  }
}
