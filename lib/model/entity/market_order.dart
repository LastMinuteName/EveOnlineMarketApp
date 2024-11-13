class Order{
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

  const Order({
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

  factory Order.fromJson(Map<String, dynamic> json) {
    return switch(json) {
      {
        'duration': int duration,
        'isBuyOrder': bool isBuyOrder,
        'issued': int issued,
        'locationId': int locationID,
        'minVolume': int minVolume,
        'orderId': int orderID,
        'price': double price,
        'range': String range,
        'systemId': int systemID,
        'regionId': int regionID,
        'typeId': int typeID,
        'volumeRemain': int volumeRemain,
        'volumeTotal': int volumeTotal,
      } =>
        Order(
          duration: duration,
          isBuyOrder: isBuyOrder,
          issued: DateTime.fromMillisecondsSinceEpoch(issued),
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

class System {
  final int solarSystemID;
  final String solarSystemName;
  final double security;

  const System({
    required this.solarSystemID,
    required this.solarSystemName,
    required this.security,
  });

  factory System.fromJson(Map<String, dynamic> json) {
    return switch(json) {
      {
        'solarSystemID': int solarSystemID,
        'solarSystemName': String solarSystemName,
        'security': double security,
      } =>
        System(
          solarSystemID: solarSystemID,
          solarSystemName: solarSystemName,
          security: security,
        ),
      _ => throw const FormatException('Failed to load system.'),
    };
  }

  @override
  String toString() {
    return "{ solarSystemID: $solarSystemID, solarSystemName: $solarSystemName, security: $security }";
  }
}

class MarketOrders {
  final Map<String, System> systems;
  final Map<String, String> stationNames;
  final Map<String, String> structureNames;
  final List<Order> orders;

  const MarketOrders({
    required this.systems,
    required this.stationNames,
    required this.structureNames,
    required this.orders
  });

  factory MarketOrders.fromJson(Map<String, dynamic> json) {
    return switch(json) {
      {
        'itemType': Map<String, dynamic> itemType,
        'producedBy': int producedBy,
        'systems': Map<String, dynamic> systems,
        'stationNames': Map<String, dynamic> stationNames,
        'structureNames': Map<String, dynamic> structureNames,
        'orders': List<dynamic> orders,
      } =>
        MarketOrders(
          systems: () {
            Map<String, System> mappedSystems = {};

            systems.forEach((k,v) => mappedSystems[k] = System.fromJson(v));

            return mappedSystems;
          }(),
          stationNames: stationNames.cast<String, String>(),
          structureNames: structureNames.cast<String, String>(),
          orders: () {
            List<Order> listOrders = [];

            for (Map<String, dynamic> orderObject in orders) {
              listOrders.add(Order.fromJson(orderObject));
            }

            return listOrders;
          }(),
        ),
      /// Added extra pattern match for the case where an itemType is not produced by anything
      /// and will therefore not return a JSON response with the producedBy key
      {
      'itemType': Map<String, dynamic> itemType,
      'systems': Map<String, dynamic> systems,
      'stationNames': Map<String, dynamic> stationNames,
      'structureNames': Map<String, dynamic> structureNames,
      'orders': List<dynamic> orders,
      } =>
        MarketOrders(
          systems: () {
            Map<String, System> mappedSystems = {};

            systems.forEach((k,v) => mappedSystems[k] = System.fromJson(v));

            return mappedSystems;
          }(),
          stationNames: stationNames.cast<String, String>(),
          structureNames: structureNames.cast<String, String>(),
          orders: () {
            List<Order> listOrders = [];

            for (Map<String, dynamic> orderObject in orders) {
              listOrders.add(Order.fromJson(orderObject));
            }

            return listOrders;
          }(),
        ),
      _ => throw const FormatException('Failed to load market orders'),
    };
  }

  @override
  String toString() {
    return "{ systems: $systems, stationNames: $stationNames, structureNames: $structureNames, orders: $orders }";
  }
}