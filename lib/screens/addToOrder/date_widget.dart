import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerWidget extends StatefulWidget {
  Function(String) onDateSelected;

  DatePickerWidget({super.key, required this.onDateSelected});

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
  
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now, // Dates before today are not selectable
      lastDate: DateTime(2030), // Set a reasonable upper limit
    );

    if (picked != null && picked != _selectedDate) {
      widget.onDateSelected(DateFormat('yyyy-MM-dd').format(picked));
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Text(
            _selectedDate != null
                ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                : 'When do you want to travel?',
            style: Theme.of(context).textTheme.titleMedium
          ),
        ),
        IconButton(
          onPressed: () => _selectDate(context),
          icon: const Icon(Icons.calendar_month_outlined),
        ),
      ],
    );
  }
}