import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Service class for handling dashboard data operations
/// This class will connect to backend/database to fetch the required data for the dashboard
class DashboardService {
  // Singleton instance
  static final DashboardService _instance = DashboardService._internal();
  factory DashboardService() => _instance;
  DashboardService._internal();

  // Formatter for currency values
  final currencyFormatter = NumberFormat("#,###", "vi_VN");
    // Get overall stats data (users, orders, revenue, profit)
  Future<Map<String, dynamic>> getOverallStats(DateTime startDate, DateTime endDate) async {
    // In a real application, this would make API calls to your backend
    // For now, we're returning mock data
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network request
    
    return {
      'totalUsers': 8549,
      'newUsers': 1253,
      'activeUsers': 5721,
      'premiumUsers': 924,
      'totalOrders': 4389,
      'avgOrderValue': 325000,
      'totalRevenue': 142000000,
      'totalProfit': 68200000,
      'revenueChange': 15.3,
      'profitChange': 18.7,
      'orderChange': 8.2,
      'userChange': 12.5,
    };
  }
  
  // Get revenue data by time periods
  Future<List<Map<String, dynamic>>> getRevenueByTime(
    DateTime startDate, 
    DateTime endDate,
    String timeInterval
  ) async {
    // In a real application, this would make API calls to your backend
    // For now, we're returning mock data
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network request
    
    // Generate mock data based on time interval
    final List<Map<String, dynamic>> data = [];
    
    if (timeInterval == 'Năm') {
      // Monthly data for a year
      for (int i = 0; i < 12; i++) {
        final revenue = (3.5 + (i * 0.5) + (i % 3 == 0 ? 0.3 : -0.1)) * 1000000;
        final profit = revenue * (0.45 + (i % 5) * 0.01); // Profit is approx 45-50% of revenue
        
        data.add({
          'period': DateFormat('MM/yyyy').format(DateTime(startDate.year, 1 + i, 1)),
          'revenue': revenue,
          'profit': profit,
          'orders': 320 + (i * 15) + (i % 2 == 0 ? 25 : -15),
          'productCount': 145 + (i * 8) + (i % 3 == 0 ? 12 : -5),
          'productTypes': 18 + (i % 4),
        });
      }
    } else if (timeInterval == 'Quý') {
      // Monthly data for a quarter
      final quarterStartMonth = ((startDate.month - 1) ~/ 3) * 3 + 1;
      for (int i = 0; i < 3; i++) {
        final revenue = (5.2 + (i * 0.8) + (i % 2 == 0 ? 0.5 : -0.2)) * 1000000;
        final profit = revenue * (0.46 + (i % 3) * 0.02); // Profit varies between 46-50%
        
        data.add({
          'period': DateFormat('MM/yyyy').format(DateTime(startDate.year, quarterStartMonth + i, 1)),
          'revenue': revenue,
          'profit': profit,
          'orders': 380 + (i * 25) + (i % 2 == 0 ? 35 : -20),
          'productCount': 160 + (i * 12),
          'productTypes': 15 + (i % 3),
        });
      }
    } else if (timeInterval == 'Tháng') {
      // Weekly data for a month
      for (int i = 0; i < 4; i++) {
        final revenue = (1.2 + (i * 0.3) + (i % 2 == 0 ? 0.2 : -0.1)) * 1000000;
        final profit = revenue * (0.47 + (i % 3) * 0.01);
        
        data.add({
          'period': 'Tuần ${i+1}',
          'revenue': revenue,
          'profit': profit,
          'orders': 280 + (i * 18) + (i % 2 == 0 ? 15 : -10),
          'productCount': 85 + (i * 7),
          'productTypes': 12 + (i % 3),
        });
      }
    } else if (timeInterval == 'Tuần') {
      // Daily data for a week
      final weekStart = startDate;
      for (int i = 0; i < 7; i++) {
        final day = weekStart.add(Duration(days: i));
        final revenue = (0.4 + (i * 0.06) + (i % 3 == 0 ? 0.1 : -0.05)) * 1000000;
        final profit = revenue * (0.48 + (i % 2) * 0.02);
        
        data.add({
          'period': DateFormat('E').format(day),
          'revenue': revenue,
          'profit': profit,
          'orders': 80 + (i * 8) + (i < 5 ? 10 : -15), // Weekdays have more orders
          'productCount': 25 + (i * 3) + (i < 5 ? 5 : -3),
          'productTypes': 8 + (i % 3),
        });
      }
    } else {
      // Custom range - show daily data for up to 30 days or weekly data for longer periods
      final daysDifference = endDate.difference(startDate).inDays;
      
      if (daysDifference <= 30) {
        // Daily data
        for (int i = 0; i <= daysDifference; i++) {
          final day = startDate.add(Duration(days: i));
          final revenue = (0.5 + (i % 7) * 0.1 + (i % 5 == 0 ? 0.2 : -0.1)) * 1000000;
          final profit = revenue * (0.47 + (day.weekday % 2) * 0.01);
          
          data.add({
            'period': DateFormat('dd/MM').format(day),
            'revenue': revenue,
            'profit': profit,
            'orders': 75 + (i % 7) * 5 + (i % 5 == 0 ? 15 : -5),
            'productCount': 22 + (i % 7) * 2,
            'productTypes': 6 + (i % 4),
          });
        }
      } else {
        // Weekly data
        final weeksDifference = (daysDifference / 7).ceil();
        for (int i = 0; i < weeksDifference; i++) {
          final weekStart = startDate.add(Duration(days: i * 7));
          final weekEnd = weekStart.add(const Duration(days: 6));
          final revenue = (1.1 + (i * 0.2) + (i % 3 == 0 ? 0.3 : -0.1)) * 1000000;
          final profit = revenue * (0.46 + (i % 4) * 0.01);
          
          data.add({
            'period': '${DateFormat('dd/MM').format(weekStart)} - ${DateFormat('dd/MM').format(weekEnd)}',
            'revenue': revenue,
            'profit': profit,
            'orders': 285 + (i * 15) + (i % 3 == 0 ? 20 : -10),
            'productCount': 75 + (i * 8),
            'productTypes': 10 + (i % 5),
          });
        }
      }
    }
    
    return data;
  }
  
