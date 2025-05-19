import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A reusable filter dialog for dashboard filters
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
              onPrimary: Colors.white,
              surface: Colors.white,
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
              onPrimary: Colors.white,
              surface: Colors.white,
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
      title: const Text('Lọc dữ liệu'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Khoảng thời gian',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            
            // Date range selector
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectStartDate(context),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Từ ngày',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      ),
                      child: Text(_formatDate(_startDate)),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectEndDate(context),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Đến ngày',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      ),
                      child: Text(_formatDate(_endDate)),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            
            // Additional filters
            ..._buildAdditionalFilters(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: () {
            // Apply filters
            widget.onDateRangeChanged(_startDate, _endDate);
            _filters.forEach((key, value) {
              widget.onFilterChanged(key, value);
            });
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
          ),
          child: const Text('Áp dụng'),
        ),
      ],
    );
  }

  List<Widget> _buildAdditionalFilters() {
    final List<Widget> widgets = [];
    
    widget.filterOptions.forEach((key, options) {
      // Skip empty options lists
      if (options.isEmpty) return;
      
      // Format filter title from key
      String title;
      switch (key) {
        case 'categories':
          title = 'Danh mục sản phẩm';
          break;
        case 'regions':
          title = 'Khu vực';
          break;
        case 'salesChannels':
          title = 'Kênh bán hàng';
          break;
        default:
          title = key;
      }
      
      // Get the corresponding filter key
      String filterKey;
      switch (key) {
        case 'categories':
          filterKey = 'category';
          break;
        case 'regions':
          filterKey = 'region';
          break;
        case 'salesChannels':
          filterKey = 'salesChannel';
          break;
        default:
          filterKey = key;
      }
      
      widgets.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _filters[filterKey],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            ),
            isExpanded: true,
            items: options.map((option) {
              return DropdownMenuItem(
                value: option,
                child: Text(option),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _filters[filterKey] = value;
                });
              }
            },
          ),
          const SizedBox(height: 16),
        ],
      ));
    });
    
    return widgets;
  }
}
