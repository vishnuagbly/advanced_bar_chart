import 'package:flutter/material.dart';

extension WidgetExt on Widget {
  Widget getBox(void Function(RenderBox box) fn) {
    final key = GlobalKey();
    return Builder(
      builder: (context) {
        _getBox(fn, key);
        return Container(
          key: key,
          child: this,
        );
      },
    );
  }

  void _getBox(void Function(RenderBox box) fn, GlobalKey key) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final box = key.currentContext?.findRenderObject() as RenderBox?;
      if (box == null) return _getBox(fn, key);

      fn(box);
    });
  }
}
