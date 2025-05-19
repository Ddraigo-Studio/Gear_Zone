import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../model/dashboard_model.dart';
import '../components/chart_widgets.dart';

/// A reusable revenue chart widget
class RevenueChart extends StatelessWidget {
  final DashboardModel model;
  final Function(String) onExportRequested;
  
  const RevenueChart({
    Key? key,
    required this.model,
    required this.onExportRequested,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 20.0),child: Column(
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
          'Doanh thu',
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
          color: Color(0xFFBCFF5C),
          label: 'Giá trị bán trung bình',
        ),
        ChartLegendItem(
          color: Colors.purple,
          label: 'Giá bán trung bình của một mặt hàng',
        ),
      ],
    );
  }
    Widget _buildChartArea() {
    final formatter = NumberFormat("#,###");
    
    // Generate second line data for average order value
    final orderValueSpots = <FlSpot>[];
    
    // Calculate average order value per period
    for (int i = 0; i < model.revenueByTime.length; i++) {
      final data = model.revenueByTime[i];
      final revenue = data['revenue'] as double? ?? 0.0;
      final orders = data['orders'] as int? ?? 1; // Avoid division by zero
        // Calculate average order value per million
      final avgValue = orders > 0 ? (revenue / orders) / 1000000 : 0.0;
      orderValueSpots.add(FlSpot(i.toDouble(), avgValue.toDouble()));
    }
    
    return SizedBox(
      height: 280,
      child: model.revenueSpots.isNotEmpty ? Stack(
        children: [
          // Left info box
          Row(
            children: [
              ChartInfoBox(
                label: 'Giá bán trung bình của một mặt hàng',
                value: '₫ ${formatter.format(model.overallStats['averageOrderValue'] ?? 0)}',
              ),
            ],
          ),
          
          // Right info box
          Positioned(
            right: 0,
            child: ChartInfoBox(
              isRight: true,
              hasBorder: false,
              color: const Color(0xFFBCFF5C),
              label: 'Giá trị bán trung bình',
              value: '₫ ${formatter.format((model.overallStats['totalRevenue'] ?? 0) / 1000000)}M',
            ),
          ),
          
          // Actual chart
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),            child: LineChart(
              getLineChartData(
                spots: model.revenueSpots,
                labels: model.periodLabels,
                lineColor: const Color(0xFFBCFF5C),
                secondLineColor: Colors.purple[300]!,
                showGrid: true,
                secondLineSpots: orderValueSpots,
                firstLineName: 'Doanh thu',
                secondLineName: 'Giá bán TB/đơn',
                valuePrefix: '₫',
                valueSuffix: 'M',
              ),
            ),
          ),
        ],
      ) : const Center(child: Text('Không có dữ liệu')),
    );
  }
}
