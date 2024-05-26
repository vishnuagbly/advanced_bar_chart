import 'package:num_pair/num_pair.dart';
import 'package:advanced_bar_chart/objects/bar_direction.dart';

extension NumPairExt on NumPair {
  Direction get toBarDirection => Direction(x.toInt(), y.toInt());

  num dotSum(NumPair np) => (this * np).sum();

  ///Returns the index of the maximum value in this.
  int get maxIndex => x > y ? 0 : 1;
}
