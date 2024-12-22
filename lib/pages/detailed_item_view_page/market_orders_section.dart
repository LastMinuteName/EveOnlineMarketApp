import 'package:eve_online_market_application/model/controller/shared_preferences_controller.dart';
import 'package:eve_online_market_application/pages/detailed_item_view_page/orders_filter_dialog.dart';
import 'package:eve_online_market_application/utils/formatting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../app_themes.dart';
import '../../model/entity/market_order.dart';
import 'detailed_order_modal.dart';

class MarketOrdersSection extends StatefulWidget {
  const MarketOrdersSection({super.key, required this.marketOrdersFuture});
  final Future marketOrdersFuture;

  @override
  State<MarketOrdersSection> createState() => _MarketOrdersSectionState();
}

class _MarketOrdersSectionState extends State<MarketOrdersSection> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Set<int>? _ordersFilter;

  @override
  initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? appLocalizations = AppLocalizations.of(context);
    SharedPreferencesController prefController = Provider.of<SharedPreferencesController>(context);
    _ordersFilter = _ordersFilter ?? prefController.getOrdersFilter() ?? {};

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              appLocalizations!.ordersLabel,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return OrdersFilterDialog(
                      selectedFilters: _ordersFilter!,
                      callback: (Set<int> ordersFilter) {
                        setState(() {
                          _ordersFilter = ordersFilter;
                        });
                      },
                    );
                  }
                );
              },
              child: Text("Filter"),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _orderSection(
          selectedFilters: _ordersFilter!,
        ),
      ],
    );
  }

  Widget _orderSection({required Set<int> selectedFilters}) {
    AppLocalizations? appLocalizations = AppLocalizations.of(context);

    return FutureBuilder(
      future: widget.marketOrdersFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        List<Order> sellOrders = [];
        List<Order> buyOrders = [];

        if (snapshot.hasData) {
          snapshot.data.orders.forEach((Order order) {
            if (_ordersFilter!.contains(order.regionID) || _ordersFilter!.isEmpty) {
              order.isBuyOrder ? buyOrders.add(order) : sellOrders.add(order);
            }
          });

          /// sort sell orders by price from lowest to highest
          sellOrders.sort((a, b) => a.price.compareTo(b.price));

          /// sort buy orders by price from highest to lowest
          buyOrders.sort((a, b) => b.price.compareTo(a.price));
        }

        return Column(
          children: [
            TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: appLocalizations!.labelSell),
                Tab(text: appLocalizations!.labelBuy),
              ],
            ),
            Card.filled(
              color: Colors.transparent,
              margin: EdgeInsets.zero,
              child: SizedBox(
                width: double.maxFinite,
                height: MediaQuery.of(context).size.height * 0.5,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    sellOrders.isEmpty ?
                      Container(
                        width: double.maxFinite,
                        alignment: Alignment.center,
                        child: Text(
                          appLocalizations.noSellOrders
                        )
                      ) :
                      _buildOrders(sellOrders, snapshot.data),
                    buyOrders.isEmpty ?
                      Container(
                        width: double.maxFinite,
                        alignment: Alignment.center,
                        child: Text(
                          appLocalizations.noBuyOrders
                        )
                      ) :
                      _buildOrders(buyOrders, snapshot.data),
                  ]
                ),
              ),
            )
          ]
        );
      }
    );
  }

  Widget _buildOrders(List<Order> orders, MarketOrders marketOrders) {
    CustomTheme? customTheme = Theme.of(context).extension<CustomTheme>();
    AppLocalizations? appLocalizations = AppLocalizations.of(context);

    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (BuildContext context, int index) {
        String? structureName;
        structureName = marketOrders.stationNames[orders[index].locationID.toString()] ?? structureName;
        structureName = marketOrders.structureNames[orders[index].locationID.toString()] ?? structureName;
        structureName ?? appLocalizations!.unknownStructure;

        String secStatus = marketOrders.systems[orders[index].systemID.toString()]!.security.toStringAsFixed(1);

        String remaining = "${appLocalizations!.remainingLabel}\n${toCommaSeparated(orders[index].volumeRemain)}";
        String price = "${toCommaSeparated(orders[index].price)} ${appLocalizations!.isk}";

        return ListTile(
          title: Text(price),
          subtitle: Text.rich(
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
          trailing: Text(remaining),
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return detailedOrderModal(orders[index], structureName!, secStatus, context);
              }
            );
          },
        );
      },
    );
  }

  @override
  dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
