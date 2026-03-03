import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SelectedDayHeader extends StatelessWidget {
  final DateTime? selectedDay;

  const SelectedDayHeader({required this.selectedDay, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Colors.transparent,
      child: Row(
        children: [
          Expanded(
            child: Text(
              selectedDay == null ? 'Select a date' : DateFormat('EEEE, MMMM dd, yyyy').format(selectedDay!),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }
}
