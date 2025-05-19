import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../model/dashboard_model.dart';

/// A reusable time filter selector widget
class TimeFilterSelector extends StatelessWidget {
  final DashboardModel model;
  final Function(BuildContext, DashboardModel) showDateRangePicker;
  
  const TimeFilterSelector({
    Key? key, 
    required this.model,
    required this.showDateRangePicker,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  showDateRangePicker(context, model);
                } else {
                  model.setTimeFilter(value);
                }
              }
            },
          ),
        ),
      ),
    );
  }
}

/// Format a period string based on filter type and dates
String getCurrentPeriodDisplay(DashboardModel model) {
  final selectedFilter = model.selectedTimeFilter;
  final endDate = model.endDate;
  
  switch (selectedFilter) {
    case 'Năm':
      return 'Năm ${endDate.year}';
    case 'Quý':
      final quarter = (endDate.month / 3).ceil();
      return 'Quý $quarter/${endDate.year}';
    case 'Tháng':
      return DateFormat('MM/yyyy').format(endDate);
    case 'Tuần':
      final weekNumber = (endDate.difference(DateTime(endDate.year, 1, 1)).inDays / 7).ceil();
      return 'Tuần $weekNumber/${endDate.year}';
    case 'Tùy chỉnh':
      return '${DateFormat('dd/MM/yyyy').format(model.startDate)} - ${DateFormat('dd/MM/yyyy').format(endDate)}';
    default:
      return 'Tất cả thời gian';
  }
}
