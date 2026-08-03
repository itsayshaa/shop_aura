import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';

class SalesChart extends StatelessWidget {
  const SalesChart({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.6,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: 6,
          minY: 0,
          maxY: 8,

          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
          ),

          borderData: FlBorderData(
            show: false,
          ),

          titlesData: FlTitlesData(
            topTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),

            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 2,
                reservedSize: 30,
              ),
            ),

            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const months = [
                    "Jan",
                    "Feb",
                    "Mar",
                    "Apr",
                    "May",
                    "Jun",
                    "Jul"
                  ];

                  return Text(
                    months[value.toInt()],
                    style: const TextStyle(fontSize: 11),
                  );
                },
              ),
            ),
          ),

          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              color: AppColors.primary,
              barWidth: 4,

              dotData: const FlDotData(show: true),

              belowBarData: BarAreaData(
                show: true,
                color: AppColors.primary.withOpacity(.15),
              ),

              spots: const [
                FlSpot(0, 2),
                FlSpot(1, 3),
                FlSpot(2, 5),
                FlSpot(3, 4),
                FlSpot(4, 6),
                FlSpot(5, 5),
                FlSpot(6, 7),
              ],
            ),
          ],
        ),
      ),
    );
  }
}