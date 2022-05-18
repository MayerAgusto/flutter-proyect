import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class HomePageSars extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: HomePageView(),
      ),
    );
  }
}

class HomePageView extends StatelessWidget {
  final List<DeveloperSeries> data = [
    DeveloperSeries(
      year: "14-May",
      developers: 400,
      barColor: charts.ColorUtil.fromDartColor(Colors.green),
    ),
    DeveloperSeries(
      year: "15-May",
      developers: 630,
      barColor: charts.ColorUtil.fromDartColor(Colors.amber),
    ),
    DeveloperSeries(
      year: "16-May",
      developers: 220,
      barColor: charts.ColorUtil.fromDartColor(Colors.red),
    ),
    DeveloperSeries(
      year: "17-May",
      developers: 600,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    DeveloperSeries(
      year: "18-May",
      developers: 700,
      barColor:
          charts.ColorUtil.fromDartColor(Color.fromARGB(255, 44, 207, 199)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: DeveloperChart(data)),
    );
  }
}

class DeveloperChart extends StatelessWidget {
  final List<DeveloperSeries> data;

  DeveloperChart(@required this.data);

  @override
  Widget build(BuildContext context) {
    List<charts.Series<DeveloperSeries, String>> series = [
      charts.Series(
          id: "developers",
          data: data,
          domainFn: (DeveloperSeries series, _) => series.year.toString(),
          measureFn: (DeveloperSeries series, _) => series.developers,
          colorFn: (DeveloperSeries series, _) => series.barColor!)
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(9.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            Text(
              "Total carbohydrates",
              style: TextStyle(fontSize: 24),
            ),
            Expanded(
              child: charts.BarChart(series, animate: true),
            ),
            Expanded(
              child: (charts.PieChart(series, animate: true)),
            )
          ],
        ),
      ),
    );
  }
}

class DeveloperSeries {
  final String? year;
  final int? developers;
  final charts.Color? barColor;

  DeveloperSeries(
      {@required this.year,
      @required this.developers,
      @required this.barColor});
}
