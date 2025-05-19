import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardFilterDialog extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  final Map<String, String> additionalFilters;
  final Map<String, List<String>> filterOptions;
  final Function(DateTime, DateTime) onDateRangeChanged;
  final Function(String, String) onFilterChanged;

  const DashboardFilterDialog({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.additionalFilters,
    required this.filterOptions,
    required this.onDateRangeChanged,
    required this.onFilterChanged,
  });

  @override
  State<DashboardFilterDialog> createState() => _DashboardFilterDialogState();
}

class _DashboardFilterDialogState extends State<DashboardFilterDialog> {
  late DateTime _startDate;
  late DateTime _endDate;
  late Map<String, String> _filters;

  @override
  void initState() {
    super.initState();
    _startDate = widget.startDate;
    _endDate = widget.endDate;
    _filters = Map.from(widget.additionalFilters);
  }

  // Format date for display
  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  // Show date picker for start date
  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: _endDate,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.deepPurple,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  // Show date picker for end date
  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: _startDate,
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.deepPurple,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Bộ lọc nâng cao'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date range
            const Text(
              'Khoảng thời gian',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Start date
            Row(
              children: [
                const Text('Từ ngày:'),
                const Spacer(),
                TextButton(
                  onPressed: () => _selectStartDate(context),
                  child: Text(_formatDate(_startDate)),
                ),
              ],
            ),
            
            // End date
            Row(
              children: [
                const Text('Đến ngày:'),
                const Spacer(),
                TextButton(
                  onPressed: () => _selectEndDate(context),
                  child: Text(_formatDate(_endDate)),
                ),
              ],
            ),
            
            const Divider(height: 32),
            
            // Product category filter
            if (widget.filterOptions.containsKey('categories')) ...[
              const Text(
                'Danh mục sản phẩm',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _filters['category'],
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  border: OutlineInputBorder(),
                ),
                items: widget.filterOptions['categories']!.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _filters['category'] = newValue;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
            ],
            
            // Region filter
            if (widget.filterOptions.containsKey('regions')) ...[
              const Text(
                'Khu vực',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _filters['region'],
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  border: OutlineInputBorder(),
                ),
                items: widget.filterOptions['regions']!.map((region) {
                  return DropdownMenuItem<String>(
                    value: region,
                    child: Text(region),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _filters['region'] = newValue;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
            ],
            
            // Sales channel filter
            if (widget.filterOptions.containsKey('salesChannels')) ...[
              const Text(
                'Kênh bán hàng',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _filters['salesChannel'],
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  border: OutlineInputBorder(),
                ),
                items: widget.filterOptions['salesChannels']!.map((channel) {
                  return DropdownMenuItem<String>(
                    value: channel,
                    child: Text(channel),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _filters['salesChannel'] = newValue;
                    });
                  }
                },
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            widget.onDateRangeChanged(_startDate, _endDate);
            
            // Apply all filters
            _filters.forEach((key, value) {
              widget.onFilterChanged(key, value);
            });
            
            Navigator.of(context).pop();
          },
          child: const Text('Áp dụng'),
        ),
      ],
    );
  }
}
