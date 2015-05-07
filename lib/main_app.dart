
import 'dart:html';
import 'dart:convert';

import 'package:polymer/polymer.dart';

import 'package:charted/charted.dart';

import 'package:http/browser_client.dart';
import 'package:http/http.dart' as http;

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

@CustomTag('main-app')
class MainApp extends PolymerElement {
  String selectedItem;

  MainApp.created() : super.created() {
    selectedItem = "parks_and_green_spaces";
  }

  @override
  attached() {
    super.attached();

    q1();
    q2();
  }

  void drawSimpleBarChart(String selector, bool grouped) {
    var wrapper = document.querySelector(selector),
    areaHost = wrapper.querySelector('.chart-host'),
    legendHost = wrapper.querySelector('.chart-legend-host');

    var series = new ChartSeries(
        "one", grouped ? [2, 3] : [2], new BarChartRenderer()),
    config = new ChartConfig([series], [0])
      ..legend = new ChartLegend(legendHost),
    data = new ChartData(ORDINAL_DATA_COLUMNS, ORDINAL_DATA),
    state = new ChartState();

    var area = new CartesianArea(areaHost, data, config, state: state);

    createDefaultCartesianBehaviors().forEach((behavior) {
      area.addChartBehavior(behavior);
    });
    area.draw();
  }

  getJSONForQuestion(String questionNumber) async {
    BrowserClient client = new BrowserClient();
    http.Response response = await client.get("http://localhost/q$questionNumber.php");
    return JSON.decode(response.body);
  }

  q2() async {
    Map json = await getJSONForQuestion("2");

    Iterable ODC = [
      new ChartColumnSpec(label: "Number of years", type: ChartColumnSpec.TYPE_STRING),
      new ChartColumnSpec(label: "q2a"),
      new ChartColumnSpec(label: "q2b"),
      new ChartColumnSpec(label: "q2c"),
      new ChartColumnSpec(label: "q2d"),
      new ChartColumnSpec(label: "q2e")
    ];

    List<Map> tranches = <Map>[];
    json.forEach((String tranche, Map questions) {
      Map well_formated = {};
      well_formated["name"] = tranche;
      questions.forEach((String key, String value) {
        if (key != "max") {
          well_formated[key] = int.parse(value);
        }
      });
      tranches.add(well_formated);
    });

    Iterable ORDINAL_DATA = [
      [tranches[2]["name"], tranches[2]["q2a"], tranches[2]["q2b"], tranches[2]["q2c"], tranches[2]["q2d"], tranches[2]["q2e"]],
      [tranches[0]["name"], tranches[0]["q2a"], tranches[0]["q2b"], tranches[0]["q2c"], tranches[0]["q2d"], tranches[0]["q2e"]],
      [tranches[1]["name"], tranches[1]["q2a"], tranches[1]["q2b"], tranches[1]["q2c"], tranches[1]["q2d"], tranches[1]["q2e"]]
    ];

    var wrapper = this.$["diversity_in_housing_supply"],
    areaHost = wrapper.querySelector('.chart-host'),
    legendHost = wrapper.querySelector('.chart-legend-host');

    var series = new ChartSeries("one", [1, 2, 3, 4, 5], new BarChartRenderer()),
    config = new ChartConfig([series], [0])
      ..legend = new ChartLegend(legendHost),
    data = new ChartData(ODC, ORDINAL_DATA),
    state = new ChartState();

    var area = new CartesianArea(areaHost, data, config, state: state);

    createDefaultCartesianBehaviors().forEach((behavior) {
      area.addChartBehavior(behavior);
    });
    area.draw();
  }

  q1() async {
    Map json = await getJSONForQuestion("1");
    Map<String, int> maxCity = {
      "q1a": 0,
      "q1b": 0,
      "q1c": 0,
      "q1d": 0,
      "q1e": 0
    };

    Map<String, int> maxCountry = {
      "q1a": 0,
      "q1b": 0,
      "q1c": 0,
      "q1d": 0,
      "q1e": 0
    };

    json.forEach((String city, Map information) {
      switch (city) {
        case "Runby":
        case "Odenslunda":
        case "Vilunda/Korpkulla":
        case "Kavallerigatan/Vilundaparken":
        case "Brunnby-Vik":
        case "Smedby 2":
        case "Antuna/Älvsunda":
        case "Carlslund/Brunnby Park":
        case "Dragonvägen":
        case "Ekebo":
        case "Ekeby/Sköldnora":
        case "Folkparksområdet":
        case "Hasselbacken":
        case "Hasselgatan":
        case "Infra City":
        case "Johannesdal":
        case "Länk-/Klock-/Kedje-/Bygelvägen":
        case "Lindhemsvägen":
        case "Messingen/Optimus":
        case "Norra Bollstanäs":
        case "Norra Vik":
        case "Odenslunda":
        case "Prästgårdsmarken":
        case "Runby Backar/Lövsta":
        case "Sigma/Apoteksskogen":
        case "Sjukyrkoberget":
        case "Södra Bollstanäs":
        case "Södra Prästgårdsmarken":
        case "Stallgatan":
        case "Väsby villastad/Tegelbruket":
        case "Vatthagen":
        case "Vilunda/Korpkulla":
          maxCity[information["max"]] += int.parse(information[information["max"]]);
          break;

        case "Njursta":
        case "Skälby":
        case "Sanda Ängar":
        case "Stora Wäsby gård":
        case "Runby Backar/Lövsta":
        case "Frestaby":
        case "Fresta glesbygd":
        case "Eds Glesbygd":
        case "Glädjen/Skälbys arbetsområde":
        case "Grimstaby":
        case "Holmen":
        case "Smedby 2":
        case "Smedby 3":
        case "Smedby arbetsområde":
          maxCountry[information["max"]] += int.parse(information[information["max"]]);
          break;

      }
    });

    String questionMaxCity = "";
    int tmp = 0;
    maxCity.forEach((String question, int numberOfVote) {
      if (numberOfVote > tmp) {
        questionMaxCity = question;
      }
    });

    String questionMaxCountry = "";
    tmp = 0;
    maxCountry.forEach((String question, int numberOfVote) {
      if (numberOfVote > tmp) {
        questionMaxCountry = question;
      }
    });

    Iterable ODC = [
      new ChartColumnSpec(label: "City", type: ChartColumnSpec.TYPE_STRING),
      new ChartColumnSpec(label: "q1a"),
      new ChartColumnSpec(label: "q1b"),
      new ChartColumnSpec(label: "q1c"),
      new ChartColumnSpec(label: "q1d"),
      new ChartColumnSpec(label: "q1e")
    ];

    Iterable ORDINAL_DATA = [
      ["City", maxCity["q1a"], maxCity["q1b"], maxCity["q1c"], maxCity["q1d"], maxCity["q1e"]],
      ["Country", maxCountry["q1a"], maxCountry["q1b"], maxCountry["q1c"], maxCountry["q1d"], maxCountry["q1e"]]
    ];

    var wrapper = this.$["parks_and_green_spaces"],
    areaHost = wrapper.querySelector('.chart-host'),
    legendHost = wrapper.querySelector('.chart-legend-host');

    var series = new ChartSeries("one", [1, 2, 3, 4, 5], new BarChartRenderer()),
    config = new ChartConfig([series], [0])
      ..legend = new ChartLegend(legendHost),
    data = new ChartData(ODC, ORDINAL_DATA),
    state = new ChartState();

    var area = new CartesianArea(areaHost, data, config, state: state);

    createDefaultCartesianBehaviors().forEach((behavior) {
      area.addChartBehavior(behavior);
    });
    area.draw();
  }
}