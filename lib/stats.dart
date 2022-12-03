import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fluttermark/user_info.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class StatisticsTab extends StatefulWidget {
  const StatisticsTab({Key? key}) : super(key: key);

  @override
  State<StatisticsTab> createState() => _StatisticsTabState();
}

class _StatisticsTabState extends State<StatisticsTab> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Средняя оценка по группам",
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 300,
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Card(
                        elevation: 8,
                        child: Container(
                          child: const _AvgGroupMark(),
                          margin: const EdgeInsets.only(top: 20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              children: [
                Text(
                  "Количество пятерок по группам",
                  style: Theme.of(context).textTheme.headline4,
                ),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: 300,
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Card(
                      elevation: 8,
                      child: Container(
                        child: _CountGroupMark(),
                        margin: const EdgeInsets.only(top: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(width: 20),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                  Text(
                    "Рейтинг студентов по количеству пятерок",
                    style: Theme.of(context).textTheme.headline4,
                  ),
                const CountStudentMark(),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class CountStudentMark extends StatelessWidget {
  const CountStudentMark({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: Column(
        children: [
          const ListTile(trailing: Text("Кол-во пятерок"), title: Text('Имя'), leading: SizedBox.shrink(),),
          FutureBuilder<List<StudentMarksCountInfo>>(
              future: getMarks(),
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 4,
                          child: ListTile(
                              leading: Text((index+1).toString()),
                              trailing:
                                  Text(snapshot.data![index].count.toString()),
                              title: Text(snapshot.data![index].full_name)),
                        );
                      });
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else {
                  return const CircularProgressIndicator();
                }
              })),
        ],
      ),
    );
  }

  Future<List<StudentMarksCountInfo>> getMarks() async {
    List<StudentMarksCountInfo> output = [];
    var response = await http.post(
        Uri.http('127.0.0.1:3500', '/api/stats/count5bystudent'),
        body: {});
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      var _response = jsonResponse.values.last as List<dynamic>;
      int index = 0;
      for (var item in _response) {
        var temp = item as Map<String, dynamic>;
        output.add(StudentMarksCountInfo(
            count: item['count'], full_name: item['full_name']));
        index = index + 1;
      }
    }
    return output;
  }
}

class StudentMarksCountInfo {
  final int count;

  final String full_name;

  StudentMarksCountInfo({required this.count, required this.full_name});
}

class _AvgGroupMark extends StatelessWidget {
  const _AvgGroupMark();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BarChartGroupData>>(
        future: barGroups,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return BarChart(
              BarChartData(
                  maxY: 5,
                  barTouchData: barTouchData,
                  titlesData: titlesData,
                  borderData: borderData,
                  barGroups: snapshot.data,
                  gridData: FlGridData(show: true),
                  alignment: BarChartAlignment.center,
                  groupsSpace: 100),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.toStringAsFixed(3),
              const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.blue,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = '19-КБ-ПИ1';
        break;
      case 1:
        text = '19-КБ-ПИ2';
        break;
      case 2:
        text = '19-КБ-ПР1';
        break;
      case 3:
        text = '19-КБ-ПР2';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  LinearGradient get _barsGradient => const LinearGradient(
        colors: [
          Colors.lightBlueAccent,
          Colors.blue,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  Future<List<BarChartGroupData>> get barGroups async {
    List<BarChartGroupData> output = [];
    var response = await http
        .post(Uri.http('127.0.0.1:3500', '/api/stats/avgbygroup'), body: {});
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      var _response = jsonResponse.values.last as List<dynamic>;
      int index = 0;
      for (var item in _response) {
        var temp = item as Map<String, dynamic>;
        output.add(BarChartGroupData(x: index, barRods: [
          BarChartRodData(
            toY: temp['AVG'],
            gradient: _barsGradient,
          )
        ]));
        index = index + 1;
      }
    }
    return output;
  }
}

class _CountGroupMark extends StatelessWidget {
  _CountGroupMark();
  late int maxY;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BarChartGroupData>>(
        future: barGroups,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return BarChart(
              BarChartData(
                  barTouchData: barTouchData,
                  titlesData: titlesData,
                  borderData: borderData,
                  barGroups: snapshot.data,
                  gridData: FlGridData(show: true),
                  alignment: BarChartAlignment.center,
                  groupsSpace: 100),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.toStringAsFixed(3),
              const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.blue,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = '19-КБ-ПИ1';
        break;
      case 1:
        text = '19-КБ-ПИ2';
        break;
      case 2:
        text = '19-КБ-ПР1';
        break;
      case 3:
        text = '19-КБ-ПР2';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true, reservedSize: 30),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  LinearGradient get _barsGradient => const LinearGradient(
        colors: [
          Colors.lightBlueAccent,
          Colors.blue,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  Future<List<BarChartGroupData>> get barGroups async {
    List<BarChartGroupData> output = [];
    var response = await http
        .post(Uri.http('127.0.0.1:3500', '/api/stats/count5bygroup'), body: {});
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      var _response = jsonResponse.values.last as List<dynamic>;
      int index = 0;
      for (var item in _response) {
        var temp = item as Map<String, dynamic>;
        output.add(BarChartGroupData(x: index, barRods: [
          BarChartRodData(
            toY: temp['count'],
            gradient: _barsGradient,
          )
        ]));
        index = index + 1;
      }
    }
    return output;
  }
}
