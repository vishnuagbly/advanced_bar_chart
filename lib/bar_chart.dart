import 'dart:math' as math;

import 'package:bubble_pop_up/bubble_pop_up.dart';
import 'package:flutter/material.dart';
import 'package:num_pair/extensions.dart';

import 'components/uni_direction_space.dart';
import 'engine.dart';
import 'extensions/flex.dart';
import 'extensions/widget.dart';
import 'objects/bar.dart';
import 'objects/bar_direction.dart';
import 'objects/configs.dart';
import 'objects/group.dart';
import 'extensions/num.dart';

typedef AxisLabelFn = Widget Function(double value);

class BarChart extends StatefulWidget {
  ///Creates Animated Horizontal Bar Chart.
  ///
  ///
  ///If [groups] is null, then the value of [totalGroups] and
  ///[totalBarsPerGroup] is used for generating random values for the graph.
  ///
  ///If [groups] is null, then, [totalGroups] and [totalBarsPerGroup] cannot be
  ///null.
  ///
  ///[axisLabel] can be used to define how to generate a widget to be displayed
  ///according to the corresponding value on the axis.
  ///
  ///[emptyBar] is used to define the default [Bar], which will be displayed
  ///before animating to the actual bar. Recommended: Not to Change.
  ///
  ///[emptyGroup] is used to define the default [Group], which will be displayed
  ///before animating to the actual group. Recommended: Not to Change.
  ///
  ///
  ///[maxBarsInGroup] defines the maximum possible bars a group can have. If
  ///null then the value will be calculated as the max bars in a group. This
  ///value is useful if want smooth animations for bars incoming and outgoing.
  ///
  ///[maxGroups] defines the maximum possible groups can be. If null then the
  ///value will be calculated as the length of the [groups] or [totalGroups]
  ///accordingly. This value is useful if want smooth animations for groups
  ///which might have initially no bars or [emptyBar]s, but can change with
  ///time.
  ///
  ///if [expandableBarThickness] is set to true, then [BarConfig.width] will
  ///be ignored.
  ///
  ///Note:- If [maxBarsInGroup] or [maxGroups] is constant for the life-time of
  ///the [BarChart], then it is highly recommended to enter these
  ///values, instead of letting it be null.
  ///
  /// Important:- This Widget should be built inside a constrained width.
  BarChart({
    super.key,
    this.maxValue = 100,
    this.minValue = 0,
    this.defaultConfig = const BGDefaultConfig(),
    int? totalGroups,
    int? totalBarsPerGroup,
    List<Group>? groups,
    this.interGroupSpace = 10,
    AxisLabelFn? axisLabel,
    PopUpFn? defaultPopUp,
    this.axisTotalMiddleLabels = 0,
    Bar? emptyBar,
    Group? emptyGroup,
    int? maxBarsInGroup,
    int? maxGroups,
    this.showMinOnAxis = true,
    this.showMaxOnAxis = true,
    this.direction = Direction.right,
    this.popUpCanOverflow = false,
    this.expandableBarThickness = false,
  })  : assert(
            groups != null ||
                (totalGroups != null && totalBarsPerGroup != null),
            'If [groups] is null, then, [totalGroups] and [totalBarsPerGroup] cannot be null.'),
        assert(axisTotalMiddleLabels >= 0, 'Cannot be negative.'),
        axisLabel = axisLabel ?? ((value) => Text('${value.truncate()}')),
        emptyBar = FBar(
          minValue - 1,
          defaultConfig.bar.copyWith(
            const BarConfig(color: Colors.transparent),
          ),
        ),
        emptyGroup = FGroup(bars: [], config: defaultConfig.group) {
    this.groups = groups ?? _genGroups(totalGroups!, totalBarsPerGroup!);
    this.maxBarsInGroup = maxBarsInGroup ?? _maxBarsInGroup;
    this.maxGroups = maxGroups ?? this.groups.length;
  }

  final Duration duration = const Duration(milliseconds: 500);

  final double maxValue;
  final double minValue;
  final double interGroupSpace;
  final BGDefaultConfig defaultConfig;
  late final List<Group> groups;
  late final int maxBarsInGroup;
  late final int maxGroups;
  final FBar emptyBar;
  final FGroup emptyGroup;

