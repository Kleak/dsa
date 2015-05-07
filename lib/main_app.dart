
import 'dart:html';
import 'dart:convert';

import 'package:polymer/polymer.dart';
import 'package:core_elements/core_selector.dart';

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
    q3();
    q4();
    q5();
    q6();
    q7();
    q8();
    q9();
    q10();
    
    window.onKeyUp.listen(_onKeyUp);
  }
  
  _onKeyUp(KeyboardEvent ke) {
    switch (ke.keyCode) {
      case 37:
        CoreSelector selector = this.$["header"];
        selector.selectPrevious(false);
        break;
        
      case 39:
        CoreSelector selector = this.$["header"];
        selector.selectNext(false);
        break;
    }
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

  q9() async {
    Map json = await getJSONForQuestion("9");
    String questionNumber = "9";

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

    String qxa = "q${questionNumber}a";
    String qxb = "q${questionNumber}b";
    String qxc = "q${questionNumber}c";
    String qxd = "q${questionNumber}d";
    String qxe = "q${questionNumber}e";

    Iterable ODC = [
      new ChartColumnSpec(label: "Question", type: ChartColumnSpec.TYPE_STRING),
      new ChartColumnSpec(label: qxa),
      new ChartColumnSpec(label: qxb),
      new ChartColumnSpec(label: qxc),
      new ChartColumnSpec(label: qxd),
      new ChartColumnSpec(label: qxe)
    ];

    Iterable ORDINAL_DATA = [
      [tranches[0]["name"], tranches[0][qxa], tranches[0][qxb], tranches[0][qxc], tranches[0][qxd], tranches[0][qxe]],
      [tranches[2]["name"], tranches[2][qxa], tranches[2][qxb], tranches[2][qxc], tranches[2][qxd], tranches[2][qxe]],
      [tranches[1]["name"], tranches[1][qxa], tranches[1][qxb], tranches[1][qxc], tranches[1][qxd], tranches[1][qxe]],
      [tranches[3]["name"], tranches[3][qxa], tranches[3][qxb], tranches[3][qxc], tranches[3][qxd], tranches[3][qxe]]
    ];

    var wrapper = this.$["security"],
    areaHost = wrapper.querySelector('.chart-host'),
    legendHost = wrapper.querySelector('.chart-legend-host');

    var series1 = new ChartSeries("one", [1, 2, 3, 4, 5], new BarChartRenderer());
    ChartConfig config = new ChartConfig([series1], [0])
      ..legend = new ChartLegend(legendHost);
    ChartData data = new ChartData(ODC, ORDINAL_DATA);
    ChartState state = new ChartState();

    var area = new CartesianArea(areaHost, data, config, state: state);

    createDefaultCartesianBehaviors().forEach((behavior) {
      area.addChartBehavior(behavior);
    });
    area.draw();
  }

  commonQ5Q6Q7Q8Q10(Map json, String id, int questionNumber) {

    String qxa = "q${questionNumber}a";
    String qxb = "q${questionNumber}b";
    String qxc = "q${questionNumber}c";
    String qxd = "q${questionNumber}d";
    String qxe = "q${questionNumber}e";

    Iterable ODC = [
      new ChartColumnSpec(label: "Question", type: ChartColumnSpec.TYPE_STRING),
      new ChartColumnSpec(label: "Nb. Response")
    ];

    Iterable ORDINAL_DATA = [
      [qxa, int.parse(json[qxa])],
      [qxb, int.parse(json[qxb])],
      [qxc, int.parse(json[qxc])],
      [qxd, int.parse(json[qxd])],
      [qxe, int.parse(json[qxe])]
    ];

    var wrapper = this.$[id],
    areaHost = wrapper.querySelector('.chart-host'),
    legendHost = wrapper.querySelector('.chart-legend-host');

    var series = new ChartSeries("one", [1], new BarChartRenderer()),
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

  q10() async {
    Map json = await getJSONForQuestion("10");
    commonQ5Q6Q7Q8Q10(json, "sustainable_development", 10);
  }

  q8() async {
    Map json = await getJSONForQuestion("8");
    commonQ5Q6Q7Q8Q10(json, "the_school", 8);
  }

  q7() async {
    Map json = await getJSONForQuestion("7");
    commonQ5Q6Q7Q8Q10(json, "improving_care_to_people", 7);
  }

  q6() async {
    Map json = await getJSONForQuestion("6");
    commonQ5Q6Q7Q8Q10(json, "education", 6);
  }

  q5() async {
    Map json = await getJSONForQuestion("5");
    commonQ5Q6Q7Q8Q10(json, "culture_and_leisure", 5);
  }

  commonQ3AndQ4(Map json, String id, int questionNumber) {
    Map infosStudent = <String, int>{};
    Map infosPen = <String, int>{};
    Map infosAuth = <String, int>{};

    json.forEach((String key, Map value) {
      if (key == "Student") {
        value.forEach((String key, String value) {
          if (key != "max") {
            infosStudent[key] = int.parse(value);
          }
        });
      } else if (key == "Pensionr") {
        value.forEach((String key, String value) {
          if (key != "max") {
            infosPen[key] = int.parse(value);
          }
        });
      } else {
        value.forEach((String key, String value) {
          if (key != "max") {
            if (!infosAuth.containsKey(key)) {
              infosAuth[key] = 0;
            }
            infosAuth[key] += int.parse(value);
          }
        });
      }
    });

    String qxa = "q${questionNumber}a";
    String qxb = "q${questionNumber}b";
    String qxc = "q${questionNumber}c";
    String qxd = "q${questionNumber}d";
    String qxe = "q${questionNumber}e";

    Iterable ODC = [
      new ChartColumnSpec(label: "", type: ChartColumnSpec.TYPE_STRING),
      new ChartColumnSpec(label: qxa),
      new ChartColumnSpec(label: qxb),
      new ChartColumnSpec(label: qxc),
      new ChartColumnSpec(label: qxd),
      new ChartColumnSpec(label: qxe)
    ];

    Iterable ORDINAL_DATA = [
      ["Student", infosStudent[qxa], infosStudent[qxb], infosStudent[qxc], infosStudent[qxd], infosStudent[qxe]],
      ["Pensionr", infosPen[qxa], infosPen[qxb], infosPen[qxc], infosPen[qxd], infosPen[qxe]],
      ["Actif", infosAuth[qxa], infosAuth[qxb], infosAuth[qxc], infosAuth[qxd], infosAuth[qxe]]
    ];

    var wrapper = this.$[id],
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

  q4() async {
    Map json = await getJSONForQuestion("4");
    commonQ3AndQ4(json, "communication", 4);
  }

  q3() async {
    Map json = await getJSONForQuestion("3");
    commonQ3AndQ4(json, "live_making_common_places", 3);
  }

  q2() async {
    Map json = await getJSONForQuestion("2");

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

    Iterable ODC = [
      new ChartColumnSpec(label: "Number of years", type: ChartColumnSpec.TYPE_STRING),
      new ChartColumnSpec(label: "q2a"),
      new ChartColumnSpec(label: "q2b"),
      new ChartColumnSpec(label: "q2c"),
      new ChartColumnSpec(label: "q2d"),
      new ChartColumnSpec(label: "q2e")
    ];

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