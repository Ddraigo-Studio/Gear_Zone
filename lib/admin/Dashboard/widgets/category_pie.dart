import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../model/dashboard_model.dart';

/// A reusable pie chart widget for displaying revenue by category
class CategoryPieChart extends StatelessWidget {
  final DashboardModel model;
  final bool isMobile;
  
  const CategoryPieChart({
    Key? key,
    required this.model,
    this.isMobile = false,
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
            _buildContent(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHeader() {
    return const Text(
      'Doanh thu theo danh mục',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }
  
  Widget _buildContent() {
    if (isMobile) {
      return _buildPieChart();
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: _buildPieChart(),
          ),
          const SizedBox(width: 24),
          Expanded(
            flex: 3,
            child: _buildCategoryLegends(),
          ),
        ],
      );
    }
  }
  
  Widget _buildPieChart() {
    return SizedBox(
      height: 250,
      child: model.revenueByCategory.isNotEmpty
          ? PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 50,
                sections: _getPieSections(),
              ),
            )
          : const Center(child: Text('Không có dữ liệu')),
    );
  }
  
  List<PieChartSectionData> _getPieSections() {
    final colors = [
      Colors.deepPurple, Colors.blue, Colors.green, 
      Colors.amber, Colors.red, Colors.teal, 
      Colors.indigo, Colors.orange
    ];
    
    return model.revenueByCategory.asMap().entries.map((entry) {
      final idx = entry.key;
      final category = entry.value;
      
      final double percentage = category['percentage'] is double 
          ? category['percentage'] 
          : double.parse(category['percentage'].toString());
      final Color color = colors[idx % colors.length];
      
      return PieChartSectionData(
        value: percentage,
        title: '${percentage.toStringAsFixed(1)}%',
        color: color,
        radius: 80 - (idx * 4 % 20),
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }
  
  Widget _buildCategoryLegends() {
    if (model.revenueByCategory.isEmpty) {
      return const Center(child: Text('Không có dữ liệu'));
    }
    
    final formatter = NumberFormat("#,###");
    final colors = [
      Colors.deepPurple, Colors.blue, Colors.green, 
      Colors.amber, Colors.red, Colors.teal, 
      Colors.indigo, Colors.orange
    ];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: model.revenueByCategory.asMap().entries.map((entry) {
        final idx = entry.key;
        final category = entry.value;
        
        final double percentage = category['percentage'] is double 
          ? category['percentage'] 
          : double.parse(category['percentage'].toString());
        final Color color = colors[idx % colors.length];
          
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  category['category'].toString(),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              Text(
                '₫${formatter.format(category['revenue'] / 1000000)}M',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${percentage.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
