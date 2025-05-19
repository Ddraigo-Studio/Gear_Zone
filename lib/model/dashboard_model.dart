import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../controller/dashboard_controller.dart';

class DashboardModel extends ChangeNotifier {
  final DashboardService _service = DashboardService();
  
  // Time filter options
  final List<String> timeFilterOptions = ['Năm', 'Quý', 'Tháng', 'Tuần', 'Tùy chỉnh'];
  String _selectedTimeFilter = 'Năm';
  String get selectedTimeFilter => _selectedTimeFilter;
  
  // Date range
  DateTime _startDate = DateTime(DateTime.now().year, 1, 1);
  DateTime _endDate = DateTime.now();
  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;
  
  // Comparison options
  final List<String> comparisonOptions = ['Năm trước', 'Quý trước', 'Tháng trước', 'Tuần trước'];
  String _comparisonPeriod = 'Năm trước';
  String get comparisonPeriod => _comparisonPeriod;
  bool _showComparison = false;
  bool get showComparison => _showComparison;
    // Additional filters
  final Map<String, String> _additionalFilters = {
    'category': 'Tất cả',
    'region': 'Toàn quốc',
    'salesChannel': 'Tất cả',
  };
  Map<String, String> get additionalFilters => _additionalFilters;
  
  // Filter options
  Map<String, List<String>> _filterOptions = {
    'categories': ['Tất cả'],
    'regions': ['Toàn quốc'],
    'salesChannels': ['Tất cả'],
  };
  Map<String, List<String>> get filterOptions => _filterOptions;
  
  // Loading states
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _isExporting = false;
  bool get isExporting => _isExporting;
  
  // Dashboard data
  Map<String, dynamic> _overallStats = {};
  Map<String, dynamic> get overallStats => _overallStats;
  
  List<Map<String, dynamic>> _revenueByTime = [];
  List<Map<String, dynamic>> get revenueByTime => _revenueByTime;
  
  List<Map<String, dynamic>> _comparisonData = [];
  List<Map<String, dynamic>> get comparisonData => _comparisonData;
  
  List<Map<String, dynamic>> _revenueByCategory = [];
  List<Map<String, dynamic>> get revenueByCategory => _revenueByCategory;
  
  List<Map<String, dynamic>> _ordersByDayOfWeek = [];
  List<Map<String, dynamic>> get ordersByDayOfWeek => _ordersByDayOfWeek;
  
  List<Map<String, dynamic>> _topSellingProducts = [];
  List<Map<String, dynamic>> get topSellingProducts => _topSellingProducts;
  
  // Chart spots for line chart
  List<FlSpot> _revenueSpots = [];
  List<FlSpot> get revenueSpots => _revenueSpots;
  
  List<FlSpot> _previousRevenueSpots = [];
  List<FlSpot> get previousRevenueSpots => _previousRevenueSpots;
  
  List<String> _periodLabels = [];
  List<String> get periodLabels => _periodLabels;
  
  // Constructor
  DashboardModel() {
    _initializeData();
  }
  
  // Initialize dashboard data
  Future<void> _initializeData() async {
    await _loadFilterOptions();
    await _updateDashboardData();
  }
  
  // Load filter options
  Future<void> _loadFilterOptions() async {
    try {
      _filterOptions = await _service.getFilterOptions();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading filter options: $e');
    }
  }
  
  // Set time filter and update data
  void setTimeFilter(String filter) {
    _selectedTimeFilter = filter;
    
    // Update date range based on filter
    final now = DateTime.now();
    
    if (filter != 'Tùy chỉnh') {
      switch (filter) {
        case 'Năm':
          _startDate = DateTime(now.year, 1, 1);
          _endDate = DateTime(now.year, 12, 31);
          break;
        case 'Quý':
          final currentQuarter = (now.month / 3).ceil();
          _startDate = DateTime(now.year, (currentQuarter - 1) * 3 + 1, 1);
          _endDate = DateTime(now.year, currentQuarter * 3, 1);
          // Set to last day of the last month in the quarter
          _endDate = DateTime(_endDate.year, _endDate.month + 1, 0);
          break;
        case 'Tháng':
          _startDate = DateTime(now.year, now.month, 1);
          _endDate = DateTime(now.year, now.month + 1, 0);
          break;
        case 'Tuần':
          // Find the most recent Monday
          _endDate = now;
          _startDate = now.subtract(Duration(days: now.weekday - 1));
          break;
      }
      
      _updateDashboardData();
    }
    
    notifyListeners();
  }
  
  // Set custom date range
  void setCustomDateRange(DateTime start, DateTime end) {
    _startDate = start;
    _endDate = end;
    _updateDashboardData();
    notifyListeners();
  }
  
  
  void toggleComparison(bool show) {
    _showComparison = show;
    if (show) {
      _loadComparisonData();
    }
    notifyListeners();
  }
  
