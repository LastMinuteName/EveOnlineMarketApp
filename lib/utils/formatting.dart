import 'package:intl/intl.dart';

String toCommaSeparated(num value) {
  final numberFormatter = value is int ? NumberFormat("#,##0", "en_US") : NumberFormat("#,##0.00", "en_US");

  return numberFormatter.format(value);
}