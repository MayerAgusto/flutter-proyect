import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_app/models/Recipe.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class HomePageSars extends StatefulWidget {
  const HomePageSars({Key? key}) : super(key: key);
  @override
  _HomePageSarsState createState() => _HomePageSarsState();
}

class _HomePageSarsState extends State<HomePageSars> {
  List<GDPData>? _chartData;
  List<GDPData>? _donuthChartData;
  List<Recipe>? _data;
  late List<ExpenseData> _linearData;
  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    _linearData = [];
    // TODO: implement initState
    getFromFirebase().then((data) {
      setState(() {
        _chartData = gethartData(data);
        _linearData = getChartLineData(data);
        _donuthChartData = getMonthData(data);
      });
    });
    _tooltipBehavior = TooltipBehavior(enable: true);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10),
        child: DefaultTabController(
            length: 3,
            initialIndex: 0,
            child: Column(
              children: [
                TabBar(
                    labelColor: Colors.black,
                    indicator: DotIndicator(
                      color: Colors.amber,
                      distanceFromCenter: 16,
                      radius: 3,
                      paintingStyle: PaintingStyle.fill,
                    ),
                    unselectedLabelColor: Colors.black.withOpacity(0.3),
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                    tabs: [
                      Tab(text: "Calorias".toLowerCase()),
                      Tab(text: "Proteinas".toLowerCase()),
                      Tab(text: "Mensual".toLowerCase()),
                    ]),
                Divider(
                  color: Colors.black.withOpacity(0.3),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _circleBar(),
                      _chartBar(),
                      getMoth(),
                    ],
                  ),
                )
              ],
            )),
      ),
    ));
  }

  Widget _chartBar() {
    return SfCartesianChart(
      title: ChartTitle(text: "Consumo diario en (g)"),
      legend: Legend(isVisible: true),
      tooltipBehavior: _tooltipBehavior,
      series: <ChartSeries>[
        StackedBarSeries<ExpenseData, String>(
            dataSource: _linearData,
            xValueMapper: (ExpenseData exp, _) => exp.date,
            yValueMapper: (ExpenseData exp, _) => exp.p,
            name: "Proteinas",
            markerSettings: MarkerSettings(isVisible: true)),
        StackedBarSeries<ExpenseData, String>(
            dataSource: _linearData,
            xValueMapper: (ExpenseData exp, _) => exp.date,
            yValueMapper: (ExpenseData exp, _) => exp.c,
            name: "Carbohidratos",
            markerSettings: MarkerSettings(isVisible: true)),
        StackedBarSeries<ExpenseData, String>(
            dataSource: _linearData,
            xValueMapper: (ExpenseData exp, _) => exp.date,
            yValueMapper: (ExpenseData exp, _) => exp.g_sat,
            name: "G. Saturadas",
            markerSettings: MarkerSettings(isVisible: true)),
        StackedBarSeries<ExpenseData, String>(
            dataSource: _linearData,
            xValueMapper: (ExpenseData exp, _) => exp.date,
            yValueMapper: (ExpenseData exp, _) => exp.g_trans,
            name: "G. Trans",
            markerSettings: MarkerSettings(isVisible: true))
      ],
      primaryXAxis: CategoryAxis(),
    );
  }

  Widget getMoth() {
    return SfCircularChart(
      title: ChartTitle(text: "Calorias consumidas por mes (cal)"),
      legend:
          Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
      tooltipBehavior: _tooltipBehavior,
      series: <CircularSeries>[
        DoughnutSeries<GDPData, String>(
          dataSource: _donuthChartData,
          xValueMapper: (GDPData data, _) => data.cadena,
          yValueMapper: (GDPData data, _) => data.gpd,
          dataLabelSettings: DataLabelSettings(isVisible: true),
          enableTooltip: true,
        )
      ],
    );
  }

  Widget _circleBar() {
    return SfCircularChart(
      title: ChartTitle(text: "Calorias consumidas por dia en (cal)"),
      legend:
          Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
      tooltipBehavior: _tooltipBehavior,
      series: <CircularSeries>[
        RadialBarSeries<GDPData, String>(
          dataSource: _chartData,
          xValueMapper: (GDPData data, _) => data.cadena,
          yValueMapper: (GDPData data, _) => data.gpd,
          dataLabelSettings: DataLabelSettings(isVisible: true),
          enableTooltip: true,
          maximumValue: 10000,
        )
      ],
    );
  }

  Future<List<Recipe>> getFromFirebase() async {
    CollectionReference _collectionReference =
        FirebaseFirestore.instance.collection("recipes");

    QuerySnapshot querySnapshot = await _collectionReference.get();
    final datas = querySnapshot.docs.map((e) => e.data()).toList();
    List<Recipe> list = [];
    for (var item in datas) {
      list.add(Recipe.fromJson(item as Map<String, dynamic>));
    }
    return list;
  }

  List<GDPData> gethartData(List<Recipe> list) {
    var loadMap = new Map<String, int>();
    final List<GDPData> chartData = [];
    for (var food in list) {
      var key =
          loadMap.keys.firstWhere((k) => k == food.date, orElse: () => "Empty");
      if (key == "Empty") {
        loadMap[food.date] = food.calories!.toInt();
      } else {
        loadMap[key] = loadMap[key]! + food.calories!.toInt();
      }
    }
    for (var key in loadMap.keys) {
      chartData.add(GDPData(key, loadMap[key]!.toInt()));
    }
    return chartData;
  }

  List<GDPData> getMonthData(List<Recipe> list) {
    var loadMap = new Map<String, int>();
    final List<GDPData> chartData = [];
    for (var food in list) {
      var key = loadMap.keys.firstWhere((k) => k == food.date.substring(0, 3),
          orElse: () => "Empty");
      if (key == "Empty") {
        loadMap[food.date.substring(0, 3)] = food.calories!.toInt();
      } else {
        loadMap[key] = loadMap[key]! + food.calories!.toInt();
      }
    }
    for (var key in loadMap.keys) {
      chartData.add(GDPData(key, loadMap[key]!.toInt()));
    }
    return chartData;
  }

  List<ExpenseData> getChartLineData(List<Recipe> list) {
    final List<ExpenseData> chartData = [];
    List<ExpenseData> saved_chartData = [];
    var loadMap = new Map<String, Data>();
    for (var food in list) {
      var c, p, g_sat, g_trans = 0;
      for (var n in food.nutrient) {
        if (n.label == "Carbs") {
          c = n.quantity;
        }
        if (n.label == "Protein") {
          p = n.quantity;
        }
        if (n.label == "Saturated") {
          g_sat = n.quantity;
        }
        if (n.label == "Trans") {
          g_trans = n.quantity;
        }
      }
      saved_chartData.add(ExpenseData(food.date, p, c, g_sat, g_trans));
    }
    for (var item in saved_chartData) {
      var key =
          loadMap.keys.firstWhere((k) => k == item.date, orElse: () => "Empty");
      if (key == "Empty") {
        loadMap[item.date] = Data(item.p, item.c, item.g_sat, item.g_trans);
      } else {
        loadMap[item.date] = Data(
            item.p + loadMap[item.date]!.p,
            item.c + loadMap[item.date]!.c,
            item.g_sat + loadMap[item.date]!.g_sat,
            item.g_trans + loadMap[item.date]!.g_trans);
      }
    }
    for (var items in loadMap.keys) {
      chartData.add(ExpenseData(items.substring(0, 6), loadMap[items]!.p,
          loadMap[items]!.c, loadMap[items]!.g_sat, loadMap[items]!.g_trans));
    }
    return chartData;
  }
}

class Data {
  Data(this.p, this.c, this.g_sat, this.g_trans);
  num p = 0;
  num c = 0;
  num g_sat = 0;
  num g_trans = 0;
}

class ExpenseData {
  ExpenseData(this.date, this.p, this.c, this.g_sat, this.g_trans);
  final String date;
  final num p;
  final num c;
  final num g_sat;
  final num g_trans;
}

class GDPData {
  GDPData(this.cadena, this.gpd);
  final String cadena;
  final int gpd;
}
