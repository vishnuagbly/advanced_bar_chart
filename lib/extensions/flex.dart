import 'package:flutter/material.dart';
import 'package:advanced_bar_chart/engine.dart';
import 'package:advanced_bar_chart/objects/axis_config.dart';

extension FlexExt on Flex {
  Flex copyWith({
    Key? key,
    Axis? direction,
    MainAxisAlignment? mainAxisAlignment,
    MainAxisSize? mainAxisSize,
    CrossAxisAlignment? crossAxisAlignment,
    TextDirection? textDirection,
    VerticalDirection? verticalDirection,
    TextBaseline? textBaseline,
    Clip? clipBehavior,
    List<Widget>? children,
  }) =>
      Flex(
        key: key ?? this.key,
        direction: direction ?? this.direction,
        mainAxisAlignment: mainAxisAlignment ?? this.mainAxisAlignment,
        mainAxisSize: mainAxisSize ?? this.mainAxisSize,
        crossAxisAlignment: crossAxisAlignment ?? this.crossAxisAlignment,
        textDirection: textDirection ?? this.textDirection,
        verticalDirection: verticalDirection ?? this.verticalDirection,
        textBaseline: textBaseline ?? this.textBaseline,
        clipBehavior: clipBehavior ?? this.clipBehavior,
        children: children ?? this.children,
      );

  Flex applyAxisConfig(AxisConfig config) => copyWith(
        direction: config.axis,
        verticalDirection: config.verticalDirection,
        textDirection: config.textDirection,
      );

  ///This will change the direction of the [Flex] according to the direction
  ///specified in the engine. Here we assume, whenever we are talking about
  ///Axis.horizontal, i.e [Row], we meant the main axis and vice versa.
  Flex fixDir(BarChartEngine engine) {
    return (direction == Axis.horizontal)
        ? applyAxisConfig(engine.flex.main)
        : applyAxisConfig(engine.flex.cross);
  }
}
