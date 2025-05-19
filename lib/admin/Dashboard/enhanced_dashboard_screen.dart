import 'package:flutter/material.dart';
import 'package:gear_zone/core/utils/responsive.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../../model/dashboard_model.dart';

class EnhancedDashboardScreen extends StatefulWidget {
  const EnhancedDashboardScreen({super.key});

  @override
  State<EnhancedDashboardScreen> createState() => _EnhancedDashboardScreenState();
}

class _EnhancedDashboardScreenState extends State<EnhancedDashboardScreen> {
  late DashboardModel _dashboardModel;
  // Define default months labels for charts
  final List<String> months = ['T1', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'T8', 'T9', 'T10', 'T11', 'T12'];
  
  @override
  void initState() {
    super.initState();
    _dashboardModel = DashboardModel();
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
                  Row(
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
                            _currentPeriodDisplay(model),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      _buildTimeFilterSelector(model),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Quick stats row
                  _buildQuickStatsRow(isMobile, model),
                  
                  const SizedBox(height: 20),
                  
                  // Sales chart
                  _buildSalesChart(context, isMobile, model),
                  
                  const SizedBox(height: 20),
                  
                  // Compare with previous period
                  if (!isMobile)
                    _buildComparisonToggle(model),
                    
                  if (model.showComparison)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        _buildComparisonChart(context, isMobile, model),
                      ],
                    ),
                    
                  const SizedBox(height: 20),
                  
                  // User statistics
                  Row(
                    children: [
                      Expanded(
                        flex: isMobile ? 1 : 2,
                        child: _buildUserStatsCard(model),
                      ),
                      if (!isMobile) const SizedBox(width: 20),
                      if (!isMobile)
                        Expanded(
                          flex: 3,
                          child: _buildOrdersOverTimeCard(context, model),
                        ),
                    ],
                  ),
                  
                  if (isMobile) 
                    Column(
                      children: [
                        const SizedBox(height: 20),
                        _buildOrdersOverTimeCard(context, model),
                      ],
                    ),
                  
                  const SizedBox(height: 20),
                  
                  // Popular products
                  _buildPopularProductsTable(context, model),
                  
                  const SizedBox(height: 20),
                  
