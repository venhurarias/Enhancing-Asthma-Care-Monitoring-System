import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';


class MyLineGraph extends StatelessWidget {
  const MyLineGraph({Key? key, required this.list, required this.maxY}) : super(key: key);
  final List<int> list;
  final double maxY;
  @override
  Widget build(BuildContext context) {
    String formatTimestamp(int timestamp) {
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      return DateFormat('MM/dd/yyyy HH:mm:ss').format(dateTime);
    }

    Widget leftTitleWidgets(double value, TitleMeta meta) {
      const style = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 15,
      );
      String text;
      switch (value.toInt()) {
        case 1:
          text = '10K';
          break;
        case 3:
          text = '30k';
          break;
        case 5:
          text = '50k';
          break;
        default:
          return Container();
      }

      return Text(text, style: style, textAlign: TextAlign.left);
    }
    List<Color> gradientColors = [
      primaryColor,
      Colors.black,
    ];




    return LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,

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
                showTitles: false,
                // getTitlesWidget: bottomTitleWidgets,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                // getTitlesWidget: leftTitleWidgets,
                reservedSize: 42,
              ),
            ),
          ),
          minX: 0,
          maxX: list.length.toDouble() - 1,
          minY: 0,
          maxY: maxY,
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                list.length,
                    (index) => FlSpot(index.toDouble(), list[index].toDouble()),
              ),
              isCurved: true,
              gradient: LinearGradient(
                colors: gradientColors,
              ),
              isStrokeCapRound: true,
              dotData: const FlDotData(
                show: false,
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: gradientColors
                      .map((color) => color.withOpacity(0.3))
                      .toList(),
                ),
              ),
            ),
          ],
        )
    );

  }
  }

