import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../model/dashboard_model.dart';
import 'dart:math' as math;

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
  bool showGrid = true,
  List<FlSpot>? secondLineSpots,
  String firstLineName = 'Doanh thu',
  String secondLineName = 'Giá bán TB',
  String valuePrefix = '₫',
  String valueSuffix = 'M',
}) {
  double maxYValue = spots.isEmpty ? 10.0 : spots.map((spot) => spot.y).reduce(math.max);

  if (showSecondLine && secondLineSpots != null && secondLineSpots.isNotEmpty) {
    final secondMax = secondLineSpots.map((spot) => spot.y).reduce(math.max);
    maxYValue = math.max(maxYValue, secondMax);
  }

  maxYValue *= 1.2;
  if (maxYValue == 0.0) {
    maxYValue = 1.2; // Default height if chart would be flat at 0
  }

  return LineChartData(
    gridData: FlGridData(
      show: showGrid,
      drawVerticalLine: true,
      drawHorizontalLine: true,
      horizontalInterval: maxYValue > 0 ? maxYValue / 5 : 1,
      getDrawingHorizontalLine: (value) => FlLine(
        color: Colors.grey.shade200,
        strokeWidth: 1,
      ),
      getDrawingVerticalLine: (value) => FlLine(
        color: Colors.grey.shade200,
        strokeWidth: 1,
      ),
    ),
    titlesData: FlTitlesData(
      leftTitles: AxisTitles(
        axisNameWidget: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            firstLineName,
            style: TextStyle(fontSize: 10, color: lineColor),
          ),
        ),
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            if (value == 0 || value % (maxYValue / 5) != 0) return const SizedBox(); // Ensure maxY is not 0 for division
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                value.toStringAsFixed(1),
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            );
          },
          reservedSize: 40,
        ),
      ),
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            if (value % 1 != 0 || value < 0 || value >= labels.length) {
              return const SizedBox();
            }
            final index = value.toInt();
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                labels[index],
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            );
          },
        ),
      ),
    ),
    borderData: FlBorderData(
      show: true,
      border: Border(
        bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        left: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
    ),
    minX: 0,
    maxX: labels.length > 1 ? (labels.length - 1).toDouble() : 1.0,
    minY: 0,
    maxY: maxYValue,
    lineBarsData: [
      // First line
      LineChartBarData(
        spots: spots,
        isCurved: true,
        color: lineColor,
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: true,
          getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
            radius: 4,
            color: lineColor,
            strokeWidth: 1,
            strokeColor: Colors.white,
          ),
        ),        belowBarData: BarAreaData(
          show: true,
          color: lineColor.withOpacity(0.2),
        ),
      ),
      // Second line (optional)
      if (showSecondLine)
        LineChartBarData(
          spots: secondLineSpots ?? const [
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
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
              radius: 4,
              color: secondLineColor,
              strokeWidth: 1,
              strokeColor: Colors.white,
            ),
          ),
          belowBarData: BarAreaData(show: false),
        ),
    ],
    lineTouchData: LineTouchData(
      touchTooltipData: LineTouchTooltipData(
        tooltipBgColor: Colors.white.withOpacity(0.9),
        tooltipPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        tooltipMargin: 8,
        tooltipRoundedRadius: 8,
        getTooltipItems: (List<LineBarSpot> touchedSpots) {
          return touchedSpots.map((spot) {
            final index = spot.spotIndex;
            final periodLabel = index < labels.length ? labels[index] : '';
            final isFirstLine = spot.barIndex == 0;
            final color = isFirstLine ? lineColor : secondLineColor;
            final name = isFirstLine ? firstLineName : secondLineName;
            
            return LineTooltipItem(
              '$periodLabel\n$name: $valuePrefix ${NumberFormat("#,###.##").format(spot.y)}$valueSuffix',
              TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            );
          }).toList();
        },
      ),
      handleBuiltInTouches: true,
      enabled: true,
      touchSpotThreshold: 20,
    ),
  );
}

