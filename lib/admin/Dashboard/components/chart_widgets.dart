import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../model/dashboard_model.dart';
import 'dart:math';

/// A collection of reusable chart widgets for dashboard

/// Legend item widget
class ChartLegendItem extends StatelessWidget {
  final Color color;
  final String label;
  
  const ChartLegendItem({
    Key? key,
    required this.color,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}

/// Info box widget
class ChartInfoBox extends StatelessWidget {
  final bool isRight;
  final Color color;
  final bool hasBorder;
  final String label;
  final String value;
  final Color textColor;
  
  const ChartInfoBox({
    Key? key,
    required this.label,
    required this.value,
    this.isRight = false,
    this.hasBorder = true,
    this.color = Colors.white,
    this.textColor = Colors.black87,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color,
        border: hasBorder ? Border.all(color: Colors.blue.shade100) : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 10, color: isRight ? Colors.black87 : Colors.grey),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// Line chart data generator
LineChartData getLineChartData({
  required List<FlSpot> spots,
  required List<String> labels,
  Color lineColor = const Color(0xFFBCFF5C),
  bool showSecondLine = true,
  Color secondLineColor = Colors.purpleAccent,
  bool showGrid = false,
}) {
  return LineChartData(
    gridData: FlGridData(show: showGrid),
    titlesData: FlTitlesData(
      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
    ),
    borderData: FlBorderData(show: false),
    minX: 0,
    maxX: (labels.length - 1).toDouble(),
    minY: 0,
    maxY: spots.isEmpty ? 10 : spots.map((spot) => spot.y).reduce(max) * 1.2,
    lineBarsData: [
      // First line
      LineChartBarData(
        spots: spots,
        isCurved: true,
        color: lineColor,
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
      ),
      // Second line (optional)
      if (showSecondLine)
        LineChartBarData(
          spots: const [
            FlSpot(0, 1),
            FlSpot(1, 1.2),
            FlSpot(2, 1),
            FlSpot(3, 1.5),
            FlSpot(4, 1.3),
            FlSpot(5, 1.8),
            FlSpot(6, 1.7),
            FlSpot(7, 2),
            FlSpot(8, 2.2),
            FlSpot(9, 2.1),
            FlSpot(10, 2.3),
            FlSpot(11, 2.4),
          ],
          isCurved: true,
          color: secondLineColor,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
        ),
    ],
    lineTouchData: LineTouchData(enabled: false),
  );
}

/// Comparison chart data generator
LineChartData getComparisonChartData({
  required List<FlSpot> currentSpots,
  required List<FlSpot> previousSpots,
  required List<String> labels,
  Color currentColor = const Color(0xFFBCFF5C),
  Color previousColor = Colors.purpleAccent,
  bool showGrid = false,
}) {
  // Calculate max Y value
  double maxY = 0;
  for (var spot in currentSpots) {
    if (spot.y > maxY) maxY = spot.y;
  }
  for (var spot in previousSpots) {
    if (spot.y > maxY) maxY = spot.y;
  }
  maxY = maxY * 1.2; // Add 20% margin
  
  return LineChartData(
    gridData: FlGridData(show: showGrid),
    titlesData: FlTitlesData(
      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
    ),
    borderData: FlBorderData(show: false),
    minX: 0,
    maxX: (labels.length - 1).toDouble(),
    minY: 0,
    maxY: maxY,
    lineBarsData: [
      // Current period data line
      LineChartBarData(
        spots: currentSpots,
        isCurved: true,
        color: currentColor,
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
      ),
      // Previous period data line
      LineChartBarData(
        spots: previousSpots,
        isCurved: true,
        color: previousColor,
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
      ),
    ],
    lineTouchData: LineTouchData(enabled: false),
  );
}

/// Month labels display widget
class PeriodLabelsDisplay extends StatelessWidget {
  final List<String> labels;
  
  const PeriodLabelsDisplay({
    Key? key,
    required this.labels,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: labels.map((label) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        )).toList(),
      ),
    );
  }
}

/// Double line chart with dual Y-axes (left and right)
LineChartData getDoubleLineChartData({
  required List<FlSpot> firstSpots,
  required List<FlSpot> secondSpots,
  required List<String> labels,
  Color firstLineColor = const Color(0xFF66BB6A),
  Color secondLineColor = Colors.orange,
  bool showGrid = false,
  bool showLeftTitles = false,
  bool showRightTitles = false,
  String leftTitle = '',
  String rightTitle = '',
}) {
  // Calculate max Y values for both axes
  double maxY1 = 0;
  for (var spot in firstSpots) {
    if (spot.y > maxY1) maxY1 = spot.y;
  }
  maxY1 = maxY1 * 1.2; // Add 20% margin
  
  double maxY2 = 0;
  for (var spot in secondSpots) {
    if (spot.y > maxY2) maxY2 = spot.y;
  }
  maxY2 = maxY2 * 1.2; // Add 20% margin
  
  return LineChartData(
    gridData: FlGridData(show: showGrid),
    titlesData: FlTitlesData(
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: showLeftTitles,
          getTitlesWidget: (value, meta) {
            if (value == 0) {
              return const Text('');
            }
            return Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Text(value.toStringAsFixed(0), style: TextStyle(color: firstLineColor, fontSize: 10)),
            );
          },
          reservedSize: 40,
        ),
        axisNameWidget: showLeftTitles 
          ? Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(leftTitle, style: TextStyle(color: firstLineColor, fontSize: 10)),
            ) 
          : null,
      ),
      rightTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: showRightTitles,
          getTitlesWidget: (value, meta) {
            if (value == 0) {
              return const Text('');
            }
            return Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text('${value.toStringAsFixed(0)}%', style: TextStyle(color: secondLineColor, fontSize: 10)),
            );
          },
          reservedSize: 40,
        ),
        axisNameWidget: showRightTitles 
          ? Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(rightTitle, style: TextStyle(color: secondLineColor, fontSize: 10)),
            ) 
          : null,
      ),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    ),
    borderData: FlBorderData(show: false),
    minX: 0,
    maxX: (labels.length - 1).toDouble(),
    minY: 0,
    maxY: maxY1,
    lineTouchData: LineTouchData(
      touchTooltipData: LineTouchTooltipData(
        tooltipBgColor: Colors.white.withOpacity(0.8),
        getTooltipItems: (List<LineBarSpot> touchedSpots) {
          return touchedSpots.map((spot) {
            final index = spot.spotIndex;
            final isFirstLine = spot.barIndex == 0;
            final color = isFirstLine ? firstLineColor : secondLineColor;
            final label = isFirstLine ? 'Lợi nhuận: ${NumberFormat("#,###").format(spot.y)}M' 
                                     : 'Tỷ suất: ${spot.y.toStringAsFixed(1)}%';
            
            return LineTooltipItem(
              '${labels[index]}\n$label',
              TextStyle(color: color, fontWeight: FontWeight.bold),
            );
          }).toList();
        },
      ),
    ),
    lineBarsData: [
      // First line data (left axis)
      LineChartBarData(
        spots: firstSpots,
        isCurved: true,
        color: firstLineColor,
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: true,
          getDotPainter: (spot, percent, barData, index) {
            return FlDotCirclePainter(
              radius: 4,
              color: firstLineColor,
              strokeWidth: 1,
              strokeColor: Colors.white,
            );
          },
        ),
        belowBarData: BarAreaData(
          show: true,
          color: firstLineColor.withOpacity(0.2),
        ),
      ),
      // Second line data (right axis) - needs to be scaled to left axis
      LineChartBarData(
        spots: secondSpots.map((spot) => 
          // Scale the Y value from the second axis range to the first axis range
          FlSpot(spot.x, (spot.y / maxY2) * maxY1)
        ).toList(),
        isCurved: true,
        color: secondLineColor,
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: true,
          getDotPainter: (spot, percent, barData, index) {
            return FlDotCirclePainter(
              radius: 3,
              color: secondLineColor,
              strokeWidth: 1,
              strokeColor: Colors.white,
            );
          },
        ),
        dashArray: [5, 2], // Dashed line
        belowBarData: BarAreaData(show: false),
      ),
    ],
  );
}
