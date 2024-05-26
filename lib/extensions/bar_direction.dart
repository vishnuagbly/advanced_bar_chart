import 'package:flutter/material.dart';
import 'package:num_pair/num_pair.dart';

import '../objects/bar_direction.dart';
import 'num_pair.dart';

extension BarDirectionExt on Direction {
  NumPair get np => NumPair(x, y);

  Direction get flip => Direction(y, x);

  Axis get toAxis => [Axis.horizontal, Axis.vertical][np.abs().maxIndex];

  VerticalDirection get toVerticalDirection =>
      y == -1 ? VerticalDirection.up : VerticalDirection.down;

  TextDirection get toTextDirection =>
      x == -1 ? TextDirection.rtl : TextDirection.ltr;
}
