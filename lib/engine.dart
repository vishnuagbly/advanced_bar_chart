import 'dart:math' as math;

import 'package:advanced_bar_chart/bar_chart.dart';
import 'package:advanced_bar_chart/extensions/bar_direction.dart';
import 'package:advanced_bar_chart/extensions/list.dart';
import 'package:advanced_bar_chart/extensions/num_pair.dart';
import 'package:advanced_bar_chart/objects/axis_config.dart';
import 'package:advanced_bar_chart/objects/extra.dart';
import 'package:advanced_bar_chart/utils/pop_up_config.dart';
import 'package:bubble_pop_up/bubble_pop_up.dart';
import 'package:flutter/material.dart';
import 'package:num_pair/extensions.dart';
import 'package:num_pair/num_pair.dart';

import 'objects/bar.dart';
import 'objects/bar_direction.dart';
import 'objects/configs.dart';
import 'objects/group.dart';

class BarChartEngine {
  //Keys
  final List<GlobalKey> groupLabelKeys;

  //Groups and Bars
  late List<FGroup> groups;
  late FBar emptyBar;
  final FGroup emptyGroup;
  final double interGroupSpace;

  late final bool isEmpty;
  final updateFrame = ValueNotifier<bool>(false);
  final List<Size> _groupLabelSizes;
  final NumPair directionNp;
  final Direction direction;
  final FlexConfig flex;
  final BubblePopUpConfig basePopUpConfig;

  ///This is the maximum space between one end of the chart and the base of the
  ///bars, due to the groups' labels between them.
  double? _groupLabelMaxSpace;
  bool _gotAllGroupLabelSizes = false;
  RenderBox? _axisBox;

  static const kDefaultVerticalDirection = VerticalDirection.down;
  static const kDefaultTextDirection = TextDirection.ltr;

  BarChartEngine(BarChart chart)
      : emptyGroup = chart.emptyGroup,
        interGroupSpace = chart.interGroupSpace,
        direction = chart.direction,
        directionNp = chart.direction.np,
        basePopUpConfig = BarPopUpConfigUtils.genBaseConfig(chart.direction),
        flex = FlexConfig(
          main: AxisConfig(
            axis: chart.direction.toAxis,
            verticalDirection: chart.direction.toVerticalDirection,
            textDirection: chart.direction.toTextDirection,
          ),
          cross: AxisConfig(
            axis: chart.direction.flip.toAxis,
            verticalDirection: kDefaultVerticalDirection,
            textDirection: kDefaultTextDirection,
          ),
        ),
        _groupLabelSizes = List.generate(chart.maxGroups, (i) => Size.zero),
        groupLabelKeys = List.generate(chart.maxGroups, (i) => GlobalKey()) {
    _updateGroups(chart);
    isEmpty = groups.every((group) => isGroupEmpty(group));
  }

  void _updateGroups(BarChart chart) {
    groups = _createFGroups(chart);
    _updatePopUpConfigs(chart);
  }

  static _createFGroups(BarChart chart) =>
      chart.groups.map((grp) => FGroup.from(grp, chart.defaultConfig)).toList();

  void _updatePopUpConfigs(BarChart chart) {
    FBar updateBar(FBar bar) => bar.copyWith(
          config: bar.config.copyWith(BarConfig(
            popUpConfig: bar.config.popUpConfig ??
                basePopUpConfig.copyWith(
                  childBorderRadius: bar.config.popUpBorderRadius,
                ),
          )),
        );

    for (int i = 0; i < groups.length; i++) {
      for (int j = 0; j < groups[i].bars.length; j++) {
        groups[i].bars[j] = updateBar(groups[i].bars[j]);
      }
    }
    emptyBar = updateBar(chart.emptyBar);
  }

  void didUpdateWidget(BarChart chart) {
    _updateGroups(chart);
    for (int i = 0; i < chart.maxGroups; i++) {
      if (groupLabelKeys.length <= i) groupLabelKeys.add(GlobalKey());
      if (_groupLabelSizes.length <= i) _groupLabelSizes.add(Size.zero);
    }
  }

