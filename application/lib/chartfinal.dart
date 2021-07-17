import 'package:apicall/chartdata.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ChartFinal extends StatelessWidget {
  final List<ChartData> data;
  ChartFinal({@required this.data});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<ChartData, String>> series = [
      charts.Series(
          id: "Depth",
          data: data,
          domainFn: (ChartData series, _) => series.x,
          measureFn: (ChartData series, _) => series.y,
          colorFn: (ChartData series, _) => series.barColor)
    ];

    return Container(
      height: 400,
      padding: EdgeInsets.all(20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(
                "Depth of Water in Tank (Scroll right)",
                style: Theme.of(context).textTheme.body2,
              ),
              Text(
                "Maximum Depth: 250",
                style: Theme.of(context).textTheme.body2,
              ),
              Expanded(
                child: charts.BarChart(
                  series,
                  animate: true,
                  domainAxis: new charts.OrdinalAxisSpec(
                    viewport: new charts.OrdinalViewport('AePS', 3),
                    renderSpec: charts.SmallTickRendererSpec(
                      //
                      // Rotation Here,
                      labelRotation: 45,
                    ),
                  ),
                  behaviors: [
                    new charts.SeriesLegend(),
                    new charts.SlidingViewport(),
                    new charts.PanAndZoomBehavior(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
