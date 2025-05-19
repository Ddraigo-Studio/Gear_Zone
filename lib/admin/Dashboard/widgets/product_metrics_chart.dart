import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../model/dashboard_model.dart';
import '../components/chart_widgets.dart';

/// A widget for showing product metrics - product counts and types
class ProductMetricsChart extends StatelessWidget {
  final DashboardModel model;
  
  const ProductMetricsChart({
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
          'Thống kê sản phẩm',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        DropdownButton<String>(
          value: 'Số lượng & loại',
          items: const [
            DropdownMenuItem(value: 'Số lượng & loại', child: Text('Số lượng & loại')),
            DropdownMenuItem(value: 'Số lượng', child: Text('Số lượng')),
            DropdownMenuItem(value: 'Loại sản phẩm', child: Text('Loại sản phẩm')),
          ],
          onChanged: (_) {}, // In a real app, this would change the data displayed
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
          color: Color(0xFF42A5F5),
          label: 'Số lượng sản phẩm',
        ),
        ChartLegendItem(
          color: Color(0xFFFFA726),
          label: 'Loại sản phẩm',
        ),
      ],
    );
  }
  
  Widget _buildChartArea() {
    final formatter = NumberFormat("#,###");
    
    // Create chart data from the revenueByTime data
    final productCountSpots = <FlSpot>[];
    final productTypeSpots = <FlSpot>[];
    
    double totalProducts = 0;
    double totalTypes = 0;
    
    for (int i = 0; i < model.revenueByTime.length; i++) {
      final data = model.revenueByTime[i];
      final productCount = (data['productCount'] as num?)?.toDouble() ?? 0;
      final productTypes = (data['productTypes'] as num?)?.toDouble() ?? 0;
      
      productCountSpots.add(FlSpot(i.toDouble(), productCount));
      productTypeSpots.add(FlSpot(i.toDouble(), productTypes));
      
      totalProducts += productCount;
      totalTypes += productTypes;
    }
    
    // Calculate averages
    final avgProductCount = model.revenueByTime.isNotEmpty ? totalProducts / model.revenueByTime.length : 0;
    final avgProductTypes = model.revenueByTime.isNotEmpty ? totalTypes / model.revenueByTime.length : 0;
      return SizedBox(
      height: 280,
      child: model.revenueByTime.isNotEmpty ? Stack(
        children: [
          // Left info box
          Row(
            children: [
              ChartInfoBox(
                label: 'Số lượng trung bình',
                value: formatter.format(avgProductCount),
                color: const Color(0xFF42A5F5),
              ),
            ],
          ),
          
          // Right info box
          Positioned(
            right: 0,
            child: ChartInfoBox(
              isRight: true,
              color: const Color(0xFFFFA726),
              label: 'Loại sản phẩm trung bình',
              value: formatter.format(avgProductTypes),
            ),
          ),
          
          // Actual chart
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),            child: LineChart(
              getDoubleLineChartData(
                firstSpots: productCountSpots,
                secondSpots: productTypeSpots,
                labels: model.periodLabels,
                firstLineColor: const Color(0xFF42A5F5),
                secondLineColor: const Color(0xFFFFA726),
                showGrid: true,
                showLeftTitles: true,
                showRightTitles: true,
                leftTitle: 'Số lượng sản phẩm',
                rightTitle: 'Loại sản phẩm',
                firstLineName: 'Số lượng sản phẩm',
                secondLineName: 'Loại sản phẩm',
                firstValueSuffix: '',
                secondValueSuffix: '',
              ),
            ),
          ),
        ],
      ) : const Center(child: Text('Không có dữ liệu')),
    );
  }
}