  // Set comparison period
  void setComparisonPeriod(String period) {
    _comparisonPeriod = period;
    if (_showComparison) {
      _loadComparisonData();
    }
    notifyListeners();
  }
    // Set additional filter
  void setAdditionalFilter(String filterKey, String value) {
    _additionalFilters[filterKey] = value;
    _updateDashboardData();
    notifyListeners();
  }
  
  // Update all dashboard data
  Future<void> _updateDashboardData() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await Future.wait([
        _loadOverallStats(),
        _loadRevenueByTime(),
        _loadRevenueByCategory(),
        _loadOrdersByDayOfWeek(),
        _loadTopSellingProducts(),
      ]);
      
      if (_showComparison) {
        await _loadComparisonData();
      }
    } catch (e) {
      debugPrint('Error updating dashboard data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Load overall stats
  Future<void> _loadOverallStats() async {
    try {
      _overallStats = await _service.getOverallStats(_startDate, _endDate);
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading overall stats: $e');
    }
  }
  
  // Load revenue by time
  Future<void> _loadRevenueByTime() async {
    try {
      _revenueByTime = await _service.getRevenueByTime(_startDate, _endDate, _selectedTimeFilter);
      _generateChartData();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading revenue by time: $e');
    }
  }
  
  // Load comparison data
  Future<void> _loadComparisonData() async {
    try {
      // Calculate previous period dates
      DateTime previousStartDate;
      DateTime previousEndDate;
      
      final periodDays = _endDate.difference(_startDate).inDays;
      
      switch (_comparisonPeriod) {
        case 'Năm trước':
          previousStartDate = DateTime(_startDate.year - 1, _startDate.month, _startDate.day);
          previousEndDate = DateTime(_endDate.year - 1, _endDate.month, _endDate.day);
          break;
        case 'Quý trước':
          previousStartDate = _startDate.subtract(Duration(days: 90));
          previousEndDate = _endDate.subtract(Duration(days: 90));
          break;
        case 'Tháng trước':
          previousStartDate = _startDate.subtract(Duration(days: 30));
          previousEndDate = _endDate.subtract(Duration(days: 30));
          break;
        case 'Tuần trước':
          previousStartDate = _startDate.subtract(Duration(days: 7));
          previousEndDate = _endDate.subtract(Duration(days: 7));
          break;
        default:
          previousStartDate = _startDate.subtract(Duration(days: periodDays));
          previousEndDate = _endDate.subtract(Duration(days: periodDays));
      }

      
      _comparisonData = await _service.getComparisonData(
        _startDate, 
        _endDate, 
        previousStartDate, 
        previousEndDate, 
        _selectedTimeFilter
      );
      
      _generateComparisonChartData();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading comparison data: $e');
    }
  }
  
  // Load revenue by category
  Future<void> _loadRevenueByCategory() async {
    try {
      _revenueByCategory = await _service.getRevenueByCategory(_startDate, _endDate);
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading revenue by category: $e');
    }
  }
  
  // Load orders by day of week
  Future<void> _loadOrdersByDayOfWeek() async {
    try {
      _ordersByDayOfWeek = await _service.getOrdersByDayOfWeek(_startDate, _endDate);
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading orders by day of week: $e');
    }
  }
  
  // Load top selling products
  Future<void> _loadTopSellingProducts() async {
    try {
      _topSellingProducts = await _service.getTopSellingProducts(_startDate, _endDate);
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading top selling products: $e');
    }
  }
  
  // Generate chart data for revenue line chart
  void _generateChartData() {
    _revenueSpots = [];
    _periodLabels = [];
    
    for (int i = 0; i < _revenueByTime.length; i++) {
      final data = _revenueByTime[i];
      _revenueSpots.add(FlSpot(i.toDouble(), data['revenue'] / 1000000));
      _periodLabels.add(data['period']);
    }
  }
  
  // Generate comparison chart data
  void _generateComparisonChartData() {
    _previousRevenueSpots = [];
    
    for (int i = 0; i < _comparisonData.length; i++) {
      final data = _comparisonData[i];
      _previousRevenueSpots.add(FlSpot(i.toDouble(), data['revenue'] / 1000000));
    }
  }
  
  // Export report
  Future<String> exportReport(String format) async {
    _isExporting = true;
    notifyListeners();
    
    try {
      final result = await _service.exportReport(format, _startDate, _endDate, _additionalFilters);
      return result;
    } catch (e) {
      debugPrint('Error exporting report: $e');
      return 'Xuất báo cáo thất bại: $e';
    } finally {
      _isExporting = false;
      notifyListeners();
    }
  }
}
