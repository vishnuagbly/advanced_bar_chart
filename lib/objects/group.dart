import 'package:flutter/material.dart';

import 'bar.dart';
import 'configs.dart';

typedef GroupLabelFn = Widget Function(int index);

class Group {
  ///Group of bars, packed together, under a single [label].
  ///
  ///Using [label], a [Widget] is generated, that will be displayed, beside the
  ///group of bars, example:-
  ///
  ///```dart
  ///final companyCostGroup = Group(
  ///  [...],
  ///  label: (_) => CompanyLogo(),
  ///);
  ///```
  ///
  ///[labelBarSpace] is the space between label and the group of bars.
  const Group(
    this.bars, {
    this.config = const GroupConfig(),
    this.defaultBarConfig = const BarConfig(),
  });

  final List<Bar> bars;
  final GroupConfig config;
  final BarConfig defaultBarConfig;
}

class FGroup {
  final List<FBar> bars;
  final DefaultGroupConfig config;
  final BarConfig defaultBarConfig;

  const FGroup({
    required this.bars,
    this.defaultBarConfig = const BarConfig(),
    required this.config,
  });

  FGroup.from(Group group, BGDefaultConfig defaultConfig)
      : bars = group.bars
            .map((bar) =>
                FBar.from(bar, group.defaultBarConfig, defaultConfig.bar))
            .toList(),
        config = defaultConfig.group.copyWith(group.config),
        defaultBarConfig = group.defaultBarConfig;

  FBar? operator [](int index) {
    try {
      return bars[index];
    } catch (err) {
      return null;
    }
  }
}