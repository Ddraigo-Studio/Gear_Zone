import 'package:flutter/material.dart';
import 'dashboard_report.dart';

class ReportPreviewScreen extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  final Map<String, dynamic> overallStats;
  final List<Map<String, dynamic>> revenueByTime;
  final List<Map<String, dynamic>> topProducts;
  final List<Map<String, dynamic>> revenueByCategory;

  const ReportPreviewScreen({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.overallStats,
    required this.revenueByTime,
    required this.topProducts,
    required this.revenueByCategory,
  });

  @override
  State<ReportPreviewScreen> createState() => _ReportPreviewScreenState();
}

class _ReportPreviewScreenState extends State<ReportPreviewScreen> {
  late Future<Widget> _reportFuture;

  @override
  void initState() {
    super.initState();
    _reportFuture = DashboardReport.generateReportPreview(
      context,
      widget.startDate,
      widget.endDate,
      widget.overallStats,
      widget.revenueByTime,
      widget.topProducts,
      widget.revenueByCategory,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xem trước báo cáo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_alt),
            tooltip: 'Lưu PDF',
            onPressed: () {
              DashboardReport.exportPdf(
                context,
                widget.startDate,
                widget.endDate,
                widget.overallStats,
                widget.revenueByTime,
                widget.topProducts,
                widget.revenueByCategory,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.table_chart),
            tooltip: 'Xuất Excel',
            onPressed: () {
              DashboardReport.exportExcel(
                context,
                widget.startDate,
                widget.endDate,
                widget.overallStats,
                widget.revenueByTime,
                widget.topProducts,
                widget.revenueByCategory,
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<Widget>(
        future: _reportFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
            );
          }
          
          return snapshot.data ?? const SizedBox.shrink();
        },
      ),
    );
  }
}
