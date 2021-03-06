import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:voting/controller/Database.dart';
import 'package:get/get.dart';
import '../widgets/VotingAppBar.dart';

class ResultViewPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ResultViewPageState();
  }
}

class ResultViewPageState extends State<ResultViewPage> {
  // Widget build(BuildContext context) {
  //   return Center(
  //       child: SfCircularChart(
  //           title: ChartTitle(text: 'Sales by sales person'),
  //           legend: Legend(isVisible: true),
  //           series: <PieSeries<_PieData, String>>[
  //         PieSeries<_PieData, String>(
  //             explode: true,
  //             explodeIndex: 0,
  //             dataSource: data,
  //             xValueMapper: (_PieData data, _) => data.xData,
  //             yValueMapper: (_PieData data, _) => data.yData,
  //             dataLabelSettings: DataLabelSettings(isVisible: true)),
  //       ]));
  // }

  @override
  Widget build(BuildContext context) {
    String questionID = Get.arguments;
    return Scaffold(
        appBar: VotingAppBar(
            title: const Text('Results are...'),
            appBar: AppBar(),
            widgets: const <Widget>[Icon(Icons.more_vert)]),
        body: StreamBuilder(
            stream: Database().getAllResultsForQuestion(questionID),
            builder: ((context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                List<_PieData> pieData = <_PieData>[];
                for (int index = 0;
                    index < snapshot.data.docs.length;
                    index++) {
                  DocumentSnapshot documentSnapshot = snapshot.data.docs[index];
                  pieData.add(_PieData(documentSnapshot["answerString"],
                      documentSnapshot["votes"]));
                }
                return SfCircularChart(
                    title: ChartTitle(text: 'Ergebnisse der Umfrage'),
                    legend: Legend(isVisible: true),
                    series: <PieSeries<_PieData, String>>[
                      PieSeries<_PieData, String>(
                          explode: true,
                          explodeIndex: 0,
                          dataSource: pieData,
                          xValueMapper: (_PieData data, _) => data.xData,
                          yValueMapper: (_PieData data, _) => data.yData,
                          dataLabelSettings:
                              DataLabelSettings(isVisible: true)),
                    ]);
              }
              return Center();
            })));
  }
}

class _PieData {
  _PieData(this.xData, this.yData);
  final String xData;
  final num yData;
}
