import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/responsive.dart';
import '../../../model/dashboard_model.dart';
import '../components/stat_card.dart';
import '../components/time_filter.dart';
import '../widgets/revenue_chart.dart';
import '../widgets/profit_chart.dart';
import '../widgets/product_metrics_chart.dart';
import '../widgets/comparison_chart.dart';
import '../widgets/comparison_toggle.dart';
import '../widgets/category_pie.dart';
import '../widgets/products_table.dart';

/// The main dashboard screen that uses components from the restructured code
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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

  void _toggleComparison(bool value) {
    setState(() {
      // This will trigger UI refresh
    });
    
    // Refresh data if needed
    final model = Provider.of<DashboardModel>(context, listen: false);
    if (model.selectedTimeFilter.isNotEmpty) {
      // Re-apply the current filter to refresh data
      model.setTimeFilter(model.selectedTimeFilter);
    }
  }

  void _handleExportRequest(String format) async {
    final model = Provider.of<DashboardModel>(context, listen: false);
    final result = await model.exportReport(format);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashboardModel(),
      child: Consumer<DashboardModel>(
        builder: (context, model, _) {
          final isMobile = Responsive.isMobile(context);
          
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
                        // Heading for Simple Dashboard section
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.dashboard, color: Colors.white, size: 24),
                            SizedBox(width: 10),
                            Text(
                              'Dashboard Đơn Giản - Tổng quan bán hàng',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Simple Dashboard Content
                      _buildSimpleDashboard(isMobile, model),
                      
                      const SizedBox(height: 40),
                      
                      // Divider between dashboards
                      Container(
                        height: 2,
                        color: Colors.grey[300],
                      ),
                      
                      const SizedBox(height: 40),
                        // Heading for Advanced Dashboard section
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade800,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.analytics, color: Colors.white, size: 24),
                            SizedBox(width: 10),
                            Text(
                              'Dashboard Nâng Cao - Phân tích chi tiết',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Advanced Dashboard Content
                      _buildAdvancedDashboard(isMobile, model),
                    ],
                  ),
                ),
          );
        }
      ),
    );
  }
  
  // Helper function to display the current period in a user-friendly format
  String getCurrentPeriodDisplay(DashboardModel model) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    
    if (model.selectedTimeFilter == 'Tùy chỉnh') {
      return '${formatter.format(model.startDate)} - ${formatter.format(model.endDate)}';
    }
    
    switch (model.selectedTimeFilter) {
      case 'Năm':
        return 'Năm ${model.startDate.year}';
      case 'Quý':
        final quarter = ((model.startDate.month - 1) / 3).floor() + 1;
        return 'Quý $quarter/${model.startDate.year}';
      case 'Tháng':
        return 'Tháng ${model.startDate.month}/${model.startDate.year}';
      case 'Tuần':
        return '${formatter.format(model.startDate)} - ${formatter.format(model.endDate)}';
      default:
        return '';
    }
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
              getCurrentPeriodDisplay(model),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        TimeFilterSelector(
          model: model,
          showDateRangePicker: _showDateRangePicker,
        ),
      ],
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
      {
        'icon': Icons.savings,
        'title': 'Lợi nhuận',
        'value': '₫${formatter.format((model.overallStats['totalProfit'] ?? 0) / 1000000)}M',
        'change': '+${model.overallStats['profitChange'] ?? 0}%',
        'isPositive': true,
        'color': Colors.orange,
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
          final stat = stats[index];
          return StatCard(
            title: stat['title'] as String,
            value: stat['value'] as String,
            change: stat['change'] as String,
            isPositive: stat['isPositive'] as bool,
            color: stat['color'] as Color,
            icon: stat['icon'] as IconData,
          );
        },
      );
    }
    
    return Row(
      children: stats.map((stat) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: StatCard(
              title: stat['title'] as String,
              value: stat['value'] as String,
              change: stat['change'] as String,
              isPositive: stat['isPositive'] as bool,
              color: stat['color'] as Color,
              icon: stat['icon'] as IconData,
            ),
          ),
        );
      }).toList(),
    );
  }
    // Build the Simple Dashboard view
  Widget _buildSimpleDashboard(bool isMobile, DashboardModel model) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Revenue chart - Chỉ có ở Dashboard Đơn Giản
          RevenueChart(
            model: model,
            onExportRequested: _handleExportRequest,
          ),
          
          const SizedBox(height: 20),
          
          // Top selling products table - Hiển thị ở cả hai dashboard nên chỉ giữ ở Dashboard Đơn Giản
          TopSellingProductsTable(model: model),
          
          const SizedBox(height: 20),
          
          // Revenue by category pie chart - Hiển thị ở cả hai dashboard nên chỉ giữ ở Dashboard Đơn Giản
          CategoryPieChart(model: model, isMobile: isMobile),
        ],
      ),
    );
  }  // Build the Advanced Dashboard view
  Widget _buildAdvancedDashboard(bool isMobile, DashboardModel model) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profit chart - Chỉ hiển thị biểu đồ lợi nhuận ở dashboard nâng cao
          ProfitChart(
            model: model,
            onExportRequested: _handleExportRequest,
          ),
          
          const SizedBox(height: 20),
          
          // Product metrics chart - Chỉ có ở Dashboard Nâng Cao
          ProductMetricsChart(model: model),
          
          const SizedBox(height: 20),
          
          // Compare with previous period toggle - Chỉ có ở Dashboard Nâng Cao
          ComparisonToggle(
            model: model,
            onToggleComparison: _toggleComparison,
          ),
          
          // Show comparison chart if enabled - Chỉ có ở Dashboard Nâng Cao
          if (model.showComparison)
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ComparisonChart(model: model),
            ),
        ],
      ),
    );
  }
}
