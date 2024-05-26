import 'package:flutter/material.dart';

class FlexConfig {
  final AxisConfig main, cross;

  const FlexConfig({required this.main, required this.cross});
}

class AxisConfig {
  final Axis axis;
  final VerticalDirection verticalDirection;
  final TextDirection textDirection;

  const AxisConfig({
    required this.axis,
    required this.verticalDirection,
    required this.textDirection,
  });
}