  double? get groupLabelMaxSpace => _groupLabelMaxSpace;

  set groupLabelMaxSpace(double? value) {
    if (value != groupLabelMaxSpace) updateFrame.value = true;
    _groupLabelMaxSpace = value;
  }

  bool get gotAllGroupLabelSizes => _gotAllGroupLabelSizes;

  set gotAllGroupLabelSizes(bool value) {
    _gotAllGroupLabelSizes = value;
    if (!value) _getAllGroupLabelSizes();
  }

  set axisBox(RenderBox box) => _axisBox = box;

  /*
    We do not need to show axis in case the chart is empty.
    We are also not going to show axis, unless each group's label's size is
     calculated.
   */
  bool get showAxis => _isGroupLabelSizeCalculated && !isEmpty;

  bool get _isGroupLabelSizeCalculated => groupLabelMaxSpace != null;

  bool get maxCrossLengthCalculable =>
      gotAllGroupLabelSizes && (isAxisBoxInferred || isEmpty);

  bool get isAxisBoxInferred => _axisBox != null;

  FGroup _getOnlyGroup(int i) => groups.get(i) ?? emptyGroup;

  (FGroup, AdditionalGroupConfigs) getGroup(int i) {
    final group = _getOnlyGroup(i);
    final additionalConfigs = AdditionalGroupConfigs(
      isEmpty: isGroupEmpty(group),
      correctedSpace: (groupLabelMaxSpace != null)
          ? (groupLabelMaxSpace! - _groupLabelSizes[i].getDim(directionNp))
          : 0.0,
    );
    return (group, additionalConfigs);
  }

  (FGroup, FBar) getGroupBar(int i, int j) {
    final group = _getOnlyGroup(i);
    return (group, group[j] ?? emptyBar);
  }

  bool isBarEmpty(FBar bar) => bar.value == emptyBar.value;

  bool isGroupEmpty(FGroup group) => group.bars.every((bar) => isBarEmpty(bar));

  void build() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calcGroupLabelMaxSpace();
    });
  }

  void _calcGroupLabelMaxSpace() {
    if (!_getAllGroupLabelSizes()) {
      return _calcGroupLabelMaxSpace();
    }

    double res = 0;
    for (int i = 0; i < groups.length; i++) {
      res = math.max(res, _groupLabelSizes[i].getDim(directionNp));
    }

    groupLabelMaxSpace = res;
  }

  ///Returns true if successfully retrieved all group label sizes.
  bool _getAllGroupLabelSizes() {
    if (gotAllGroupLabelSizes) return true;

    for (int i = 0; i < groups.length; i++) {
      final box =
          groupLabelKeys[i].currentContext?.findRenderObject() as RenderBox?;

      if (box == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _getAllGroupLabelSizes();
        });
        return false;
      }

      if (box.size != _groupLabelSizes[i]) {
        _groupLabelSizes[i] = box.size;
      }
    }

    gotAllGroupLabelSizes = true;
    return true;
  }

  ///This will calculate the maximum length of cross axis of bars.
  double get calcMaxCrossLength {
    var res = 0.0;
    for (int i = 0; i < groups.length; i++) {
      final group = groups[i];
      var groupCrossLength = 0.0;
      for (int j = 0; j < group.bars.length; j++) {
        final bar = group.bars[j];
        if (isBarEmpty(bar)) continue;

        groupCrossLength += bar.config.width;
      }
      groupCrossLength += group.bars.length * group.config.interBarSpace;
      groupCrossLength = math.max(
        _groupLabelSizes[i].getDim(directionNp.flip()),
        groupCrossLength,
      );
      res += groupCrossLength;
    }
    res += (groups.length - 1) * interGroupSpace;
    res += _axisBox?.size.getDim(directionNp.flip()) ?? 0;
    return res;
  }
}

extension on Size {
  ///Get dimension according to the [Direction] provided, in the form of NumPair.
  double getDim(NumPair direction) => np.dotSum(direction.abs()).toDouble();
}
