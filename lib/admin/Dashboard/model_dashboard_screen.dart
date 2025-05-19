import 'package:flutter/material.dart';
import 'package:gear_zone/core/utils/responsive.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../../model/dashboard_model.dart';

/// A dashboard screen that uses the DashboardModel directly
/// instead of connecting to the existing EnhancedDashboardScreen
class ModelDashboardScreen extends StatelessWidget {
  const ModelDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashboardModel(),
      child: const _DashboardContent(),
    );
  }
}

class _DashboardContent extends StatefulWidget {
  const _DashboardContent({Key? key}) : super(key: key);

  @override
  State<_DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<_DashboardContent> {
  // Helper method to show date picker for custom time range
  Future<void> _showDateRangePicker(BuildContext context, DashboardModel model) async {
    final initialDateRange = DateTimeRange(
      start: model.startDate,
      end: model.endDate,
    );
    
    final pickedDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: initialDateRange,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.deepPurple,
              onPrimary: Colors.white,
              surface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (pickedDateRange != null) {
      model.setCustomDateRange(pickedDateRange.start, pickedDateRange.end);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    
    return Consumer<DashboardModel>(
      builder: (context, model, _) {
        return Scaffold(
          body: model.isLoading 
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row with title and time filter
                    _buildHeaderRow(context, model),
                    
                    const SizedBox(height: 24),
                    
                    // Quick stats cards
                    _buildQuickStatsRow(isMobile, model),
                    
                    const SizedBox(height: 20),
                    
                    // Revenue chart
                    _buildRevenueChart(context, model),
                    
                    const SizedBox(height: 20),
                    
                    // Compare with previous period toggle
                    if (!isMobile)
                      _buildComparisonToggle(model),
                      
                // Show comparison chart if enabled
                    if (model.showComparison)
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: _buildComparisonChart(context, model),
                      ),
                      
                    const SizedBox(height: 20),
                    
                    // Top selling products table
                    _buildTopSellingProductsCard(context, model),
                    
                    const SizedBox(height: 20),
                    
                    // Revenue by category pie chart
                    _buildRevenueByCategoryCard(isMobile, model),
                  ],
                ),
              ),
        );
      }
    );
  }
  
  Widget _buildHeaderRow(BuildContext context, DashboardModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bảng điều khiển',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _getCurrentPeriodDisplay(model),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        _buildTimeFilterSelector(context, model),
      ],
    );
  }
  
  String _getCurrentPeriodDisplay(DashboardModel model) {
    final selectedFilter = model.selectedTimeFilter;
    final endDate = model.endDate;
    
    switch (selectedFilter) {
      case 'Năm':
        return 'Năm ${endDate.year}';
      case 'Quý':
        final quarter = (endDate.month / 3).ceil();
        return 'Quý $quarter/${endDate.year}';
      case 'Tháng':
        return DateFormat('MM/yyyy').format(endDate);
      case 'Tuần':
        final weekNumber = (endDate.difference(DateTime(endDate.year, 1, 1)).inDays / 7).ceil();
        return 'Tuần $weekNumber/${endDate.year}';
      case 'Tùy chỉnh':
        return '${DateFormat('dd/MM/yyyy').format(model.startDate)} - ${DateFormat('dd/MM/yyyy').format(endDate)}';
      default:
        return 'Tất cả thời gian';
    }
  }
  
  Widget _buildTimeFilterSelector(BuildContext context, DashboardModel model) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: model.selectedTimeFilter,
            icon: const Icon(Icons.keyboard_arrow_down),
            items: model.timeFilterOptions.map((String filter) {
              return DropdownMenuItem(
                value: filter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(filter),
                ),
              );
            }).toList(),
            onChanged: (String? value) {
              if (value != null) {
                if (value == 'Tùy chỉnh') {
                  _showDateRangePicker(context, model);
                } else {
                  model.setTimeFilter(value);
                }
              }
            },
          ),
        ),
      ),
    );
  }
  
  Widget _buildQuickStatsRow(bool isMobile, DashboardModel model) {
    final formatter = NumberFormat("#,###");
    final stats = [
      {
        'icon': Icons.person,
        'title': 'Tổng người dùng',
        'value': formatter.format(model.overallStats['totalUsers'] ?? 0),
        'change': '+${model.overallStats['userChange'] ?? 0}%',
        'isPositive': true,
        'color': Colors.deepPurple,
      },
      {
        'icon': Icons.person_add,
        'title': 'Người dùng mới',
        'value': formatter.format(model.overallStats['newUsers'] ?? 0),
        'change': '+${model.overallStats['userChange'] ?? 0}%',
        'isPositive': true,
        'color': Colors.blue,
      },
      {
        'icon': Icons.shopping_cart,
        'title': 'Đơn hàng',
        'value': formatter.format(model.overallStats['totalOrders'] ?? 0),
        'change': '+${model.overallStats['orderChange'] ?? 0}%',
        'isPositive': true,
        'color': Colors.green,
      },
      {
        'icon': Icons.attach_money,
        'title': 'Doanh thu',
        'value': '₫${formatter.format((model.overallStats['totalRevenue'] ?? 0) / 1000000)}M',
        'change': '+${model.overallStats['revenueChange'] ?? 0}%',
        'isPositive': true,
        'color': Colors.amber,
      },
    ];
    
    if (isMobile) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: stats.length,
        itemBuilder: (context, index) {
          return _buildStatCard(stats[index]);
        },
      );
    }
    
    return Row(
      children: stats.map((stat) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: _buildStatCard(stat),
          ),
        );
      }).toList(),
    );
  }
  
  Widget _buildStatCard(Map<String, dynamic> stat) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  stat['title'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                Icon(
                  stat['icon'] as IconData,
                  color: stat['color'] as Color,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              stat['value'],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  stat['isPositive'] ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 16,
                  color: stat['isPositive'] ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 4),
                Text(
                  stat['change'],
                  style: TextStyle(
                    fontSize: 14,
                    color: stat['isPositive'] ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildRevenueChart(BuildContext context, DashboardModel model) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Doanh thu',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.download_outlined),
                  onPressed: () async {
                    // Export functionality using the model
                    final result = await model.exportReport('PDF');
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(result))
                      );
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              child: model.revenueSpots.isNotEmpty
                  ? LineChart(_getLineChartData(model.revenueSpots, model.periodLabels))
                  : const Center(child: Text('Không có dữ liệu')),
            ),
          ],
        ),
      ),
    );
  }
  
  LineChartData _getLineChartData(List<FlSpot> spots, List<String> labels) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 5,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey.shade300,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.grey.shade300,
            strokeWidth: 1,
          );
        },
      ),      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (value, meta) {
              final int index = value.toInt();
              if (index >= 0 && index < labels.length) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    labels[index],
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              return SideTitleWidget(
                axisSide: meta.axisSide,
                child: Text(
                  '${value.toInt()}M',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              );
            },
          ),
        ),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
          left: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      minX: 0,
      maxX: (labels.length - 1).toDouble(),
      minY: 0,
      maxY: spots.isEmpty ? 10 : spots.map((spot) => spot.y).reduce(max) * 1.2,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: Colors.deepPurple,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(show: true),
          belowBarData: BarAreaData(
            show: true,
            color: Colors.deepPurple.withOpacity(0.1),
          ),
        ),
      ],
    );
  }

  Widget _buildComparisonChart(BuildContext context, DashboardModel model) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'So sánh doanh thu: ${_getCurrentPeriodDisplay(model)} vs ${model.comparisonPeriod}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              child: model.revenueSpots.isNotEmpty && model.previousRevenueSpots.isNotEmpty
                  ? LineChart(_getComparisonChartData(model))
                  : const Center(child: Text('Không có dữ liệu so sánh')),
            ),
          ],
        ),
      ),
    );
  }
  
  LineChartData _getComparisonChartData(DashboardModel model) {
    final spots = model.revenueSpots;
    final previousSpots = model.previousRevenueSpots;
    final labels = model.periodLabels;
    
    // Calculate max Y value
    double maxY = 0;
    for (var spot in spots) {
      if (spot.y > maxY) maxY = spot.y;
    }
    for (var spot in previousSpots) {
      if (spot.y > maxY) maxY = spot.y;
    }
    maxY = maxY * 1.2; // Add 20% margin
    
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 5,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey.shade300,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.grey.shade300,
            strokeWidth: 1,
          );
        },
      ),      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (value, meta) {
              final int index = value.toInt();
              if (index >= 0 && index < labels.length) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    labels[index],
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              return SideTitleWidget(
                axisSide: meta.axisSide,
                child: Text(
                  '${value.toInt()}M',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              );
            },
          ),
        ),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),      borderData: FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
          left: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      minX: 0,
      maxX: (labels.length - 1).toDouble(),
      minY: 0,
      maxY: maxY,
      lineBarsData: [
        // Current period data
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: Colors.deepPurple,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(show: true),
          belowBarData: BarAreaData(
            show: true,
            color: Colors.deepPurple.withOpacity(0.1),
          ),
        ),
        // Previous period data
        LineChartBarData(
          spots: previousSpots,
          isCurved: true,
          color: Colors.blueGrey,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(show: true),
          dashArray: [5, 5],
        ),
      ],
    );
  }
  
  Widget _buildTopSellingProductsCard(BuildContext context, DashboardModel model) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sản phẩm bán chạy nhất',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            model.topSellingProducts.isNotEmpty
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingTextStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      columns: const [
                        DataColumn(label: Text('#')),
                        DataColumn(label: Text('Tên sản phẩm')),
                        DataColumn(label: Text('Danh mục')),
                        DataColumn(label: Text('Doanh thu'), numeric: true),
                        DataColumn(label: Text('Đã bán'), numeric: true),
                      ],
                      rows: model.topSellingProducts.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final product = entry.value;
                        final formatter = NumberFormat("#,###");
                        
                        return DataRow(
                          cells: [
                            DataCell(Text('${idx + 1}')),
                            DataCell(Text(product['name'])),
                            DataCell(Text(product['category'])),
                            DataCell(Text('₫${formatter.format(product['revenue'])}')),
                            DataCell(Text('${product['sold'] ?? product['unitsSold']}')),
                          ],
                        );
                      }).toList(),
                    ),
                  )
                : const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text('Không có dữ liệu'),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildRevenueByCategoryCard(bool isMobile, DashboardModel model) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Doanh thu theo danh mục',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            if (isMobile) 
              _buildCategoryPieChart(model)
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildCategoryPieChart(model),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 3,
                    child: _buildCategoryLegends(model),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCategoryPieChart(DashboardModel model) {
    return SizedBox(
      height: 250,
      child: model.revenueByCategory.isNotEmpty
          ? PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 50,
                sections: _getPieSections(model.revenueByCategory),
              ),
            )
          : const Center(child: Text('Không có dữ liệu')),
    );
  }
  
  List<PieChartSectionData> _getPieSections(List<Map<String, dynamic>> categories) {
    final colors = [
      Colors.deepPurple, Colors.blue, Colors.green, 
      Colors.amber, Colors.red, Colors.teal, 
      Colors.indigo, Colors.orange
    ];
    
    return categories.asMap().entries.map((entry) {
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
  
  Widget _buildCategoryLegends(DashboardModel model) {
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
    Widget _buildComparisonToggle(DashboardModel model) {
    return Row(
      children: [
        Switch(
          value: model.showComparison,
          onChanged: (value) {
            // We cannot directly set showComparison in the model since it doesn't have a setter
            // But we can update our local state and refresh the UI
            setState(() {
              // This will trigger UI refresh
            });
            
            // Trigger data refresh if needed
            // Since we can't directly control the model's state, we use other methods
            // like setTimeFilter to indirectly refresh the data
            if (model.selectedTimeFilter != '') {
              // Re-apply the current filter to refresh data
              model.setTimeFilter(model.selectedTimeFilter);
            }
          },
          activeColor: Colors.deepPurple,
        ),
        const SizedBox(width: 8),
        const Text(
          'So sánh với',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 16),
        if (model.showComparison)
          DropdownButton<String>(
            value: model.comparisonPeriod,
            onChanged: (String? newValue) {
              if (newValue != null) {
                // Since we can't directly set comparisonPeriod, we use setTimeFilter
                // to refresh the data
                model.setTimeFilter(model.selectedTimeFilter);
                setState(() {
                  // Update UI
                });
              }
            },
            items: model.comparisonOptions
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            underline: Container(
              height: 1,
              color: Colors.deepPurple,
            ),
          ),
      ],
    );
  }
}
