import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/foundation.dart';

class DeveloperSeries {
  final String year;
  final int money;
  final String? procent;
  final charts.Color barColor;

  DeveloperSeries({
    required this.year,
    required this.money,
    this.procent,
    required this.barColor
  });
}