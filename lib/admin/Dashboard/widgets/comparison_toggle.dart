import 'package:flutter/material.dart';
import '../../../model/dashboard_model.dart';

/// A widget for toggling comparison mode on the dashboard
class ComparisonToggle extends StatelessWidget {
  final DashboardModel model;
  final Function(bool) onToggleComparison;
  
  const ComparisonToggle({
    Key? key,
    required this.model,
    required this.onToggleComparison,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Switch(
          value: model.showComparison,
          onChanged: onToggleComparison,
          activeColor: Colors.deepPurple,
        ),
        const SizedBox(width: 8),
        const Text(
          'So sánh với',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 16),
        if (model.showComparison)
          DropdownButton<String>(
            value: model.comparisonPeriod,
            onChanged: (String? newValue) {
              if (newValue != null) {
                // Since we can't directly set comparisonPeriod, we refresh data
                // using the current time filter
                model.setTimeFilter(model.selectedTimeFilter);
              }
            },
            items: model.comparisonOptions
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            underline: Container(
              height: 1,
              color: Colors.deepPurple,
            ),
          ),
      ],
    );
  }
}
