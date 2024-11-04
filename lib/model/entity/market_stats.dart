class MarketStats {
  final int buyVolume;
  final int sellVolume;
  final int buyOrders;
  final int sellOrders;
  final int buyOutliers;
  final int sellOutliers;
  final double buyThreshold;
  final double sellThreshold;
  final double buyAvgFivePercent;
  final double sellAvgFivePercent;
  final double maxBuy;
  final double minSell;

  const MarketStats ({
    required this.buyVolume,
    required this.sellVolume,
    required this.buyOrders,
    required this.sellOrders,
    required this.buyOutliers,
    required this.sellOutliers,
    required this.buyThreshold,
    required this.sellThreshold,
    required this.buyAvgFivePercent,
    required this.sellAvgFivePercent,
    required this.maxBuy,
    required this.minSell,
  });

  factory MarketStats.fromJson(Map<String, dynamic> json) {
    return switch(json) {
      {
        'buyVolume': int buyVolume,
        'sellVolume': int sellVolume,
        'buyOrders': int buyOrders,
        'sellOrders': int sellOrders,
        'buyOutliers': int buyOutliers,
        'sellOutliers': int sellOutliers,
        'buyThreshold': double buyThreshold,
        'sellThreshold': double sellThreshold,
        'buyAvgFivePercent': double buyAvgFivePercent,
        'sellAvgFivePercent': double sellAvgFivePercent,
        'maxBuy': double maxBuy,
        'minSell': double minSell,
      } =>
        MarketStats(
          buyVolume: buyVolume,
          sellVolume: sellVolume,
          buyOrders: buyOrders,
          sellOrders: sellOrders,
          buyOutliers: buyOutliers,
          sellOutliers: sellOutliers,
          buyThreshold: buyThreshold,
          sellThreshold: sellThreshold,
          buyAvgFivePercent: buyAvgFivePercent,
          sellAvgFivePercent: sellAvgFivePercent,
          maxBuy: maxBuy,
          minSell: minSell,
        ),
      _ => throw const FormatException('Failed to load market stats.'),
    };
  }

  @override
  String toString() {
    return "{ buyVolume: $buyVolume, sellVolume: $sellVolume, buyOrders: $buyOrders, sellOrders: $sellOrders, buyOutliers: $buyOutliers, sellOutliers: $sellOutliers, buyThreshold: $buyThreshold, sellThreshold: $sellThreshold, buyAvgFivePercent: $buyAvgFivePercent, sellAvgFivePercent: $sellAvgFivePercent, maxBuy: $maxBuy, minSell: $minSell, }";
  }
}