  ///If false, then label corresponding to [minValue] will not be displayed on
  ///the Axis.
  final bool showMinOnAxis;

  ///If false, then label corresponding to [maxValue] will not be displayed on
  ///the Axis.
  final bool showMaxOnAxis;
  final AxisLabelFn axisLabel;

  ///Number of labels beside the [minValue] and [maxValue] to be displayed, i.e,
  ///number of labels to be displayed between the [minValue] and [maxValue].
  final int axisTotalMiddleLabels;

  ///Direction of the bar graph, i.e either up, down, left, right.
  ///for example, in case of right, it means bars will start from left to right.
  final Direction direction;

  ///If set to true, then [PopupScope] will not be used, and pop-ups will be
  ///able to overflow outside of the chart.
  final bool popUpCanOverflow;

  ///If true, each bar's thickness will expand to its maximum capacity.
  final bool expandableBarThickness;

  double get _randValue =>
      (math.Random().nextDouble() * (maxValue - minValue)) + minValue;

  List<Group> _genGroups(int totalGroups, int totalBarsPerGroup) =>
      List.generate(
        totalGroups,
        (i) => Group(List.generate(
          totalBarsPerGroup,
          (j) => Bar(_randValue),
        )),
      );

  int get _maxBarsInGroup => groups.fold(
      0, (previousValue, group) => math.max(previousValue, group.bars.length));

  @override
  State<BarChart> createState() => _BarChartState();
}

class _BarChartState extends State<BarChart> {
  late final List<List<GlobalKey>> keys;
  final mainKey = GlobalKey();
  late final BarChartEngine _engine = BarChartEngine(widget);

  final Map<(int, int), PopupController> popUps = {};

  @override
  void initState() {
    keys = List.generate(
      widget.maxGroups,
      (i) => List.generate(widget.maxBarsInGroup, (j) => GlobalKey()),
    );
    _engine.updateFrame.addListener(() {
      _engine.updateFrame.value = false;
      setState(() {});
    });
    super.initState();
  }

  @override
  void didUpdateWidget(covariant BarChart oldWidget) {
    _engine.didUpdateWidget(widget);
    for (int i = 0; i < widget.maxGroups; i++) {
      if (keys.length <= i) keys.add([]);
      for (int j = 0; j < widget.maxBarsInGroup; j++) {
        if (keys[i].length <= j) keys[i].add(GlobalKey());
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  Widget genBar(int i, int j) {
    final (group, bar) = _engine.getGroupBar(i, j);

    final minValue = widget.minValue;
    final maxValue = widget.maxValue;
    final ratio = (bar.value - minValue) / (maxValue - minValue);

    double ifNotEmptyBar(double value) {
      if (_engine.isBarEmpty(bar)) return 0;
      return value;
    }

    final mainAxis = _engine.flex.main.axis;

    /* Bar's Background Base Bar's size will be either horizontally or
    vertically max according to the [mainAxis] */
    final barBaseSize = double.infinity.toWidthHeightPairAccrToAxis(mainAxis);

    //In case of horizontal bar chart, margin will be vertical and vice-versa.
    var margin = (0, ifNotEmptyBar(group.config.interBarSpace / 2)).np;
    if (mainAxis == Axis.vertical) margin = margin.flip();

    final barWidget = Builder(builder: (context) {
      return BubblePopUp(
        popUp: bar.config.popUp(group, bar, i, j),
        popUpColor: bar.config.popUpColor,
        config: bar.config.popUpConfig!.copyWith(popUpParentKey: keys[i][j]),
        child: AnimatedContainer(
          duration: widget.duration,
          width: barBaseSize.$1,
          height: barBaseSize.$2,
          decoration: BoxDecoration(
            color: bar.config.bgColor,
            borderRadius: bar.config.bgBorder,
          ),
          margin: EdgeInsets.symmetric(
            horizontal: margin.x.toDouble(),
            vertical: margin.y.toDouble(),
          ),
          child: LayoutBuilder(builder: (context, constraints) {
            final maxLength = (mainAxis == Axis.horizontal)
                ? constraints.maxWidth
                : constraints.maxHeight;

            final barThickness = widget.expandableBarThickness
                ? null
                : ifNotEmptyBar(bar.config.width);

            /* Here in case of very small value for bar, we want to show at
            least length equal to the thickness of the bar */
            final length = math.max(maxLength * ratio, bar.config.width);

            final size =
                length.toWidthHeightPairAccrToAxis(mainAxis, barThickness);
            return Row(
              children: [
                AnimatedContainer(
                  key: keys[i][j],
                  duration: widget.duration,
                  width: size.$1,
                  height: size.$2,
                  decoration: BoxDecoration(
                    color: bar.config.color,
                    borderRadius: bar.config.border,
                  ),
                ),
              ],
            ).fixDir(_engine);
          }),
        ),
      );
    });

    if (widget.expandableBarThickness && !_engine.isBarEmpty(bar)) {
      return Expanded(child: barWidget);
    }
    return barWidget;
  }

  Widget genGroup(int i) {
    final (group, extra) = _engine.getGroup(i);

    Widget groupWidget = Row(
      children: [
        Row(
          key: _engine.groupLabelKeys[i],
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!extra.isEmpty) group.config.label(i),
            UniDirectionSpace(
              axis: _engine.flex.main.axis,
              length: group.config.labelBarSpace,
            ),
          ],
        ).fixDir(_engine),
        UniDirectionSpace(
          axis: _engine.flex.main.axis,
          length: extra.correctedSpace,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              widget.maxBarsInGroup,
              (j) => genBar(i, j),
            ),
          ).fixDir(_engine),
        )
      ],
    ).fixDir(_engine);

