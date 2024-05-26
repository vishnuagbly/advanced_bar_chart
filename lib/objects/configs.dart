import 'package:bubble_pop_up/bubble_pop_up.dart';
import 'package:flutter/material.dart';

import 'bar.dart';
import 'group.dart';

///Here [i] and [j] are the indices of group and bar respectively.
typedef PopUpFn = Widget Function(FGroup group, FBar bar, int i, int j);

class BGDefaultConfig {
  final DefaultGroupConfig group;
  final DefaultBarConfig bar;

  const BGDefaultConfig({
    this.group = const DefaultGroupConfig(),
    this.bar = const DefaultBarConfig(),
  });
}

class GroupConfig {
  final double? labelBarSpace;
  final double? interBarSpace;

  ///Parameter provided in this function, is the index of the group.
  final GroupLabelFn? label;

  const GroupConfig({
    this.labelBarSpace,
    this.interBarSpace,
    this.label,
  });

  ///Merges all provided configs, with first nonNull value for each parameter.
  ///
  ///Provide configs in the order of priority.
  GroupConfig.fold(List<GroupConfig> configs)
      : labelBarSpace =
            configs.map((_) => _.labelBarSpace).nonNulls.firstOrNull,
        interBarSpace =
            configs.map((_) => _.interBarSpace).nonNulls.firstOrNull,
        label = configs.map((_) => _.label).nonNulls.firstOrNull;
}

class DefaultGroupConfig {
  final double labelBarSpace;
  final double interBarSpace;
  final GroupLabelFn label;

  const DefaultGroupConfig({
    this.labelBarSpace = 10,
    this.interBarSpace = 5,
    this.label = kDefaultLabel,
  });

  static Widget kDefaultLabel(int index) => Text('$index');

  DefaultGroupConfig copyWith(GroupConfig config) => DefaultGroupConfig(
        labelBarSpace: config.labelBarSpace ?? labelBarSpace,
        interBarSpace: config.interBarSpace ?? interBarSpace,
        label: config.label ?? label,
      );
}

class BarConfig {
  final double? width;
  final Color? color;
  final Color? bgColor;
  final Color? popUpColor;
  final PopUpFn? popUpFn;
  final BorderRadius? popUpBorderRadius;
  final BorderRadiusGeometry? border;
  final BorderRadiusGeometry? bgBorder;

  ///Sets the various configuration for the Bubble Pop Up we are using.
  ///We recommend to play around with the configurations, to better get the
  ///idea.
  final BubblePopUpConfig? popUpConfig;

  ///[bgColor] can be used to set the background color of the bar.
  ///
  ///[popUpColor] is the color of the triangle.
  ///
  ///Note: Recommended to ONLY provide [popUpConfig] if want to change
  ///pop-up and base anchor alignments, else, DON'T set it.
  ///
  ///In case both [popUpBorderRadius] and [popUpConfig.childBorderRadius] is
  ///provided, then the later will be used.
  const BarConfig({
    this.width,
    this.color,
    this.bgColor,
    this.popUpColor,
    this.popUpFn,
    this.border,
    this.bgBorder,
    this.popUpBorderRadius,
    this.popUpConfig,
  });

  ///Merges all provided configs, with first nonNull value for each parameter.
  ///
  ///Provide configs in the order of priority.
  BarConfig.fold(List<BarConfig> configs)
      : width = configs.map((_) => _.width).nonNulls.firstOrNull,
        color = configs.map((_) => _.color).nonNulls.firstOrNull,
        bgColor = configs.map((_) => _.bgColor).nonNulls.firstOrNull,
        popUpColor = configs.map((_) => _.popUpColor).nonNulls.firstOrNull,
        popUpFn = configs.map((_) => _.popUpFn).nonNulls.firstOrNull,
        border = configs.map((_) => _.border).nonNulls.firstOrNull,
        bgBorder = configs.map((_) => _.bgBorder).nonNulls.firstOrNull,
        popUpConfig = configs.map((_) => _.popUpConfig).nonNulls.firstOrNull,
        popUpBorderRadius =
            configs.map((_) => _.popUpBorderRadius).nonNulls.firstOrNull;
}

class DefaultBarConfig {
  final double width;
  final Color color;
  final Color bgColor;
  final Color popUpColor;
  final PopUpFn popUp;
  final BorderRadius popUpBorderRadius;
  final BorderRadiusGeometry border;
  final BorderRadiusGeometry bgBorder;

  ///Sets the various configuration for the Bubble Pop Up we are using.
  ///We recommend to play around with the configurations, to better get the
  ///idea.
  final BubblePopUpConfig? popUpConfig;

  ///Note: Recommended to ONLY provide [popUpConfig] if want to change
  ///pop-up and base anchor alignments, else, DON'T set it.
  ///
  ///In case both [popUpBorderRadius] and [popUpConfig.childBorderRadius] is
  ///provided, then the later will be used.
  const DefaultBarConfig({
    this.width = 10,
    this.color = Colors.green,
    this.bgColor = Colors.red,
    this.popUpColor = kDefaultPopUpColor,
    this.popUp = kDefaultPopUpFn,
    this.border = kCircularBorder,
    this.bgBorder = kCircularBorder,
    this.popUpBorderRadius = BorderRadius.zero,
    this.popUpConfig,
  });

  static const Color kDefaultPopUpColor = Colors.red;
  static const BorderRadiusGeometry kCircularBorder =
      BorderRadius.all(Radius.circular(1e+5));

  static Widget kDefaultPopUpFn(FGroup grp, FBar bar, int i, int j) =>
      Container(
        color: kDefaultPopUpColor,
        width: 200,
        height: 50,
        child: Center(
          child: Text('${bar.value}'),
        ),
      );

  DefaultBarConfig copyWith(BarConfig config) => DefaultBarConfig(
        width: config.width ?? width,
        color: config.color ?? color,
        bgColor: config.bgColor ?? bgColor,
        popUpColor: config.popUpColor ?? popUpColor,
        popUp: config.popUpFn ?? popUp,
        border: config.border ?? border,
        bgBorder: config.bgBorder ?? bgBorder,
        popUpBorderRadius: config.popUpBorderRadius ?? popUpBorderRadius,
        popUpConfig: config.popUpConfig ?? popUpConfig,
      );
}
