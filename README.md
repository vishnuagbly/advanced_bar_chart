## Bar Chart Package for Flutter

<img src="https://raw.githubusercontent.com/vishnuagbly/advanced_bar_chart/master/logo.png" alt="Logo" height="300">

Welcome to the ultimate bar chart solution for Flutter! Our package offers unparalleled flexibility
and customization, making it easy to create stunning bar charts in any orientation with advanced
pop-up capabilities. Whether you're building a simple dashboard or a complex data visualization, our
package has got you covered.

### Features

- **Versatile Bar Orientation**: Create bar charts in any direction with a single `Direction`
  parameter. Choose from:
    - Vertical (bottom to top)
    - Vertical (top to bottom)
    - Horizontal (left to right)
    - Horizontal (right to left)

- **Advanced Pop-Up Method**: Customize your charts with pop-ups that can contain any widget.
  Pop-ups automatically adjust to stay within chart boundaries, or they can overflow to the entire
  screen with a simple boolean parameter.

- **Smooth Animations**: Enjoy smooth animations for bars and groups as they update dynamically.

- **Easy Configuration**: Extensive configuration options for groups and bars, including colors,
  spacing, and labels.

### Getting Started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  advanced_bar_chart: latest_version
```

### Simple Example

Here's a quick example to get you started with our bar chart package:

```dart
import 'package:flutter/material.dart';
import 'package:advanced_bar_chart/bar_chart.dart';

void main() {
  runApp(BarChartApp());
}

class BarChartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Bar Chart Example')),
        body: Center(
          child: BarChart(
            direction: Direction.right,
            defaultConfig: BGDefaultConfig(
              bar: DefaultBarConfig(
                bgColor: Colors.white.withOpacity(0.05),
              ),
            ),
            maxBarsInGroup: 4,
            maxGroups: 3,
            maxValue: 100.0,
            groups: [
              Group(
                [
                  Bar(75.0, config: BarConfig(color: Colors.blue)),
                  Bar(50.0, config: BarConfig(color: Colors.red)),
                  Bar(25.0, config: BarConfig(color: Colors.green)),
                ],
                config: GroupConfig(label: (index) => Text('Group $index')),
              ),
              Group(
                [
                  Bar(60.0, config: BarConfig(color: Colors.orange)),
                  Bar(30.0, config: BarConfig(color: Colors.purple)),
                  Bar(90.0, config: BarConfig(color: Colors.yellow)),
                ],
                config: GroupConfig(label: (index) => Text('Group $index')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### Main Selling Points

- **Single Parameter for Orientation**: Effortlessly switch bar chart orientations with one
  parameter, saving you time and reducing code complexity.
- **Customizable Pop-Ups**: Enhance your charts with dynamic pop-ups that can display any widget,
  ensuring your data is presented in the most informative and visually appealing way.
- **Auto-Adjust Pop-Ups**: Pop-ups auto-adjust within the chart boundaries, with the option to
  overflow the entire screen for maximum visibility.
- **Fully Customizable**: Tailor every aspect of your chart, from colors and spacing to labels and
  animations, to match your specific needs.

### Conclusion

Elevate your Flutter applications with our powerful and flexible bar chart package. Whether you're a
developer working on a personal project or a professional building enterprise-level applications,
our package will help you create beautiful and functional data visualizations with ease. Try it
today and transform the way you display data!

Happy coding! 🚀