                  // Revenue by product category
                  _buildRevenueByCategory(context, isMobile, model),
                ],
              ),
            ),
        );
      }
    );
  }
  
  // Current period display
  String _currentPeriodDisplay(DashboardModel model) {
    final _selectedTimeFilter = model.selectedTimeFilter;
    final _endDate = model.endDate;
    
    switch (_selectedTimeFilter) {
      case 'Năm':
        return 'Năm ${_endDate.year}';
      case 'Quý':
        final quarter = (_endDate.month / 3).ceil();
        return 'Quý $quarter/${_endDate.year}';
      case 'Tháng':
        return '${DateFormat('MM/yyyy').format(_endDate)}';
      case 'Tuần':
        final weekNumber = (_endDate.difference(DateTime(_endDate.year, 1, 1)).inDays / 7).ceil();
        return 'Tuần $weekNumber/${_endDate.year}';
      case 'Tùy chỉnh':
        return '${DateFormat('dd/MM/yyyy').format(model.startDate)} - ${DateFormat('dd/MM/yyyy').format(_endDate)}';
      default:
        return 'Tất cả thời gian';
    }
  }  Widget _buildTimeFilterSelector(DashboardModel model) {
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
                  // Show date range picker for custom range
                  _showDateRangePicker();
                } else {
                  // Use the model's setTimeFilter method to update the filter
                  model.setTimeFilter(value);
                }
                // Refresh UI after filter change
                setState(() {});
              }
            },
          ),
        ),
      ),
    );
  }
    Future<void> _showDateRangePicker() async {
    final initialDateRange = DateTimeRange(
      start: _dashboardModel.startDate,
      end: _dashboardModel.endDate,
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
      // Use the model's method to set custom date range
      _dashboardModel.setCustomDateRange(
        pickedDateRange.start, 
        pickedDateRange.end
      );
      
      // Refresh UI
      setState(() {});
    }
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
          return _buildQuickStatCard(stats[index]);
        },
      );
    }
    
    return Row(
      children: stats.map((stat) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: _buildQuickStatCard(stat),
          ),
        );
      }).toList(),
    );
  }
  
  Widget _buildQuickStatCard(Map<String, dynamic> stat) {
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
            const SizedBox(height: 12),
            Text(
              stat['value'],
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: stat['color'] as Color,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  stat['isPositive'] ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 14,
                  color: stat['isPositive'] ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 4),
                Text(
                  stat['change'],
                  style: TextStyle(
                    fontSize: 12,
                    color: stat['isPositive'] ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'so với kỳ trước',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
    Widget _buildSalesChart(BuildContext context, bool isMobile, DashboardModel model) {
    // Track whether we're showing revenue or orders
    final showRevenue = ValueNotifier<bool>(true);
    
    // Prepare chart data based on the time filter
    List<String> periodLabels = [];
    List<FlSpot> spots = [];
    double maxY = 10.0;
    
    if (model.revenueByTime.isNotEmpty) {
      // Get data from API
      for (int i = 0; i < model.revenueByTime.length; i++) {
        final data = model.revenueByTime[i];
        periodLabels.add(data['period'].toString());
        
        // Convert revenue to millions for display
        final double value = (data['revenue'] as num).toDouble() / 1000000;
        spots.add(FlSpot(i.toDouble(), value));
        
        // Update max Y value
        if (value > maxY) {
          maxY = (value * 1.2).ceilToDouble(); // Add 20% headroom
        }
      }
    } else {
      // Fallback to sample data
      periodLabels = months;
      spots = [
        const FlSpot(0, 3.5),
        const FlSpot(1, 4.2),
        const FlSpot(2, 3.8),
        const FlSpot(3, 5.0),
        const FlSpot(4, 4.5),
        const FlSpot(5, 6.8),
        const FlSpot(6, 7.2),
        const FlSpot(7, 6.5),
        const FlSpot(8, 7.8),
        const FlSpot(9, 8.3),
        const FlSpot(10, 9.2),
        const FlSpot(11, 8.7),
      ];
    }
    
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
                const Text(
                  'Doanh thu theo thời gian',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(
                      value: 'revenue',
                      label: Text('Doanh thu'),
                    ),
                    ButtonSegment(
                      value: 'orders',
                      label: Text('Đơn hàng'),
                    ),
                  ],
                  selected: const {'revenue'},
                  onSelectionChanged: (Set<String> newValue) {
                    // Update chart data based on selection
                    showRevenue.value = newValue.first == 'revenue';
                  },
                  style: ButtonStyle(
                    visualDensity: VisualDensity.compact,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 250,
              child: ValueListenableBuilder<bool>(
                valueListenable: showRevenue,
                builder: (context, isRevenue, _) {
                  return LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        horizontalInterval: 1,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.grey.shade300,
                            strokeWidth: 1,
                            dashArray: [5, 5],
                          );
                        },
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            getTitlesWidget: (value, meta) {
                              final int index = value.toInt();
                              if (index >= 0 && index < periodLabels.length) {
                                return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  child: Text(
                                    periodLabels[index],
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
                            reservedSize: 45,
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
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border(
                          bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                          left: BorderSide(color: Colors.grey[300]!, width: 1),
                        ),
                      ),
                      minX: 0,
                      maxX: (periodLabels.length - 1).toDouble(),
                      minY: 0,
                      maxY: maxY,
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,                          color: isRevenue ? Colors.deepPurple : Colors.blue,
                          barWidth: 3,
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: (isRevenue ? Colors.deepPurple : Colors.blue).withAlpha(25),
                          ),
                        ),
                      ],
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          tooltipBgColor: isRevenue ? Colors.deepPurple : Colors.blue,
                          getTooltipItems: (List<LineBarSpot> touchedSpots) {
                            return touchedSpots.map((spot) {
                              final index = spot.x.toInt();
                              if (index >= 0 && index < periodLabels.length) {
                                final period = periodLabels[index];
                                return LineTooltipItem(
                                  '$period: ₫${spot.y}M',
                                  const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }
                              return null;
                            }).whereType<LineTooltipItem>().toList();                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.grey[700],
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Tổng doanh thu: ₫${NumberFormat("#,###").format((model.overallStats['totalRevenue'] ?? 142000000) / 1000000)}M',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildComparisonToggle(DashboardModel model) {
    return Row(
      children: [
        Switch(
          value: model.showComparison,
          onChanged: (value) {
            // Use model's method to toggle comparison
            model.toggleComparison(value);
            setState(() {});
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
                // Use model's method to update comparison period
                model.setComparisonPeriod(newValue);
                setState(() {});
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
    Widget _buildComparisonChart(BuildContext context, bool isMobile, DashboardModel model) {
    // Prepare chart data based on the time filter
    List<String> periodLabels = [];
    List<double> currentPeriodData = [];
    List<double> previousPeriodData = [];
    double maxY = 10.0;
    
    // Determine comparison data based on selected time filter
    if (model.revenueByTime.isNotEmpty) {
      // Get period labels from API data
      for (var item in model.revenueByTime) {
        periodLabels.add(item['period'].toString());
        
        // Current period data (in millions)
        final double revenue = (item['revenue'] as num).toDouble() / 1000000;
        currentPeriodData.add(revenue);
        
        // Generate previous period data (using approximation)
        final double prevRevenue = revenue * (0.7 + (0.3 * (revenue % 3 == 0 ? 0.8 : 1.1)));
        previousPeriodData.add(prevRevenue);
        
        // Update max Y value
        maxY = max(maxY, max(revenue, prevRevenue) * 1.2);
      }
    } else {
      // Fallback to sample data
      periodLabels = months;
      currentPeriodData = [3.5, 4.2, 3.8, 5.0, 4.5, 6.8, 7.2, 6.5, 7.8, 8.3, 9.2, 8.7];
      previousPeriodData = [2.8, 3.5, 3.2, 4.0, 3.7, 5.5, 6.0, 5.2, 6.5, 7.1, 7.8, 7.2];
    }
    
    // Calculate comparison metrics
    final double currentTotal = currentPeriodData.fold(0, (sum, item) => sum + item);
    final double previousTotal = previousPeriodData.fold(0, (sum, item) => sum + item);
    final double changePercent = (currentTotal - previousTotal) / previousTotal * 100;
    final bool isPositive = changePercent >= 0;
    
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [            Text(
              'So sánh doanh thu: ${_currentPeriodDisplay(model)} vs ${model.comparisonPeriod}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxY,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.deepPurple,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final index = group.x.toInt();
                        if (index >= 0 && index < periodLabels.length) {
                          final period = periodLabels[index];
                          return BarTooltipItem(
                            '$period\n${rodIndex == 0 ? "Kỳ này" : "Kỳ trước"}: ₫${rod.toY.toStringAsFixed(1)}M',
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }
                        return null;
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          // Show fewer labels on x-axis if there are many periods
                          final showEvery = periodLabels.length > 6 ? 2 : 1;
                          
                          if (index % showEvery == 0 && index < periodLabels.length) {
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              child: Text(
                                periodLabels[index],
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
                        reservedSize: 45,
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
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                      left: BorderSide(color: Colors.grey.shade300, width: 1),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    horizontalInterval: maxY / 5,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.shade300,
                        strokeWidth: 1,
                        dashArray: [5, 5],
                      );
                    },
                  ),
                  barGroups: List.generate(
                    periodLabels.length,
                    (index) => BarChartGroupData(
                      x: index,
                      barRods: [
                        // Current period
                        BarChartRodData(
                          toY: index < currentPeriodData.length ? currentPeriodData[index] : 0,
                          color: Colors.deepPurple,
                          width: 12,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(3),
                            topRight: Radius.circular(3),
                          ),
                        ),
                        // Previous period
                        BarChartRodData(
                          toY: index < previousPeriodData.length ? previousPeriodData[index] : 0,
                          color: Colors.grey[350],
                          width: 12,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(3),
                            topRight: Radius.circular(3),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Legend for current period
                Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _currentPeriodDisplay(model),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(width: 24),
                // Legend for previous period
                Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.grey[350],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      model.comparisonPeriod,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),                decoration: BoxDecoration(
                  color: isPositive 
                  ? Colors.green.withAlpha(25) 
                  : Colors.red.withAlpha(25),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: isPositive 
                  ? Colors.green.shade200 
                  : Colors.red.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    isPositive ? Icons.trending_up : Icons.trending_down,
                    color: isPositive ? Colors.green : Colors.red,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Doanh thu ${isPositive ? "tăng" : "giảm"} ${changePercent.abs().toStringAsFixed(1)}% so với ${model.comparisonPeriod.toLowerCase()}',
                      style: TextStyle(
                        color: isPositive ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildUserStatsCard(DashboardModel model) {
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
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Thống kê người dùng',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.people),
              ],
            ),
            const SizedBox(height: 24),
            _buildUserStatRow('Tổng số người dùng', '8,549', Icons.person),
            const Divider(),
            _buildUserStatRow('Người dùng mới (tháng này)', '1,253', Icons.person_add),
            const Divider(),
            _buildUserStatRow('Người dùng hoạt động', '5,721', Icons.check_circle),
            const Divider(),
            _buildUserStatRow('Người dùng premium', '924', Icons.star),
            const SizedBox(height: 16),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Xem chi tiết'),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildUserStatRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.deepPurple,
            size: 18,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
    Widget _buildOrdersOverTimeCard(BuildContext context, DashboardModel model) {
    // Prepare data
    List<Map<String, dynamic>> orderData;
    double maxY = 100.0;
    
    const dayVietNames = {
      'Mon': 'Thứ 2',
      'Tue': 'Thứ 3',
      'Wed': 'Thứ 4',
      'Thu': 'Thứ 5',
      'Fri': 'Thứ 6',
      'Sat': 'Thứ 7',
      'Sun': 'CN',
    };
    
    const shortDayNames = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
    
    if (model.ordersByDayOfWeek.isNotEmpty) {
      orderData = model.ordersByDayOfWeek;
      
      // Find max Y value
      maxY = orderData
          .map((item) => (item['orders'] as num).toDouble())
          .reduce(max) * 1.2;
    } else {
      // Fallback to sample data
      orderData = [
        {'day': 'Mon', 'orders': 45},
        {'day': 'Tue', 'orders': 60},
        {'day': 'Wed', 'orders': 55},
        {'day': 'Thu', 'orders': 65},
        {'day': 'Fri', 'orders': 85},
        {'day': 'Sat', 'orders': 92},
        {'day': 'Sun', 'orders': 70},
      ];
    }
    
    // Calculate order statistics
    double avgOrdersDaily = orderData
        .map((item) => (item['orders'] as num).toDouble())
        .reduce((a, b) => a + b) / 7;
        
    int totalOrders = orderData
        .map((item) => (item['orders'] as num).toInt())
        .reduce((a, b) => a + b);
        
    // Growth percentage compared to last week (sample calculation)
    double growthPercent = 8.7;
    
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
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Đơn hàng theo thời gian',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.shopping_cart),
              ],
            ),
            const SizedBox(height: 24),
            
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxY,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.blueGrey,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        if (groupIndex < orderData.length) {
                          final dayKey = orderData[groupIndex]['day'] as String;
                          final weekDay = dayVietNames[dayKey] ?? dayKey;
                          return BarTooltipItem(
                            '$weekDay\n${rod.toY.round()} đơn hàng',
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }
                        return null;
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < shortDayNames.length) {
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              child: Text(
                                shortDayNames[index],
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
                        getTitlesWidget: (value, meta) {
                          // Show fewer y-axis labels for better readability
                          final interval = (maxY / 5).ceil();
                          if (value % interval == 0) {
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              child: Text(
                                value.toInt().toString(),
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            );
                          }
                          return const SizedBox();
                        },
                        reservedSize: 30,
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                      left: BorderSide(color: Colors.grey[300]!, width: 1),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: maxY / 5,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.shade300,
                        strokeWidth: 1,
                        dashArray: [5, 5],
                      );
                    },
                  ),
                  barGroups: List.generate(
                    orderData.length,
                    (index) {
                      final order = orderData[index];
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: (order['orders'] as num).toDouble(),
                            // Color intensity based on order volume
                            color: Colors.blue[(300 + ((order['orders'] as num) / maxY * 400)).clamp(300, 700).toInt()],
                            width: 20,
                            borderRadius: BorderRadius.circular(4),
                          )
                        ],
                      );
                    }
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildOrderStat('Trung bình\nhàng ngày', avgOrdersDaily.round().toString()),
                _buildOrderStat('Tổng\ntuần này', totalOrders.toString()),
                _buildOrderStat('So với\ntuần trước', '+${growthPercent.toStringAsFixed(1)}%'),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildOrderStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
    Widget _buildPopularProductsTable(BuildContext context, DashboardModel model) {
    final formatter = NumberFormat("#,###");
    final products = model.topSellingProducts.isNotEmpty ? model.topSellingProducts : [
      {
        'name': 'Tai nghe Gaming Logitech G435',
        'category': 'Tai nghe',
        'price': '1,290,000 ₫',
        'sold': 253,
      },
      {
        'name': 'Chuột Logitech G502 X PLUS',
        'category': 'Chuột',
        'price': '3,290,000 ₫',
        'sold': 198,
      },
      {
        'name': 'Bàn phím Keychron Q1',
        'category': 'Bàn phím',
        'price': '4,590,000 ₫',
        'sold': 175,
      },
      {
        'name': 'Ghế Gaming Secretlab TITAN Evo',
        'category': 'Ghế',
        'price': '12,990,000 ₫',
        'sold': 89,
      },
      {
        'name': 'Màn hình Dell Alienware AW2723DF',
        'category': 'Màn hình',
        'price': '18,990,000 ₫',
        'sold': 65,
      },
    ];
    
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
                const Text(
                  'Sản phẩm bán chạy nhất',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_forward, size: 16),
                  label: const Text('Xem tất cả'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.deepPurple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 16,
                horizontalMargin: 12,
                columns: const [
                  DataColumn(
                    label: Text(
                      'Sản phẩm',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Danh mục',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Giá',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Đã bán',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    numeric: true,
                  ),
                ],
                rows: products.map((product) {
                  return DataRow(
                    cells: [                      DataCell(
                        SizedBox(
                          width: 200,
                          child: Text(
                            product['name'].toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      DataCell(Text(product['category'].toString())),
                      DataCell(Text(model.topSellingProducts.isNotEmpty 
                        ? '${formatter.format(product['revenue'] / product['unitsSold'])} ₫'
                        : product['price'].toString()
                      )),
                      DataCell(
                        Row(
                          children: [
                            Text(model.topSellingProducts.isNotEmpty
                              ? product['unitsSold'].toString()
                              : product['sold'].toString()
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.trending_up,
                              color: Colors.green,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildRevenueByCategory(BuildContext context, bool isMobile, DashboardModel model) {
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
            const Text(
              'Doanh thu theo danh mục',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            
            isMobile
                ? Column(
                    children: [
                      SizedBox(
                        height: 180,
                        child: _buildPieChart(model),
                      ),
                      const SizedBox(height: 16),
                      _buildCategoryLegends(model),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 250,
                          child: _buildPieChart(model),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: _buildCategoryLegends(model),
                      ),
                    ],
                  ),
            
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withAlpha(25),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.lightbulb,
                    color: Colors.blue,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Nhóm sản phẩm tai nghe và bàn phím có tỷ suất lợi nhuận cao nhất trong kỳ này.',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
    Widget _buildPieChart(DashboardModel model) {
    final categories = model.revenueByCategory.isNotEmpty ? model.revenueByCategory : [
      {
        'category': 'Gaming Laptop',
        'revenue': 45000000,
        'percentage': 31.7,
        'color': Colors.deepPurple,
      },
      {
        'category': 'Gaming Accessories',
        'revenue': 32000000,
        'percentage': 22.5,
        'color': Colors.blue,
      },
      {
        'category': 'Gaming Monitors',
        'revenue': 28000000,
        'percentage': 19.7,
        'color': Colors.green,
      },
      {
        'category': 'Gaming PC',
        'revenue': 20000000,
        'percentage': 14.1,
        'color': Colors.amber,
      },
      {
        'category': 'Components',
        'revenue': 17000000,
        'percentage': 12.0,
        'color': Colors.red,
      },
    ];

    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        sections: categories.map((category) {
          final double percentage = category['percentage'] is double 
            ? category['percentage'] 
            : double.parse(category['percentage'].toString());
          final Color color = category['color'] is Color 
            ? category['color'] 
            : Colors.primaries[categories.indexOf(category) % Colors.primaries.length];
          
          return PieChartSectionData(
            value: percentage,
            title: '${percentage.toStringAsFixed(1)}%',
            color: color,
            radius: 80 - (categories.indexOf(category) * 4),
            titleStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }).toList(),
      ),
    );
  }
    Widget _buildCategoryLegends(DashboardModel model) {
    // Use API data if available, otherwise use sample data
    List<Map<String, dynamic>> categories;
    
    if (model.revenueByCategory.isNotEmpty) {
      // Format the API data
      final formatter = NumberFormat("#,###");
      categories = model.revenueByCategory.map((category) {
        final double percentage = category['percentage'] is double 
          ? category['percentage'] 
          : double.parse(category['percentage'].toString());
          
        final Color color = category['color'] is Color 
          ? category['color'] 
          : Colors.primaries[model.revenueByCategory.indexOf(category) % Colors.primaries.length];
          
        return {
          'name': category['category'].toString(),
          'value': '${formatter.format(category['revenue'] / 1000000)}M ₫',
          'color': color,
          'percent': '${percentage.toStringAsFixed(1)}%',
        };
      }).toList();
    } else {
      // Fallback to sample data
      categories = [
        {'name': 'Tai nghe', 'value': '45.3M ₫', 'color': Colors.deepPurple, 'percent': '35%'},
        {'name': 'Bàn phím', 'value': '32.5M ₫', 'color': Colors.blue, 'percent': '25%'},
        {'name': 'Chuột', 'value': '26.0M ₫', 'color': Colors.green, 'percent': '20%'},
        {'name': 'Ghế & Bàn', 'value': '19.5M ₫', 'color': Colors.amber, 'percent': '15%'},
        {'name': 'Khác', 'value': '6.5M ₫', 'color': Colors.red, 'percent': '5%'},
      ];
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: categories.map((category) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: category['color'] as Color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  category['name'].toString(),
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              Text(
                category['value'].toString(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                category['percent'].toString(),
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
