// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:charted/charted.dart';
import 'package:charted/charts/charts.dart';

Iterable<ChartBehavior> createDefaultCartesianBehaviors() =>
  new List.from([new ChartTooltip(), new AxisLabelTooltip()]);

/// Sample columns used by demos with quantitative dimension scale
Iterable ORDINAL_DATA_COLUMNS = [
  new ChartColumnSpec(label: 'Month', type: ChartColumnSpec.TYPE_STRING),
  new ChartColumnSpec(label: 'Grains'),
  new ChartColumnSpec(label: 'Fruits'),
  new ChartColumnSpec(label: 'Vegetables')
];

/// Sample values used by demos with quantitative dimension scale
Iterable ORDINAL_DATA = const [
    const ['January',   4.50,  7,  6],
    const ['February',  5.61, 16,  8],
    const ['March',     8.26, 36,  9],
    const ['April',    15.46, 63, 49],
    const ['May',      18.50, 77, 46],
    const ['June',     14.61, 60,  8],
    const ['July',      3.26,  9,  6],
    const ['August',    1.46,  9,  3],
    const ['September', 1.46, 13,  9],
    const ['October',   2.46, 29,  3],
    const ['November',  4.46, 33,  9],
    const ['December',  8.46, 19,  3]
];

void drawSimpleBarChart(String selector, bool grouped) {
  var wrapper = document.querySelector(selector),
  areaHost = wrapper.querySelector('.chart-host'),
  legendHost = wrapper.querySelector('.chart-legend-host');

  var series = new ChartSeries(
      "one", grouped ? [2, 3] : [2], new BarChartRenderer());
  ChartConfig config = new ChartConfig([series], [0])
    ..legend = new ChartLegend(legendHost);
  ChartData data = new ChartData(ORDINAL_DATA_COLUMNS, ORDINAL_DATA);
  ChartState state = new ChartState();

  CartesianArea area = new CartesianArea(areaHost, data, config, state: state);

  createDefaultCartesianBehaviors().forEach((behavior) {
    area.addChartBehavior(behavior);
  });
  area.draw();
}

void main() {
  drawSimpleBarChart("#simple-bar-chart", true);
}
