import 'package:intl/intl.dart';

String toCommaSeparated(double value) {
  final numberFormatter = NumberFormat("#,##0.00", "en_US");

  return numberFormatter.format(value);
}