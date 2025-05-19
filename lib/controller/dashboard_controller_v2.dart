import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/order.dart';
import './dashboard_cache_service.dart';

/// Service class for handling dashboard data operations
/// This improved version uses caching to reduce Firestore read operations
class DashboardServiceV2 {
  // Singleton instance
  static final DashboardServiceV2 _instance = DashboardServiceV2._internal();
  factory DashboardServiceV2() => _instance;
  DashboardServiceV2._internal();
  
  // Firebase Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Cache service
  final DashboardCacheService _cacheService = DashboardCacheService();

  // Formatter for currency values
  final currencyFormatter = NumberFormat("#,###", "vi_VN");
  
  // Get overall stats data (users, orders, revenue, profit)
  Future<Map<String, dynamic>> getOverallStats(DateTime startDate, DateTime endDate) async {
    // Create a cache key based on the date range
    final String cacheKey = _cacheService.createCacheKey('overallStats', startDate, endDate);
    
    // Check if we have valid cached data
    final cachedData = _cacheService.getFromCache<Map<String, dynamic>>(cacheKey);
    if (cachedData != null) {
      return cachedData;
    }
    
    try {
      // Get user statistics
      final usersSnapshot = await _firestore.collection('users').get();
      final totalUsers = usersSnapshot.size;
      
      // Calculate new users in the date range
      final newUsersSnapshot = await _firestore
          .collection('users')
          .where('createdAt', isGreaterThanOrEqualTo: startDate)
          .where('createdAt', isLessThanOrEqualTo: endDate)
          .get();
      final newUsers = newUsersSnapshot.size;
      
      // Get orders in the date range
      final ordersSnapshot = await _firestore
          .collection('orders')
          .where('orderDate', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('orderDate', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .get();
      
      final totalOrders = ordersSnapshot.size;
      
      // Calculate revenue and profit
      double totalRevenue = 0;
      double totalProfit = 0;
      
      for (final doc in ordersSnapshot.docs) {
        final orderData = doc.data();
        final orderTotal = (orderData['total'] ?? 0).toDouble();
        totalRevenue += orderTotal;
        
        // Estimate profit as 40% of revenue (you can adjust this or calculate based on actual product costs)
        totalProfit += (orderTotal * 0.40);
      }
      
      // Calculate average order value
      double avgOrderValue = totalOrders > 0 ? totalRevenue / totalOrders : 0;
      
      // Calculate previous period for comparison
      final previousPeriodStart = startDate.subtract(endDate.difference(startDate));
      final previousPeriodEnd = startDate.subtract(const Duration(days: 1));
      
      // Get previous period orders for comparison
      final previousOrdersSnapshot = await _firestore
          .collection('orders')
          .where('orderDate', isGreaterThanOrEqualTo: Timestamp.fromDate(previousPeriodStart))
          .where('orderDate', isLessThanOrEqualTo: Timestamp.fromDate(previousPeriodEnd))
          .get();
      
      final previousOrders = previousOrdersSnapshot.size;
      double previousRevenue = 0;
      double previousProfit = 0;
      
      for (final doc in previousOrdersSnapshot.docs) {
        final orderData = doc.data();
        final orderTotal = (orderData['total'] ?? 0).toDouble();
        previousRevenue += orderTotal;
        previousProfit += (orderTotal * 0.40);
      }
      
      // Calculate percentage changes
      final revenueChange = previousRevenue > 0 
          ? ((totalRevenue - previousRevenue) / previousRevenue * 100) 
          : 0.0;
      final profitChange = previousProfit > 0 
          ? ((totalProfit - previousProfit) / previousProfit * 100) 
          : 0.0;
      final orderChange = previousOrders > 0 
          ? ((totalOrders - previousOrders) / previousOrders * 100) 
          : 0.0;
      
      // Get previous period users for comparison
      final previousUsersSnapshot = await _firestore
          .collection('users')
          .where('createdAt', isGreaterThanOrEqualTo: previousPeriodStart)
          .where('createdAt', isLessThanOrEqualTo: previousPeriodEnd)
          .get();
      
      final previousNewUsers = previousUsersSnapshot.size;
      final userChange = previousNewUsers > 0 
          ? ((newUsers - previousNewUsers) / previousNewUsers * 100) 
          : 0.0;
      
      final result = {
        'totalUsers': totalUsers,
        'newUsers': newUsers,
        'activeUsers': totalUsers, // Can be refined with actual login data
        'premiumUsers': 0, // Can be refined if you have premium user data
        'totalOrders': totalOrders,
        'avgOrderValue': avgOrderValue,
        'totalRevenue': totalRevenue,
        'totalProfit': totalProfit,
        'revenueChange': revenueChange,
        'profitChange': profitChange,
        'orderChange': orderChange,
        'userChange': userChange,
      };
      
      // Cache the result
      _cacheService.storeInCache(cacheKey, result);
      
      return result;
    } catch (e) {
      debugPrint('Error retrieving dashboard stats: $e');
      // Return empty data with zeros in case of error
      return {
        'totalUsers': 0,
        'newUsers': 0,
        'activeUsers': 0,
        'premiumUsers': 0,
        'totalOrders': 0,
        'avgOrderValue': 0,
        'totalRevenue': 0,
        'totalProfit': 0,
        'revenueChange': 0,
        'profitChange': 0,
        'orderChange': 0,
        'userChange': 0,
      };
    }
  }
  
  // Get revenue data by time periods from Firestore
  Future<List<Map<String, dynamic>>> getRevenueByTime(
    DateTime startDate, 
    DateTime endDate,
    String timeInterval
  ) async {
    final cacheKey = _cacheService.createCacheKey('revenueByTime', startDate, endDate, timeInterval);
    
    // Check cache first
    final cachedData = _cacheService.getFromCache<List<Map<String, dynamic>>>(cacheKey);
    if (cachedData != null) {
      return cachedData;
    }
    
    try {
      // Get all orders within the date range
      final ordersSnapshot = await _firestore
          .collection('orders')
          .where('orderDate', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('orderDate', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .get();
          
      // Convert to OrderModel objects for easier processing
      final List<OrderModel> orders = ordersSnapshot.docs
          .map((doc) => OrderModel.fromFirestore(doc))
          .toList();
      
      // Generate time-segmented data based on time interval
      final List<Map<String, dynamic>> data = [];
      
      if (timeInterval == 'Năm') {
        // Monthly data for a year
        // Initialize data for each month with zeros
        for (int i = 0; i < 12; i++) {
          final date = DateTime(startDate.year, 1 + i, 1);
          data.add({
            'period': DateFormat('MM/yyyy').format(date),
            'revenue': 0.0,
            'profit': 0.0,
            'orders': 0,
            'productCount': 0,
            'productTypes': 0,
          });
        }
        
        // Process each order
        for (final order in orders) {
          final month = order.orderDate.month - 1; // 0-based index
          
          // Update revenue and order count for this month
          data[month]['revenue'] += order.total;
          data[month]['profit'] += (order.total * 0.4); // Estimate profit as 40% of revenue
          data[month]['orders'] = (data[month]['orders'] as int) + 1;
          
          // Track unique products
          final Set<String> uniqueProducts = {};
          final Set<String> uniqueCategories = {};
          
          for (final item in order.items) {
            uniqueProducts.add(item.productId);
            // If you have category info in OrderItem, you could track it here
          }
          
          // Update product counts
          data[month]['productCount'] += uniqueProducts.length;
          data[month]['productTypes'] = uniqueCategories.length;
        }
      } else if (timeInterval == 'Quý') {
        // Monthly data for a quarter
        final quarterStartMonth = ((startDate.month - 1) ~/ 3) * 3 + 1;
        
        // Initialize data for each month in the quarter with zeros
        for (int i = 0; i < 3; i++) {
          final date = DateTime(startDate.year, quarterStartMonth + i, 1);
          data.add({
            'period': DateFormat('MM/yyyy').format(date),
            'revenue': 0.0,
            'profit': 0.0,
            'orders': 0,
            'productCount': 0,
            'productTypes': 0,
          });
        }
        
        // Process each order
        for (final order in orders) {
          // Only process orders within this quarter
          if (order.orderDate.month >= quarterStartMonth && 
              order.orderDate.month < quarterStartMonth + 3) {
            
            final monthIndex = order.orderDate.month - quarterStartMonth;
            if (monthIndex >= 0 && monthIndex < 3) {
              // Update revenue and order count for this month
              data[monthIndex]['revenue'] += order.total;
              data[monthIndex]['profit'] += (order.total * 0.4); // Estimate profit as 40% of revenue
              data[monthIndex]['orders'] = (data[monthIndex]['orders'] as int) + 1;
              
              // Track unique products
              final Set<String> uniqueProducts = {};
              final Set<String> uniqueCategories = {};
              
              for (final item in order.items) {
                uniqueProducts.add(item.productId);
              }
              
              // Update product counts
              data[monthIndex]['productCount'] += uniqueProducts.length;
              data[monthIndex]['productTypes'] = uniqueCategories.length;
            }
          }
        }
      } else if (timeInterval == 'Tháng') {
        // Weekly data for a month
        // Calculate the start of each week within the month
        final List<DateTime> weekStarts = [];
        DateTime current = DateTime(startDate.year, startDate.month, 1);
        
        // Create 4 weeks (or actual number of weeks in the month)
        for (int i = 0; i < 4; i++) {
          weekStarts.add(current);
          current = current.add(const Duration(days: 7));
        }
        
        // Initialize data for each week with zeros
        for (int i = 0; i < weekStarts.length; i++) {
          data.add({
            'period': 'Tuần ${i+1}',
            'revenue': 0.0,
            'profit': 0.0,
            'orders': 0,
            'productCount': 0,
            'productTypes': 0,
          });
        }
        
        // Process each order
        for (final order in orders) {
          // Only process orders within the selected month
          if (order.orderDate.year == startDate.year && 
              order.orderDate.month == startDate.month) {
            
            // Determine which week this order belongs to
            int weekIndex = 0;
            for (int i = 1; i < weekStarts.length; i++) {
              if (order.orderDate.isAfter(weekStarts[i])) {
                weekIndex = i;
              }
            }
            
            if (weekIndex < data.length) {
              // Update revenue and order count for this week
              data[weekIndex]['revenue'] += order.total;
              data[weekIndex]['profit'] += (order.total * 0.4); // Estimate profit as 40% of revenue
              data[weekIndex]['orders'] = (data[weekIndex]['orders'] as int) + 1;
              
              // Track unique products
              final Set<String> uniqueProducts = {};
              final Set<String> uniqueCategories = {};
              
              for (final item in order.items) {
                uniqueProducts.add(item.productId);
              }
              
              // Update product counts
              data[weekIndex]['productCount'] += uniqueProducts.length;
              data[weekIndex]['productTypes'] = uniqueCategories.length;
            }
          }
        }
      } else if (timeInterval == 'Tuần') {
        // Daily data for a week
        // Initialize data for each day with zeros
        for (int i = 0; i < 7; i++) {
          final day = startDate.add(Duration(days: i));
          data.add({
            'period': DateFormat('E').format(day),
            'revenue': 0.0,
            'profit': 0.0,
            'orders': 0,
            'productCount': 0,
            'productTypes': 0,
          });
        }
        
        // Process each order
        for (final order in orders) {
          // Calculate the day index (0-6) within the week
          final difference = order.orderDate.difference(startDate).inDays;
          if (difference >= 0 && difference < 7) {
            // Update revenue and order count for this day
            data[difference]['revenue'] += order.total;
            data[difference]['profit'] += (order.total * 0.4); // Estimate profit as 40% of revenue
            data[difference]['orders'] = (data[difference]['orders'] as int) + 1;
            
            // Track unique products
            final Set<String> uniqueProducts = {};
            final Set<String> uniqueCategories = {};
            
            for (final item in order.items) {
              uniqueProducts.add(item.productId);
            }
            
            // Update product counts
            data[difference]['productCount'] += uniqueProducts.length;
            data[difference]['productTypes'] = uniqueCategories.length;
          }
        }
      } else {
        // Custom range - show daily data for up to 30 days or weekly data for longer periods
        final daysDifference = endDate.difference(startDate).inDays;
        
        if (daysDifference <= 30) {
          // Daily data
          // Initialize data for each day with zeros
          for (int i = 0; i <= daysDifference; i++) {
            final day = startDate.add(Duration(days: i));
            data.add({
              'period': DateFormat('dd/MM').format(day),
              'revenue': 0.0,
              'profit': 0.0,
              'orders': 0,
              'productCount': 0,
              'productTypes': 0,
            });
          }
          
          // Process each order
          for (final order in orders) {
            final difference = order.orderDate.difference(startDate).inDays;
            if (difference >= 0 && difference <= daysDifference) {
              // Update revenue and order count for this day
              data[difference]['revenue'] += order.total;
              data[difference]['profit'] += (order.total * 0.4); // Estimate profit as 40% of revenue
              data[difference]['orders'] = (data[difference]['orders'] as int) + 1;
              
              // Track unique products
              final Set<String> uniqueProducts = {};
              final Set<String> uniqueCategories = {};
              
              for (final item in order.items) {
                uniqueProducts.add(item.productId);
              }
              
              // Update product counts
              data[difference]['productCount'] += uniqueProducts.length;
              data[difference]['productTypes'] = uniqueCategories.length;
            }
          }
        } else {
          // Weekly data
          final weeksDifference = (daysDifference / 7).ceil();
          
          // Initialize data for each week with zeros
          for (int i = 0; i < weeksDifference; i++) {
            final weekStart = startDate.add(Duration(days: i * 7));
            final weekEnd = weekStart.add(const Duration(days: 6));
            data.add({
              'period': '${DateFormat('dd/MM').format(weekStart)} - ${DateFormat('dd/MM').format(weekEnd)}',
              'revenue': 0.0,
              'profit': 0.0,
              'orders': 0,
              'productCount': 0,
              'productTypes': 0,
            });
          }
          
          // Process each order
          for (final order in orders) {
            final difference = order.orderDate.difference(startDate).inDays;
            if (difference >= 0 && difference <= daysDifference) {
              final weekIndex = difference ~/ 7;
              if (weekIndex < data.length) {
                // Update revenue and order count for this week
                data[weekIndex]['revenue'] += order.total;
                data[weekIndex]['profit'] += (order.total * 0.4); // Estimate profit as 40% of revenue
                data[weekIndex]['orders'] = (data[weekIndex]['orders'] as int) + 1;
                
                // Track unique products
                final Set<String> uniqueProducts = {};
                final Set<String> uniqueCategories = {};
                
                for (final item in order.items) {
                  uniqueProducts.add(item.productId);
                }
                
                // Update product counts
                data[weekIndex]['productCount'] += uniqueProducts.length;
                data[weekIndex]['productTypes'] = uniqueCategories.length;
              }
            }
          }
        }
      }
      
      // Cache the data
      _cacheService.storeInCache(cacheKey, data);
      
      return data;
    } catch (e) {
      debugPrint('Error getting revenue by time: $e');
      return [];
    }
  }
  
  // Get revenue breakdown by product categories with caching
  Future<List<Map<String, dynamic>>> getRevenueByCategory(
    DateTime startDate, 
    DateTime endDate
  ) async {
    final cacheKey = _cacheService.createCacheKey('revenueByCategory', startDate, endDate);
    
    // Check cache first
    final cachedData = _cacheService.getFromCache<List<Map<String, dynamic>>>(cacheKey);
    if (cachedData != null) {
      return cachedData;
    }
    
    try {
      // Get all orders within the date range
      final ordersSnapshot = await _firestore
          .collection('orders')
          .where('orderDate', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('orderDate', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .get();
          
      // Convert to OrderModel objects for easier processing
      final List<OrderModel> orders = ordersSnapshot.docs
          .map((doc) => OrderModel.fromFirestore(doc))
          .toList();
      
      // Map to track revenue by category
      Map<String, double> categoryRevenue = {};
      double totalRevenue = 0.0;
      
      // Now we need to get product information for each order item to determine categories
      for (final order in orders) {
        for (final item in order.items) {
          try {
            // Get product information to determine category
            final productDoc = await _firestore.collection('products').doc(item.productId).get();
            
            if (productDoc.exists) {
              final productData = productDoc.data() as Map<String, dynamic>;
              final category = productData['category'] ?? 'Uncategorized';
              
              // Calculate revenue for this item
              final itemRevenue = item.price * item.quantity;
              totalRevenue += itemRevenue;
              
              // Add to category revenue
              if (categoryRevenue.containsKey(category)) {
                categoryRevenue[category] = categoryRevenue[category]! + itemRevenue;
              } else {
                categoryRevenue[category] = itemRevenue;
              }
            }
          } catch (e) {
            debugPrint('Error getting product details for ${item.productId}: $e');
          }
        }
      }
      
      // Convert to the expected format
      final List<Map<String, dynamic>> result = [];
      
      // Define colors for categories
      final List<Color> colors = [
        Colors.blue,
        Colors.green,
        Colors.orange,
        Colors.red,
        Colors.purple,
        Colors.teal,
        Colors.amber,
        Colors.indigo,
      ];
      
      int colorIndex = 0;
      categoryRevenue.forEach((category, revenue) {
        final percentage = totalRevenue > 0 ? (revenue / totalRevenue * 100) : 0.0;
        
        result.add({
          'category': category,
          'revenue': revenue,
          'percentage': percentage,
          'color': colors[colorIndex % colors.length],
        });
        
        colorIndex++;
      });
      
      // Sort by revenue descending
      result.sort((a, b) => (b['revenue'] as double).compareTo(a['revenue'] as double));
      
      // Cache the result
      _cacheService.storeInCache(cacheKey, result);
      
      return result;
    } catch (e) {
      debugPrint('Error getting revenue by category: $e');
      return [];
    }
  }
  
  // Clear all cached data
  void clearCache() {
    _cacheService.clearCache();
  }
  
  // Get current cache size
  int get cacheSize => _cacheService.cacheSize;
}
