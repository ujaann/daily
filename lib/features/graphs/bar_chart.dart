import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartSample2 extends StatefulWidget {
  const BarChartSample2(
      {super.key,
      required this.sunday,
      required this.monday,
      required this.tuesday,
      required this.wednesday,
      required this.thursday,
      required this.friday,
      required this.saturday});

  final Color leftBarColor = Colors.red;
  final Color rightBarColor = Colors.green;
  final Color avgColor = Colors.orange;
  final (double, double) sunday;
  final (double, double) monday;
  final (double, double) tuesday;
  final (double, double) wednesday;
  final (double, double) thursday;
  final (double, double) friday;
  final (double, double) saturday;
  @override
  State<StatefulWidget> createState() => BarChartSample2State();
}

class BarChartSample2State extends State<BarChartSample2> {
  final double width = 7;

  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex = -1;
  double computedMaxY = 0;
  @override
  void initState() {
    super.initState();
    final allValues = [
      widget.sunday,
      widget.monday,
      widget.tuesday,
      widget.wednesday,
      widget.thursday,
      widget.friday,
      widget.saturday,
    ];

    // Find the max y value among all pairs
    final maxVal = allValues
        .expand((pair) => [pair.$1, pair.$2])
        .reduce((a, b) => a > b ? a : b);

    computedMaxY = (maxVal * 1.1).ceilToDouble(); // add 10% buffer

    final barGroup1 = makeGroupData(0, widget.sunday.$1, widget.sunday.$2);
    final barGroup2 = makeGroupData(1, widget.monday.$1, widget.monday.$2);
    final barGroup3 = makeGroupData(2, widget.tuesday.$1, widget.tuesday.$2);
    final barGroup4 =
        makeGroupData(3, widget.wednesday.$1, widget.wednesday.$2);
    final barGroup5 = makeGroupData(4, widget.thursday.$1, widget.thursday.$2);
    final barGroup6 = makeGroupData(5, widget.friday.$1, widget.friday.$2);
    final barGroup7 = makeGroupData(6, widget.saturday.$1, widget.saturday.$2);

    final items = [
      barGroup1,
      barGroup2,
      barGroup3,
      barGroup4,
      barGroup5,
      barGroup6,
      barGroup7,
    ];

    rawBarGroups = items;

    showingBarGroups = rawBarGroups;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(
                  width: 38,
                ),
                const Text(
                  'Weekly expenses',
                  style: TextStyle(fontSize: 22),
                ),
                const SizedBox(
                  width: 4,
                ),
              ],
            ),
            const SizedBox(
              height: 38,
            ),
            Expanded(
              child: BarChart(
                BarChartData(
                  maxY: computedMaxY,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: ((group) {
                        return Colors.grey;
                      }),
                      getTooltipItem: (a, b, c, d) => null,
                    ),
                    touchCallback: (FlTouchEvent event, response) {
                      if (response == null || response.spot == null) {
                        setState(() {
                          touchedGroupIndex = -1;
                          showingBarGroups = List.of(rawBarGroups);
                        });
                        return;
                      }

                      touchedGroupIndex = response.spot!.touchedBarGroupIndex;

                      setState(() {
                        if (!event.isInterestedForInteractions) {
                          touchedGroupIndex = -1;
                          showingBarGroups = List.of(rawBarGroups);
                          return;
                        }
                        showingBarGroups = List.of(rawBarGroups);
                        if (touchedGroupIndex != -1) {
                          final group = showingBarGroups[touchedGroupIndex];
                          final yValues =
                              group.barRods.map((rod) => rod.toY).toList();
                          if (yValues.length == 2) {
                            final balance = (yValues[0] - yValues[1]).abs();

                            showingBarGroups[touchedGroupIndex] =
                                group.copyWith(
                              barRods: [
                                BarChartRodData(
                                  toY: balance,
                                  color: widget.avgColor,
                                  width: width,
                                ),
                              ],
                            );
                          }
                        }
                      });
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: bottomTitles,
                        reservedSize: 42,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        interval: 1,
                        getTitlesWidget: leftTitles,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: showingBarGroups,
                  gridData: const FlGridData(show: false),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    if (value % (computedMaxY ~/ 5) != 0) return Container();

    final label = value >= 1000
        ? '${(value / 1000).toStringAsFixed(0)}K'
        : '${value.toInt()}';

    return SideTitleWidget(
      meta: meta,
      space: 0,
      child: Text(label, style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final titles = <String>['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];

    final Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      meta: meta,
      space: 16, //margin top
      child: text,
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: widget.leftBarColor,
          width: width,
        ),
        BarChartRodData(
          toY: y2,
          color: widget.rightBarColor,
          width: width,
        ),
      ],
    );
  }

  Widget makeTransactionsIcon() {
    const width = 4.5;
    const space = 3.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: width,
          height: 10,
          color: Colors.white.withValues(alpha: 0.4),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withValues(alpha: 0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 42,
          color: Colors.white.withValues(alpha: 1),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withValues(alpha: 0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 10,
          color: Colors.white.withValues(alpha: 0.4),
        ),
      ],
    );
  }
}