  // Get revenue breakdown by product categories
  Future<List<Map<String, dynamic>>> getRevenueByCategory(
    DateTime startDate, 
    DateTime endDate
  ) async {
    // In a real application, this would make API calls to your backend
    // For now, we're returning mock data
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network request
    
    return [
      {
        'category': 'Gaming Laptop',
        'revenue': 45000000,
        'percentage': 31.7,
        'color': Colors.blue,
      },
      {
        'category': 'Gaming Accessories',
        'revenue': 32000000,
        'percentage': 22.5,
        'color': Colors.green,
      },
      {
        'category': 'Gaming Monitors',
        'revenue': 28000000,
        'percentage': 19.7,
        'color': Colors.orange,
      },
      {
        'category': 'Gaming PC',
        'revenue': 20000000,
        'percentage': 14.1,
        'color': Colors.red,
      },
      {
        'category': 'Components',
        'revenue': 17000000,
        'percentage': 12.0,
        'color': Colors.purple,
      },
    ];
  }
  
  // Get orders by day of week
  Future<List<Map<String, dynamic>>> getOrdersByDayOfWeek(
    DateTime startDate, 
    DateTime endDate
  ) async {
    // In a real application, this would make API calls to your backend
    // For now, we're returning mock data
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network request
    
    return [
      {'day': 'Mon', 'orders': 135},
      {'day': 'Tue', 'orders': 122},
      {'day': 'Wed', 'orders': 145},
      {'day': 'Thu', 'orders': 132},
      {'day': 'Fri', 'orders': 152},
      {'day': 'Sat', 'orders': 178},
      {'day': 'Sun', 'orders': 156},
    ];
  }
  
