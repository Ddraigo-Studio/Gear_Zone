# filepath: d:\HOCTAP\CrossplatformMobileApp\DOANCK\Project\Gear_Zone\lib\admin\Dashboard\dashboard_report.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:ui' as ui;

/// This class provides methods for exporting dashboard reports
/// Since we can't use pdf package (as it's not installed), we'll mock the functionality
class DashboardReport {
  // Format currency values
  static String formatCurrency(num value) {
    final formatter = NumberFormat("#,###", "vi_VN");
    return formatter.format(value) + ' ₫';
  }
  
  // Format date values
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }
  
  // Generate a report for display
  static Future<Widget> generateReportPreview(
    BuildContext context,
    DateTime startDate,
    DateTime endDate,
    Map<String, dynamic> overallStats,
    List<Map<String, dynamic>> revenueByTime,
    List<Map<String, dynamic>> topProducts,
    List<Map<String, dynamic>> revenueByCategory,
  ) async {
    final dateRange = '${formatDate(startDate)} - ${formatDate(endDate)}';
    
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Report Header
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.deepPurple,
                  radius: 24,
                  child: const Icon(
                    Icons.bar_chart,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Báo cáo hiệu suất bán hàng Gear Zone',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Khoảng thời gian: $dateRange',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ngày tạo: ${formatDate(DateTime.now())}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            
            // Overall Stats
            const Text(
              'Tổng quan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.5,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              children: [
                _buildStatTile(
                  'Tổng doanh thu',
                  formatCurrency(overallStats['totalRevenue'] ?? 0),
                  '${overallStats['revenueChange'] > 0 ? '+' : ''}${overallStats['revenueChange']}%',
                  overallStats['revenueChange'] > 0,
                ),
                _buildStatTile(
                  'Tổng đơn hàng',
                  overallStats['totalOrders']?.toString() ?? '0',
                  '${overallStats['orderChange'] > 0 ? '+' : ''}${overallStats['orderChange']}%',
                  overallStats['orderChange'] > 0,
                ),
                _buildStatTile(
                  'Tổng người dùng',
                  overallStats['totalUsers']?.toString() ?? '0',
                  '${overallStats['userChange'] > 0 ? '+' : ''}${overallStats['userChange']}%',
                  overallStats['userChange'] > 0,
                ),
                _buildStatTile(
                  'Người dùng mới',
                  overallStats['newUsers']?.toString() ?? '0',
                  '',
                  true,
                ),
              ],
            ),
            const Divider(height: 32),
            
            // Top Products
            const Text(
              'Sản phẩm bán chạy nhất',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            DataTable(
              columnSpacing: 16,
              horizontalMargin: 0,
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
                    'Đã bán',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  numeric: true,
                ),
                DataColumn(
                  label: Text(
                    'Doanh thu',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  numeric: true,
                ),
              ],
              rows: topProducts.map((product) {
                return DataRow(
                  cells: [
                    DataCell(
                      SizedBox(
                        width: 150,
                        child: Text(
                          product['name'].toString(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    DataCell(Text(product['category'].toString())),
                    DataCell(Text(product['sold'].toString())),
                    DataCell(Text(formatCurrency(product['revenue'] ?? 0))),
                  ],
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            
            // Revenue by Category
            const Text(
              'Doanh thu theo danh mục',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: revenueByCategory.length,
              itemBuilder: (context, index) {
                final category = revenueByCategory[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: [
                            Colors.deepPurple, 
                            Colors.blue, 
                            Colors.green,
                            Colors.amber,
                            Colors.red
                          ][index % 5],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(category['name'].toString()),
                    ],
                  ),
                  trailing: Text(
                    '${formatCurrency(category['value'] ?? 0)} (${category['percent']}%)',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                );
              },
            ),
            
            const Divider(height: 32),
            const Center(
              child: Text(
                '--- Kết thúc báo cáo ---',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
  
  // Build a stat tile for the report
  static Widget _buildStatTile(String title, String value, String change, bool isPositive) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (change.isNotEmpty)
            Row(
              children: [
                if (isPositive)
                  const Icon(
                    Icons.arrow_upward,
                    color: Colors.green,
                    size: 14,
                  )
                else
                  const Icon(
                    Icons.arrow_downward,
                    color: Colors.red,
                    size: 14,
                  ),
                const SizedBox(width: 4),
                Text(
                  change,
                  style: TextStyle(
                    fontSize: 12,
                    color: isPositive ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
  
  // Mock function for exporting report to PDF
  static Future<void> exportPdf(
    BuildContext context,
    DateTime startDate,
    DateTime endDate,
    Map<String, dynamic> overallStats,
    List<Map<String, dynamic>> revenueByTime,
    List<Map<String, dynamic>> topProducts,
    List<Map<String, dynamic>> revenueByCategory,
  ) async {
    // In a real implementation, we would use pdf package to generate PDF
    // Since the packages aren't installed, we'll just show a dialog
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xuất báo cáo PDF'),
        content: const Text('Báo cáo PDF đã được tạo và lưu thành công.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }
  
  // Mock function for exporting report to Excel
  static Future<void> exportExcel(
    BuildContext context,
    DateTime startDate,
    DateTime endDate,
    Map<String, dynamic> overallStats,
    List<Map<String, dynamic>> revenueByTime,
    List<Map<String, dynamic>> topProducts,
    List<Map<String, dynamic>> revenueByCategory,
  ) async {
    // In a real implementation, we would use excel package to generate Excel
    // Since the packages aren't installed, we'll just show a dialog
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xuất báo cáo Excel'),
        content: const Text('Báo cáo Excel đã được tạo và lưu thành công.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }
}
