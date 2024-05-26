import 'package:advanced_bar_chart/objects/configs.dart';

class Bar {
  ///Object storing all the bar information.
  const Bar(
    this.value, {
    this.config = const BarConfig(),
  });

  final double value;
  final BarConfig config;
}

class FBar {
  final double value;
  final DefaultBarConfig config;

  const FBar(this.value, this.config);

  FBar.from(Bar bar, BarConfig groupDefaults, DefaultBarConfig defaultConfig)
      : value = bar.value,
        config = defaultConfig.copyWith(
          BarConfig.fold([bar.config, groupDefaults]),
        );

  FBar copyWith({double? value, DefaultBarConfig? config}) =>
      FBar(value ?? this.value, config ?? this.config);
}
