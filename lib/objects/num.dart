import 'package:flutter/material.dart';

extension DoubleExt on double {
  (double?, double?) toWidthHeightPairAccrToAxis(Axis axis, [double? other]) {
    if (axis == Axis.horizontal) return (this, other);
    return (other, this);
  }
}
