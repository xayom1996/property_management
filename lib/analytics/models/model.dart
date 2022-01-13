import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/foundation.dart';

class DeveloperSeries {
  final String year;
  final int money;
  final charts.Color barColor;

  DeveloperSeries({
    required this.year,
    required this.money,
    required this.barColor
  });
}