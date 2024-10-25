class MarketOrder{
  final int duration;
  final bool isBuyOrder;
  final DateTime issued;
  final int locationID;
  final int minVolume;
  final int orderID;
  final double price;
  final String range;
  final int systemID;
  final int regionID;
  final int typeID;
  final int volumeRemain;
  final int volumeTotal;

  const MarketOrder({
    required this.duration,
    required this.isBuyOrder,
    required this.issued,
    required this.locationID,
    required this.minVolume,
    required this.orderID,
    required this.price,
    required this.range,
    required this.systemID,
    required this.regionID,
    required this.typeID,
    required this.volumeRemain,
    required this.volumeTotal,
  });

  factory MarketOrder.fromJson(Map<String, dynamic> json, int regionID) {
    return switch(json) {
      {
        'duration': int duration,
        'is_buy_order': bool isBuyOrder,
        'issued': String issued,
        'location_id': int locationID,
        'min_volume': int minVolume,
        'order_id': int orderID,
        'price': double price,
        'range': String range,
        'system_id': int systemID,
        'type_id': int typeID,
        'volume_remain': int volumeRemain,
        'volume_total': int volumeTotal,
      } =>
        MarketOrder(
            duration: duration,
            isBuyOrder: isBuyOrder,
            issued: DateTime.parse(issued),
            locationID: locationID,
            minVolume: minVolume,
            orderID: orderID,
            price: price,
            range: range,
            systemID: systemID,
            regionID: regionID,
            typeID: typeID,
            volumeRemain: volumeRemain,
            volumeTotal: volumeTotal
        ),
      _ => throw const FormatException('Failed to load market order.'),
    };
  }

  @override
  String toString() {
    return "{ duration: $duration, isBuyOrder: $isBuyOrder, issued: $issued, locationID: $locationID, minVolume: $minVolume, orderID: $orderID, price: $price, range: $range, systemID: $systemID, regionID: $regionID, typeID: $typeID, volumeRemain: $volumeRemain, volumeTotal: $volumeTotal }";
  }
}