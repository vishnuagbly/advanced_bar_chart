import 'package:advanced_bar_chart/advanced_bar_chart.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  constraints: const BoxConstraints(maxHeight: 350),
                  color: Colors.white10,
                  padding: const EdgeInsets.all(10.0),
                  child: BarChart(
                    expandableBarThickness: true,
                    direction: Direction.up,
                    defaultConfig: BGDefaultConfig(
                      bar: DefaultBarConfig(
                        bgColor: Colors.white.withOpacity(0.05),
                      ),
                      group: DefaultGroupConfig(
                        label: (index) => Text('Grp $index'),
                      ),
                    ),
                    maxBarsInGroup: 4,
                    maxGroups: 3,
                    maxValue: 100.0,
                    groups: const [
                      Group(
                        [
                          Bar(60.0, config: BarConfig(color: Colors.blue)),
                          Bar(50.0, config: BarConfig(color: Colors.red)),
                          Bar(25.0, config: BarConfig(color: Colors.green)),
                        ],
                      ),
                      Group(
                        [
                          Bar(60.0, config: BarConfig(color: Colors.orange)),
                          Bar(30.0, config: BarConfig(color: Colors.purple)),
                          Bar(90.0, config: BarConfig(color: Colors.yellow)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
