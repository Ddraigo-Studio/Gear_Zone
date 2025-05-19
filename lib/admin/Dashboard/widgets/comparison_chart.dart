import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../model/dashboard_model.dart';
import '../components/chart_widgets.dart';
import '../components/time_filter.dart';

/// A reusable comparison chart widget
class ComparisonChart extends StatelessWidget {
  final DashboardModel model;
  
  const ComparisonChart({
    Key? key,
    required this.model,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildLegend(),
            const SizedBox(height: 16),
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
        Text(
          'So sánh: ${getCurrentPeriodDisplay(model)} vs ${model.comparisonPeriod}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        DropdownButton<String>(
          value: 'Doanh thu',
          items: const [
            DropdownMenuItem(value: 'Doanh thu', child: Text('Doanh thu')),
            DropdownMenuItem(value: 'Lợi nhuận', child: Text('Lợi nhuận')),
            DropdownMenuItem(value: 'Số lượng sản phẩm', child: Text('Số lượng sản phẩm')),
            DropdownMenuItem(value: 'Loại sản phẩm', child: Text('Loại sản phẩm')),
          ],
          onChanged: (_) {}, // In a real app, this would change the chart data
        ),
      ],
    );
  }
  
  Widget _buildLegend() {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        ChartLegendItem(
          color: const Color(0xFFBCFF5C),
          label: getCurrentPeriodDisplay(model),
        ),
        ChartLegendItem(
          color: Colors.purple[300]!,
          label: model.comparisonPeriod,
        ),
      ],
    );
  }
  
  Widget _buildChartArea() {
    final formatter = NumberFormat("#,###");
    
    return SizedBox(
      height: 250,
      child: model.revenueSpots.isNotEmpty && model.previousRevenueSpots.isNotEmpty
        ? Stack(
            children: [
              // Left info box for previous period
              Row(
                children: [
                  ChartInfoBox(
                    label: model.comparisonPeriod,
                    value: '₫ ${formatter.format((model.comparisonData.isNotEmpty ? model.comparisonData.first['totalRevenue'] : 0) / 1000000)}M',
                  ),
                ],
              ),
              
              // Right info box for current period
              Positioned(
                right: 0,
                child: ChartInfoBox(
                  isRight: true,
                  hasBorder: false,
                  color: const Color(0xFFBCFF5C),
                  label: getCurrentPeriodDisplay(model),
                  value: '₫ ${formatter.format((model.overallStats['totalRevenue'] ?? 0) / 1000000)}M',
                ),
              ),
              
              // Actual chart
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: LineChart(
                  getComparisonChartData(
                    currentSpots: model.revenueSpots,
                    previousSpots: model.previousRevenueSpots,
                    labels: model.periodLabels,
                    currentColor: const Color(0xFFBCFF5C),
                    previousColor: Colors.purple[300]!,
                  ),
                ),
              ),
            ],
          )
        : const Center(child: Text('Không có dữ liệu so sánh')),
    );
  }
}
