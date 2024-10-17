class MarketHistory {
  final double average;
  final DateTime date;
  final double highest;
  final double lowest;
  final int orderCount;
  final int volume;

  const MarketHistory({
    required this.average,
    required this.date,
    required this.highest,
    required this.lowest,
    required this.orderCount,
    required this.volume
  });

  factory MarketHistory.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'average': double average,
        'date': String date,
        'highest': double highest,
        'lowest': double lowest,
        'order_count': int orderCount,
        'volume': int volume
      } =>
        MarketHistory(
          average: average,
          date: DateTime.parse(date),
          highest: highest,
          lowest: lowest,
          orderCount: orderCount,
          volume: volume
        ),
      _ => throw const FormatException('Failed to load market history.'),
    };
  }

  @override
  String toString() {
    return "{ average: $average, date: $date, highest: $highest, lowest: $lowest, orderCount: $orderCount, volume: $volume }";
  }
}