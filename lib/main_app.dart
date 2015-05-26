
import 'dart:html';
import 'dart:convert';

import 'package:polymer/polymer.dart';
import 'package:core_elements/core_selector.dart';

import 'package:charted/charted.dart';

import 'package:http/browser_client.dart';
import 'package:http/http.dart' as http;

Iterable<ChartBehavior> createDefaultCartesianBehaviors() =>
  new List.from([new Hovercard(), new AxisLabelTooltip()]);

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
      new ChartColumnSpec(label: "Increase security around the station area"),
      new ChartColumnSpec(label: "More police in central Väsby"),
      new ChartColumnSpec(label: "Improve the lighting in the center of Vasby"),
      new ChartColumnSpec(label: "Narrow opening hours for alcohol outlets in central Väsby"),
      new ChartColumnSpec(label: "Extend hours of business in central Väsby")
    ];

    int total_zero = tranches[0][qxa] + tranches[0][qxb] + tranches[0][qxc] + tranches[0][qxd] + tranches[0][qxe];
    int total_two = tranches[2][qxa] + tranches[2][qxb] + tranches[2][qxc] + tranches[2][qxd] + tranches[2][qxe];
    int total_one = tranches[1][qxa] + tranches[1][qxb] + tranches[1][qxc] + tranches[1][qxd] + tranches[1][qxe];
    int total_three = tranches[3][qxa] + tranches[3][qxb] + tranches[3][qxc] + tranches[3][qxd] + tranches[3][qxe];

    Iterable ORDINAL_DATA = [
      [tranches[0]["name"], tranches[0][qxa] / total_zero * 100, tranches[0][qxb] / total_zero * 100, tranches[0][qxc] / total_zero * 100, tranches[0][qxd] / total_zero * 100, tranches[0][qxe] / total_zero * 100],
      [tranches[2]["name"], tranches[2][qxa] / total_two * 100, tranches[2][qxb] / total_two * 100, tranches[2][qxc] / total_two * 100, tranches[2][qxd] / total_two * 100, tranches[2][qxe] / total_two * 100],
      [tranches[1]["name"], tranches[1][qxa] / total_one * 100, tranches[1][qxb] / total_one * 100, tranches[1][qxc] / total_one * 100, tranches[1][qxd] / total_one * 100, tranches[1][qxe] / total_one * 100],
      [tranches[3]["name"], tranches[3][qxa] / total_three * 100, tranches[3][qxb] / total_three * 100, tranches[3][qxc] / total_three * 100, tranches[3][qxd] / total_three * 100, tranches[3][qxe] / total_three * 100]
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

    String readableQuestionA = "Expand the range of cultural sports and leisure activities";
    String readableQuestionB = "Creating better opportunities for festivals and concerts";
    String readableQuestionC = "Creating more opportunities for outdoor sports";
    String readableQuestionD = "Create marketplaces outdoors";
    String readableQuestionE = "Providing municipal grants for cultural and leisure projects";
    if (questionNumber == 6) {
      readableQuestionA = "Renovate older schools";
      readableQuestionB = "Building new schools";
      readableQuestionC = "Improve the schoolyard the physical environments";
      readableQuestionD = "Improve the quality of primary education";
      readableQuestionE = "Improve the quality of secondary education are";
    } else if (questionNumber == 7) {
      readableQuestionA = "More cultural and recreational activities for the elderly";
      readableQuestionB = "More cultural and recreational activities for children and young people";
      readableQuestionC = "Improving care for the elderly in the municipality";
      readableQuestionD = "More youth centers and field assistants";
      readableQuestionE = "Reduce the groups of children in preschool";
    } else if (questionNumber == 8) {
      readableQuestionA = "Small groups of children in preschool";
      readableQuestionB = "Raise the quality of teaching";
      readableQuestionC = "More professional development for schools and teachers";
      readableQuestionD = "More modern information technology (IT) in education";
      readableQuestionE = "Involve carers more in school";
    } else if (questionNumber == 10) {
      readableQuestionA = "Reduce energy consumption";
      readableQuestionB = "Reduce transport and noise";
      readableQuestionC = "Increase climate adaptation and recycling";
      readableQuestionD = "Prioritize environmentally friendly transport modes (walking, cycling, public transport)";
      readableQuestionE = "Reducing environmental toxins and hazardous chemicals in nature";
    }
    
    String qxa = "q${questionNumber}a";
    String qxb = "q${questionNumber}b";
    String qxc = "q${questionNumber}c";
    String qxd = "q${questionNumber}d";
    String qxe = "q${questionNumber}e";

    Iterable ODC = [
      new ChartColumnSpec(label: "Question", type: ChartColumnSpec.TYPE_STRING),
      new ChartColumnSpec(label: "% Response")
    ];

    int nbVoteQxa = int.parse(json[qxa]);
    int nbVoteQxb = int.parse(json[qxb]);
    int nbVoteQxc = int.parse(json[qxc]);
    int nbVoteQxd = int.parse(json[qxd]);
    int nbVoteQxe = int.parse(json[qxe]);
    
    int totalVote = nbVoteQxa + nbVoteQxb + nbVoteQxc + nbVoteQxd + nbVoteQxe;

    Iterable ORDINAL_DATA = [
      [readableQuestionA, nbVoteQxa / totalVote * 100],
      [readableQuestionB, nbVoteQxb / totalVote * 100],
      [readableQuestionC, nbVoteQxc / totalVote * 100],
      [readableQuestionD, nbVoteQxd / totalVote * 100],
      [readableQuestionE, nbVoteQxe / totalVote * 100]
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

    String readableQuestionA = "Mix Traffic Act";
    String readableQuestionB = "Place parking along the streets";
    String readableQuestionC = "Turning entrances to streets";
    String readableQuestionD = "Place public buildings in transparent ground floors";
    String readableQuestionE = "Secure parking solutions for homes";
    if (questionNumber == 4) {
      readableQuestionA = "Pairing the new streets with existing ones to strengthen the connection to the adjacent neighborhoods and reduce the barriers that the main roads pose";
      readableQuestionB = "Improve communications at night between various parts of the municipality";
      readableQuestionC = "Improve communications to and from Uppsala";
      readableQuestionD = "Improve the north-south and east-west routes through a fine-mesh and well integrated metropolitan area networks";
      readableQuestionE = "Improve communications to and from downtown Stockholm";
    }

    String qxa = "q${questionNumber}a";
    String qxb = "q${questionNumber}b";
    String qxc = "q${questionNumber}c";
    String qxd = "q${questionNumber}d";
    String qxe = "q${questionNumber}e";
    
    int totalStudent = infosStudent[qxa] + infosStudent[qxb] + infosStudent[qxc] + infosStudent[qxd] + infosStudent[qxe];
    int total_pensionr = infosPen[qxa] + infosPen[qxb] + infosPen[qxc] + infosPen[qxd] + infosPen[qxe];
    int total_activ = infosAuth[qxa] + infosAuth[qxb] + infosAuth[qxc] + infosAuth[qxd] + infosAuth[qxe];

    Iterable ODC = [
      new ChartColumnSpec(label: "", type: ChartColumnSpec.TYPE_STRING),
      new ChartColumnSpec(label: readableQuestionA),
      new ChartColumnSpec(label: readableQuestionB),
      new ChartColumnSpec(label: readableQuestionC),
      new ChartColumnSpec(label: readableQuestionD),
      new ChartColumnSpec(label: readableQuestionE)
    ];

    Iterable ORDINAL_DATA = [
      ["Student", infosStudent[qxa] / totalStudent * 100, infosStudent[qxb] / totalStudent * 100, infosStudent[qxc] / totalStudent * 100, infosStudent[qxd] / totalStudent * 100, infosStudent[qxe] / totalStudent * 100],
      ["Pensionr", infosPen[qxa] / total_pensionr * 100, infosPen[qxb] / total_pensionr * 100, infosPen[qxc] / total_pensionr * 100, infosPen[qxd] / total_pensionr * 100, infosPen[qxe] / total_pensionr * 100],
      ["Actif", infosAuth[qxa] / total_activ * 100, infosAuth[qxb] / total_activ * 100, infosAuth[qxc] / total_activ * 100, infosAuth[qxd] / total_activ * 100, infosAuth[qxe] / total_activ * 100]
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
      new ChartColumnSpec(label: "Offer more housing types"),
      new ChartColumnSpec(label: "Offer more apartment sizes"),
      new ChartColumnSpec(label: "Offer small-scale land ownership"),
      new ChartColumnSpec(label: "Preserve the conceptual foundations of the buildings from the 1970s"),
      new ChartColumnSpec(label: "Offer more housing near the water")
    ];

    int total_two = tranches[2]["q2a"] + tranches[2]["q2b"] + tranches[2]["q2c"] + tranches[2]["q2d"] + tranches[2]["q2e"];
    int total_zero = tranches[0]["q2a"] + tranches[0]["q2b"] + tranches[0]["q2c"] + tranches[0]["q2d"] + tranches[0]["q2e"];
    int total_one = tranches[1]["q2a"] + tranches[1]["q2b"] + tranches[1]["q2c"] + tranches[1]["q2d"] + tranches[1]["q2e"];

    Iterable ORDINAL_DATA = [
      [tranches[2]["name"], tranches[2]["q2a"] / total_two * 100, tranches[2]["q2b"] / total_two * 100, tranches[2]["q2c"] / total_two * 100, tranches[2]["q2d"] / total_two * 100, tranches[2]["q2e"] / total_two * 100],
      [tranches[0]["name"], tranches[0]["q2a"] / total_zero * 100, tranches[0]["q2b"] / total_zero * 100, tranches[0]["q2c"] / total_zero * 100, tranches[0]["q2d"] / total_zero * 100, tranches[0]["q2e"] / total_zero * 100],
      [tranches[1]["name"], tranches[1]["q2a"] / total_one * 100, tranches[1]["q2b"] / total_one * 100, tranches[1]["q2c"] / total_one * 100, tranches[1]["q2d"] / total_one * 100, tranches[1]["q2e"] / total_one * 100]
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
      "q1e": 0,
      "total": 0
    };

    Map<String, int> maxCountry = {
      "q1a": 0,
      "q1b": 0,
      "q1c": 0,
      "q1d": 0,
      "q1e": 0,
      "total": 0
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
          maxCity["total"] += int.parse(information[information["max"]]);
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
          maxCountry["total"] += int.parse(information[information["max"]]);
          maxCountry[information["max"]] += int.parse(information[information["max"]]);
          break;
      }
    });
    
    Iterable ODC = [
      new ChartColumnSpec(label: "City", type: ChartColumnSpec.TYPE_STRING),
      new ChartColumnSpec(label: "Preserve existing turf"),
      new ChartColumnSpec(label: "Construction of parks in existing neighborhoods"),
      new ChartColumnSpec(label: "Build homes near green spaces"),
      new ChartColumnSpec(label: "Renovate existing parks"),
      new ChartColumnSpec(label: "Improve accessibility to major green spaces")
    ];

    Iterable CITY_DATA = [
      ["City", maxCity["q1a"] / maxCity["total"] * 100, maxCity["q1b"] / maxCity["total"] * 100, maxCity["q1c"] / maxCity["total"] * 100, maxCity["q1d"] / maxCity["total"] * 100, maxCity["q1e"] / maxCity["total"] * 100],
      ["Country", maxCountry["q1a"] / maxCountry["total"] * 100, maxCountry["q1b"] / maxCountry["total"] * 100, maxCountry["q1c"] / maxCountry["total"] * 100, maxCountry["q1d"] / maxCountry["total"] * 100, maxCountry["q1e"] / maxCountry["total"] * 100]
    ];
    
    var wrapper_city = this.$["parks_and_green_spaces"];
    var areaHost_city = wrapper_city.querySelector('.chart-host');
    var legendHost_city = wrapper_city.querySelector('.chart-legend-host');

    var series_city = new ChartSeries("one", [1, 2, 3, 4, 5], new BarChartRenderer());
    var config_city = new ChartConfig([series_city], [0])
      ..legend = new ChartLegend(legendHost_city);
    var data_city = new ChartData(ODC, CITY_DATA);
    var state_city = new ChartState();

    var area_city = new CartesianArea(areaHost_city, data_city, config_city, state: state_city);

    createDefaultCartesianBehaviors().forEach((behavior) {
      area_city.addChartBehavior(behavior);
    });
    area_city.draw();
  }
}