  // Get top selling products
  Future<List<Map<String, dynamic>>> getTopSellingProducts(
    DateTime startDate, 
    DateTime endDate
  ) async {
    // In a real application, this would make API calls to your backend
    // For now, we're returning mock data
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network request
    
    return [
      {
        'id': 'P001',
        'name': 'ASUS ROG Strix G15',
        'category': 'Gaming Laptop',
        'unitsSold': 85,
        'revenue': 2125000000,
        'image': 'assets/images/products/asus_rog.png',
        'inStock': true,
      },
      {
        'id': 'P002',
        'name': 'MSI GS66 Stealth',
        'category': 'Gaming Laptop',
        'unitsSold': 75,
        'revenue': 1875000000,
        'image': 'assets/images/products/msi_gs66.png',
        'inStock': true,
      },
      {
        'id': 'P003',
        'name': 'Logitech G Pro X Superlight',
        'category': 'Gaming Accessories',
        'unitsSold': 120,
        'revenue': 180000000,
        'image': 'assets/images/products/logitect_gpro.png',
        'inStock': true,
      },
      {
        'id': 'P004',
        'name': 'Samsung Odyssey G7',
        'category': 'Gaming Monitors',
        'unitsSold': 65,
        'revenue': 975000000,
        'image': 'assets/images/products/samsung_odyssey.png',
        'inStock': true,
      },
      {
        'id': 'P005',
        'name': 'Razer BlackShark V2 Pro',
        'category': 'Gaming Accessories',
        'unitsSold': 95,
        'revenue': 142500000,
        'image': 'assets/images/products/razer_blackshark.png',
        'inStock': false,
      },
    ];
  }
    // Get filter options for dropdowns
  Future<Map<String, List<String>>> getFilterOptions() async {
    await Future.delayed(const Duration(milliseconds: 300)); // Simulate network request
    
    return {
      'categories': ['Tất cả', 'Gaming Laptop', 'Gaming PC', 'Gaming Monitors', 'Components', 'Gaming Accessories'],
      'regions': ['Toàn quốc', 'Miền Bắc', 'Miền Trung', 'Miền Nam', 'Hà Nội', 'TP HCM'],
      'salesChannels': ['Tất cả', 'Online', 'Cửa hàng', 'Đại lý', 'Marketplace'],
    };
  }
    // Get comparison data for the selected time period
  Future<List<Map<String, dynamic>>> getComparisonData(
    DateTime currentStartDate,
    DateTime currentEndDate,
    DateTime previousStartDate,
    DateTime previousEndDate,
    String timeInterval
  ) async {
    // In a real application, this would make API calls to your backend
    // For now, we're generating comparative mock data
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network request
    
    // Generate mock data based on time interval
    final List<Map<String, dynamic>> data = [];
    
    if (timeInterval == 'Năm') {
      // Monthly data for a year
      for (int i = 0; i < 12; i++) {
        final revenue = (3.0 + (i * 0.4) + (i % 3 == 0 ? 0.2 : -0.1)) * 1000000;
        final profit = revenue * (0.43 + (i % 5) * 0.01); // Profit is approx 43-48% of revenue (lower than current year)
        
        data.add({
          'period': DateFormat('MM/yyyy').format(DateTime(previousStartDate.year, 1 + i, 1)),
          'revenue': revenue,
          'profit': profit,
          'orders': 280 + (i * 12) + (i % 2 == 0 ? 20 : -10),
          'productCount': 130 + (i * 7) + (i % 3 == 0 ? 10 : -4),
          'productTypes': 16 + (i % 4),
        });
      }
    } else if (timeInterval == 'Quý') {
      // Monthly data for a quarter
      final quarterStartMonth = ((previousStartDate.month - 1) ~/ 3) * 3 + 1;
      for (int i = 0; i < 3; i++) {
        final revenue = (4.5 + (i * 0.6) + (i % 2 == 0 ? 0.4 : -0.1)) * 1000000;
        final profit = revenue * (0.44 + (i % 3) * 0.01); // Profit varies between 44-47%
        
        data.add({
          'period': DateFormat('MM/yyyy').format(DateTime(previousStartDate.year, quarterStartMonth + i, 1)),
          'revenue': revenue,
          'profit': profit,
          'orders': 340 + (i * 20) + (i % 2 == 0 ? 25 : -15),
          'productCount': 145 + (i * 10),
          'productTypes': 14 + (i % 3),
        });
      }
    } else if (timeInterval == 'Tháng') {
      // Weekly data for a month
      for (int i = 0; i < 4; i++) {
        final revenue = (1.2 + (i * 0.25) + (i % 2 == 0 ? 0.15 : -0.08)) * 1000000;
        final profit = revenue * (0.45 + (i % 3) * 0.01);
        
        data.add({
          'period': 'Tuần ${i+1}',
          'revenue': revenue,
          'profit': profit,
          'orders': 85 + (i * 10) + (i % 2 == 0 ? 7 : -4),
          'productCount': 78 + (i * 6),
          'productTypes': 11 + (i % 3),
        });
      }
    } else if (timeInterval == 'Tuần') {
      // Daily data for a week
      for (int i = 0; i < 7; i++) {
        final date = previousStartDate.add(Duration(days: i));
        final revenue = (0.4 + (i * 0.1) + (i % 3 == 0 ? 0.12 : -0.04)) * 1000000;
        final profit = revenue * (0.45 + (i % 2) * 0.02);
        
        data.add({
          'period': DateFormat('EEE').format(date),
          'revenue': revenue,
          'profit': profit,
          'orders': 30 + (i * 4) + (i % 2 == 0 ? 8 : -6),
          'productCount': 22 + (i * 2) + (i < 5 ? 5 : -2),
          'productTypes': 7 + (i % 3),
        });
      }
    } else {
      // Custom range - generate daily data
      final daysDiff = previousEndDate.difference(previousStartDate).inDays;
      final dataPoints = daysDiff > 30 ? 30 : daysDiff;
      
      for (int i = 0; i < dataPoints; i++) {
        final date = previousStartDate.add(Duration(days: (daysDiff / dataPoints * i).round()));
        final revenue = (0.7 + (i * 0.08) + (i % 3 == 0 ? 0.15 : -0.08)) * 1000000;
        final profit = revenue * (0.44 + (date.weekday % 2) * 0.01);
        
        data.add({
          'period': DateFormat('dd/MM').format(date),
          'revenue': revenue,
          'profit': profit,
          'orders': 35 + (i * 2) + (i % 2 == 0 ? 6 : -3),
          'productCount': 20 + (i % 7) * 2,
          'productTypes': 5 + (i % 4),
        });
      }
    }
    
    return data;
  }
  
  // Export dashboard data as a report
  Future<String> exportReport(
    String format,
    DateTime startDate,
    DateTime endDate,
    Map<String, String> filters
  ) async {
    // In a real application, this would generate a report file and return the download URL
    await Future.delayed(const Duration(seconds: 1)); // Simulate report generation
    
    // Format date range for the report file name
    final startDateStr = DateFormat('yyyyMMdd').format(startDate);
    final endDateStr = DateFormat('yyyyMMdd').format(endDate);
    
    // Create report name based on format and date range
    final reportName = 'gear_zone_report_${startDateStr}_${endDateStr}';
    final reportExt = format.toLowerCase();
    
    // In a real application, this would be a download URL
    return 'Báo cáo đã được xuất thành công: $reportName.$reportExt';
  }
}
