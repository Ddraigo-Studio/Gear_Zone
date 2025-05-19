import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../model/dashboard_model.dart';

/// A reusable table for displaying top selling products
class TopSellingProductsTable extends StatelessWidget {
  final DashboardModel model;
  
  const TopSellingProductsTable({
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
            const Text(
              'Sản phẩm bán chạy nhất',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            _buildProductTable(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildProductTable() {
    if (model.topSellingProducts.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text('Không có dữ liệu'),
        ),
      );
    }
    
    return SingleChildScrollView(
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
    );
  }
}
