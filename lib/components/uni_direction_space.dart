import 'package:flutter/material.dart';

class UniDirectionSpace extends StatelessWidget {
  const UniDirectionSpace({
    super.key,
    this.axis = Axis.horizontal,
    this.length = 0,
  });

  final Axis axis;
  final num length;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: axis == Axis.horizontal ? length.toDouble() : 0,
      height: axis == Axis.vertical ? length.toDouble() : 0,
    );
  }
}