/// Comparison chart data generator
LineChartData getComparisonChartData({
  required List<FlSpot> currentSpots,
  required List<FlSpot> previousSpots,
  required List<String> labels,
  Color currentColor = const Color(0xFFBCFF5C),
  Color previousColor = Colors.purpleAccent,
  bool showGrid = true,
}) {
  double maxY = 0;
  if (currentSpots.isNotEmpty) {
    maxY = math.max(maxY, currentSpots.map((spot) => spot.y).reduce(math.max));
  }
  if (previousSpots.isNotEmpty) {
    maxY = math.max(maxY, previousSpots.map((spot) => spot.y).reduce(math.max));
  }

  maxY = maxY * 1.2;
  if (maxY == 0.0) {
    maxY = 1.2;
  }

  return LineChartData(
    gridData: FlGridData(
      show: showGrid,
      drawVerticalLine: true,
      drawHorizontalLine: true,
      getDrawingHorizontalLine: (value) => FlLine(
        color: Colors.grey.shade200,
        strokeWidth: 1,
      ),
      getDrawingVerticalLine: (value) => FlLine(
        color: Colors.grey.shade200,
        strokeWidth: 1,
      ),
    ),
    titlesData: FlTitlesData(
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            if (maxY == 0) return const SizedBox(); // Prevent division by zero if maxY is 0
            if (value == 0 || value % (maxY / 5) != 0) return const SizedBox();
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                value.toStringAsFixed(1),
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            );
          },
          reservedSize: 40,
        ),
      ),
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            if (value % 1 != 0 || value < 0 || value >= labels.length) {
              return const SizedBox();
            }
            final index = value.toInt();
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                labels[index],
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            );
          },
        ),
      ),
    ),
    borderData: FlBorderData(
      show: true,
      border: Border(
        bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        left: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
    ),
    minX: 0,
    maxX: labels.length > 1 ? (labels.length - 1).toDouble() : 1.0,
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
        dotData: FlDotData(
          show: true,
          getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
            radius: 4,
            color: currentColor,
            strokeWidth: 1,
            strokeColor: Colors.white,
          ),
        ),
        belowBarData: BarAreaData(
          show: true,
          color: currentColor.withOpacity(0.1),
        ),
      ),
      // Previous period data line
      LineChartBarData(
        spots: previousSpots,
        isCurved: true,
        color: previousColor,
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: true,
          getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
            radius: 4,
            color: previousColor,
            strokeWidth: 1,
            strokeColor: Colors.white,
          ),
        ),
        belowBarData: BarAreaData(show: false),
      ),
    ],    lineTouchData: LineTouchData(
      enabled: true,
      touchTooltipData: LineTouchTooltipData(
        tooltipBgColor: Colors.white.withOpacity(0.9),
        tooltipPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        tooltipMargin: 8,
        tooltipRoundedRadius: 8,
        getTooltipItems: (List<LineBarSpot> touchedSpots) {
          return touchedSpots.map((spot) {
            final index = spot.spotIndex;
            final isCurrentPeriod = spot.barIndex == 0;
            final color = isCurrentPeriod ? currentColor : previousColor;
            final periodName = index < labels.length ? labels[index] : "";
            final periodType = isCurrentPeriod ? "Hiện tại" : "Kỳ trước";
            
            return LineTooltipItem(
              '$periodName\n$periodType: ₫ ${NumberFormat("#,###.##").format(spot.y)}M',
              TextStyle(
                color: color, 
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            );
          }).toList();
        },
      ),
      handleBuiltInTouches: true,
      touchSpotThreshold: 20,
    ),
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
  bool showGrid = true,
  bool showLeftTitles = false,
  bool showRightTitles = false,
  String leftTitle = '',
  String rightTitle = '',
  String firstLineName = 'Lợi nhuận',
  String secondLineName = 'Tỷ suất',
  String firstValueSuffix = 'M',
  String firstValuePrefix = '',
  String secondValueSuffix = '%',
  String secondValuePrefix = '',
}) {
  double maxY1 = 0;
  if (firstSpots.isNotEmpty) {
    maxY1 = firstSpots.map((spot) => spot.y).reduce(math.max);
  }
  maxY1 = maxY1 * 1.2;
  if (maxY1 == 0.0) maxY1 = 1.2;

  double maxY2 = 0;
  if (secondSpots.isNotEmpty) {
    maxY2 = secondSpots.map((spot) => spot.y).reduce(math.max);
  }
  maxY2 = maxY2 * 1.2;
  if (maxY2 == 0.0) maxY2 = 1.2;

  return LineChartData(
    gridData: FlGridData(
      show: showGrid,
      drawVerticalLine: true,
      drawHorizontalLine: true,
      horizontalInterval: maxY1 > 0 ? maxY1 / 5 : 1,
      getDrawingHorizontalLine: (value) => FlLine(
        color: Colors.grey.shade200,
        strokeWidth: 1,
      ),
      getDrawingVerticalLine: (value) => FlLine(
        color: Colors.grey.shade200,
        strokeWidth: 1,
      ),
    ),
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
              child: Text(value.toStringAsFixed(1), style: TextStyle(color: firstLineColor, fontSize: 10)),
            );
          },
          reservedSize: 40,
          interval: maxY1 / 5,
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
            // Convert the scaled value back to the actual percentage
            final actualValue = (value / maxY1) * maxY2;
            return Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text('${actualValue.toStringAsFixed(0)}%', style: TextStyle(color: secondLineColor, fontSize: 10)),
            );
          },
          reservedSize: 40,
          interval: maxY1 / 5,
        ),
        axisNameWidget: showRightTitles 
          ? Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(rightTitle, style: TextStyle(color: secondLineColor, fontSize: 10)),
            ) 
          : null,
      ),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            if (value % 1 != 0 || value < 0 || value >= labels.length) {
              return const SizedBox();
            }
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                labels[value.toInt()],
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            );
          },
        ),
      ),
    ),
    borderData: FlBorderData(
      show: true,
      border: Border.all(color: Colors.grey.shade300, width: 1),
    ),
    minX: 0,
    maxX: labels.length > 1 ? (labels.length - 1).toDouble() : 1.0,
    minY: 0,
    maxY: maxY1,
    lineTouchData: LineTouchData(
      enabled: true,
      touchTooltipData: LineTouchTooltipData(
        tooltipBgColor: Colors.white.withOpacity(0.9),
        tooltipPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        tooltipMargin: 8,
        tooltipRoundedRadius: 8,
        getTooltipItems: (List<LineBarSpot> touchedSpots) {
          return touchedSpots.map((spot) {
            final index = spot.spotIndex;
            final isFirstLine = spot.barIndex == 0;
            final color = isFirstLine ? firstLineColor : secondLineColor;
            
            // Get the actual value
            double actualValue = spot.y;
            if (!isFirstLine) {
              // Convert back from scaled value to actual percentage value
              actualValue = (spot.y / maxY1) * maxY2;
            }
            
            final name = isFirstLine ? firstLineName : secondLineName;
            final prefix = isFirstLine ? firstValuePrefix : secondValuePrefix;
            final suffix = isFirstLine ? firstValueSuffix : secondValueSuffix;
            
            final valueDisplay = isFirstLine
                ? '${prefix} ${NumberFormat("#,###.##").format(actualValue)}${suffix}'
                : '${prefix}${actualValue.toStringAsFixed(1)}${suffix}';
            
            final periodName = index < labels.length ? labels[index] : "";
            
            return LineTooltipItem(
              '$periodName\n$name: $valueDisplay',
              TextStyle(
                color: color, 
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            );
          }).toList();
        },
      ),
      handleBuiltInTouches: true,
      touchSpotThreshold: 20,
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
        ),        belowBarData: BarAreaData(
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