    groupWidget = AnimatedSize(
      duration: widget.duration,
      child: groupWidget,
    );

    if (widget.expandableBarThickness && !_engine.isGroupEmpty(group)) {
      return Expanded(child: groupWidget);
    }
    return groupWidget;
  }

  Widget get _axis {
    final textTheme = Theme.of(context).textTheme;
    final splitSize = (widget.maxValue - widget.minValue) /
        (widget.axisTotalMiddleLabels + 1);
    double axisValue(int i) => (splitSize * (i + 1)) + widget.minValue;

    return DefaultTextStyle(
      style: textTheme.bodySmall?.copyWith(color: Colors.white38) ??
          const TextStyle(),
      child: Row(
        children: [
          UniDirectionSpace(
            axis: _engine.flex.main.axis,
            length: _engine.groupLabelMaxSpace!,
          ),
          if (widget.showMinOnAxis) widget.axisLabel(widget.minValue),
          const Spacer(),
          for (int i = 0; i < widget.axisTotalMiddleLabels; i++) ...[
            widget.axisLabel(axisValue(i)),
            const Spacer(),
          ],
          if (widget.showMaxOnAxis) widget.axisLabel(widget.maxValue),
        ],
      ).fixDir(_engine),
    );
  }

  @override
  Widget build(BuildContext context) {
    _engine.build();

    final setScope =
        _engine.maxCrossLengthCalculable && !widget.popUpCanOverflow;

    final groups = <Widget>[];
    for (int i = 0; i < widget.maxGroups; i++) {
      groups.add(genGroup(i));
      if (i < _engine.groups.length - 1 &&
          !_engine.isGroupEmpty(_engine.groups[i])) {
        groups.add(UniDirectionSpace(
          axis: _engine.flex.cross.axis,
          length: _engine.interGroupSpace,
        ));
      }
    }

    final chart = Column(
      key: mainKey,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_engine.showAxis)
          _engine.isAxisBoxInferred
              ? _axis
              : _axis.getBox((box) => setState(() => _engine.axisBox = box)),
        ...groups,
      ],
    ).fixDir(_engine);

    return LayoutBuilder(builder: (context, constraints) {
      final axis = _engine.flex.cross.axis;
      final maxConstrainedCrossLength = (axis == Axis.horizontal)
          ? constraints.maxWidth
          : constraints.maxHeight;
      final maxCrossLength = (setScope && !widget.expandableBarThickness)
          ? _engine.calcMaxCrossLength
          : maxConstrainedCrossLength;
      final maxConstraints = maxCrossLength.toWidthHeightPairAccrToAxis(axis);
      final size = constraints.copyWith(
        maxWidth: maxConstraints.$1,
        maxHeight: maxConstraints.$2,
      );
      return SizedBox(
        width: size.maxWidth,
        height: size.maxHeight,
        child: setScope ? PopupScope(builder: (_) => chart) : chart,
      );
    });
  }
}
