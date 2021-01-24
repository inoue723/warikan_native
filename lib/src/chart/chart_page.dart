import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Text(
            "分析",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "1月",
            style: TextStyle(fontSize: 20),
          ),
          PieChart(
            PieChartData(
              borderData: FlBorderData(show: false),
              sectionsSpace: 0,
              centerSpaceRadius: 0,
              startDegreeOffset: 270,
              sections: [
                PieChartSectionData(
                  value: 94500,
                  title: "家賃",
                  radius: 100,
                  color: Colors.blueGrey,
                ),
                PieChartSectionData(
                  value: 23000,
                  title: "食費",
                  radius: 100,
                  color: Colors.deepPurple,
                ),
                PieChartSectionData(
                  value: 20000,
                  title: "娯楽",
                  radius: 100,
                  color: Colors.cyan,
                ),
                PieChartSectionData(
                  value: 10000,
                  title: "光熱費",
                  radius: 100,
                  color: Colors.deepOrange,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
