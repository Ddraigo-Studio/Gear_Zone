import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../model/dashboard_model.dart';
import '../components/chart_widgets.dart';

/// A reusable profit chart widget
class ProfitChart extends StatelessWidget {
  final DashboardModel model;
  final Function(String) onExportRequested;
  
  const ProfitChart({
    Key? key,
    required this.model,
    required this.onExportRequested,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 30),
            _buildLegend(),
            const SizedBox(height: 25),
            _buildChartArea(),
            const SizedBox(height: 16),
            PeriodLabelsDisplay(labels: model.periodLabels),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Lợi nhuận',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.table_chart),
          onPressed: () => onExportRequested('Excel'),
        ),
      ],
    );
  }
  
  Widget _buildLegend() {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: const [
        ChartLegendItem(
          color: Color(0xFF66BB6A),
          label: 'Lợi nhuận',
        ),
        ChartLegendItem(
          color: Colors.orange,
          label: 'Tỷ suất lợi nhuận',
        ),
      ],
    );
  }
  
  Widget _buildChartArea() {
    final formatter = NumberFormat("#,###");
    
    // Calculate profit based on revenue data
    final profitSpots = <FlSpot>[];
    final profitMarginSpots = <FlSpot>[];
    
    for (int i = 0; i < model.revenueByTime.length; i++) {
      final data = model.revenueByTime[i];
      final profit = data['profit'] ?? 0.0;
      final revenue = data['revenue'] ?? 1.0; // Avoid division by zero
      
      profitSpots.add(FlSpot(i.toDouble(), profit / 1000000)); // Convert to millions
      
      // Calculate profit margin (profit / revenue) * 100
      final profitMargin = (profit / revenue) * 100;
      profitMarginSpots.add(FlSpot(i.toDouble(), profitMargin));
    }
    
    return SizedBox(
      height: 250,
      child: model.revenueByTime.isNotEmpty ? Stack(
        children: [
          // Left info box
          Row(
            children: [
              ChartInfoBox(
                label: 'Tỷ suất lợi nhuận trung bình',
                value: '${formatter.format(calculateAverageProfitMargin(model.revenueByTime))}%',
                color: Colors.orange,
              ),
            ],
          ),
          
          // Right info box
          Positioned(
            right: 0,
            child: ChartInfoBox(
              isRight: true,
              color: const Color(0xFF66BB6A),
              label: 'Tổng lợi nhuận',
              value: '₫ ${formatter.format((model.overallStats['totalProfit'] ?? 0) / 1000000)}M',
            ),
          ),
          
          // Actual chart
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: LineChart(
              getDoubleLineChartData(
                firstSpots: profitSpots,
                secondSpots: profitMarginSpots,
                labels: model.periodLabels,
                firstLineColor: const Color(0xFF66BB6A), 
                secondLineColor: Colors.orange,
                showLeftTitles: true,
                showRightTitles: true,
                leftTitle: 'Lợi nhuận (triệu đồng)',
                rightTitle: 'Tỷ suất lợi nhuận (%)',
              ),
            ),
          ),
        ],
      ) : const Center(child: Text('Không có dữ liệu')),
    );
  }
  
  // Helper method to calculate average profit margin
  double calculateAverageProfitMargin(List<Map<String, dynamic>> data) {
    if (data.isEmpty) return 0.0;
    
    double sum = 0.0;
    for (final item in data) {
      final profit = item['profit'] as double? ?? 0.0;
      final revenue = item['revenue'] as double? ?? 1.0; // Avoid division by zero
      sum += (profit / revenue) * 100;
    }
    
    return sum / data.length;
  }
}
