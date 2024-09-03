import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CustomLineGraph extends StatelessWidget {
  final Map<String, int> tasksCompletedPerDay;
  const CustomLineGraph({super.key, required this.tasksCompletedPerDay});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        maxY: tasksCompletedPerDay.values
                .reduce((a, b) => a > b ? a : b)
                .toDouble() +
            1, // Maximum Y based on data
        minX: 0,
        minY: 0,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              interval: 1,
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final day = tasksCompletedPerDay.keys.elementAt(value.toInt());
                return Text(day,
                    style: const TextStyle(color: Colors.grey, fontSize: 12));
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(value.toInt().toString(),
                    style: const TextStyle(color: Colors.grey, fontSize: 12));
              },
            ),
          ),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),

        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 1,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: Colors.grey.withOpacity(0.3), strokeWidth: 1);
          },
          getDrawingVerticalLine: (value) {
            return FlLine(color: Colors.grey.withOpacity(0.3), strokeWidth: 1);
          },
        ),
        lineBarsData: [
          LineChartBarData(
            spots: tasksCompletedPerDay.entries
                .map((entry) => FlSpot(
                      tasksCompletedPerDay.keys
                          .toList()
                          .indexOf(entry.key)
                          .toDouble(),
                      entry.value.toDouble(),
                    ))
                .toList(),
            isCurved: true,
            dotData: FlDotData(show: true),
            color: Colors.blue,
            barWidth: 3,
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Colors.blue.withOpacity(0.3),
                  Colors.blue.withOpacity(0.1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
