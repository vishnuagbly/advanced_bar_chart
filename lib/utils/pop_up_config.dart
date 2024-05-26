import 'package:bubble_pop_up/bubble_pop_up.dart';
import 'package:flutter/material.dart';
import 'package:num_pair/extensions.dart';
import 'package:advanced_bar_chart/extensions/bar_direction.dart';

import '../objects/bar_direction.dart';

abstract class BarPopUpConfigUtils {
  static BubblePopUpConfig genBaseConfig(Direction direction) {
    return BubblePopUpConfig(
      arrowDirection:
          (direction.y == -1) ? ArrowDirection.down : ArrowDirection.up,
      popUpAnchor: (direction == Direction.up)
          ? Alignment.bottomCenter
          : Alignment.topCenter,
      baseAnchor: _genBaseAnchor(direction),
    );
  }

  static Alignment _genBaseAnchor(Direction dir) {
    /* This basically is also the center value of the respective direction's
    side. */
    var res = dir.np;

    /* In case of horizontal bar chart, we want the base anchor to be at the
    bottom corner of the respective side. */
    if (res.y == 0) res += (0, 1).np;

    return res.toAlignment;
  }
}
