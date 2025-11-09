import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ModernDatePicker extends StatefulWidget {
  final ValueChanged<DateTime> onDateSelected; // callback на выбор даты

  const ModernDatePicker({super.key, required this.onDateSelected});

  @override
  State<ModernDatePicker> createState() => _ModernDatePickerState();
}

class _ModernDatePickerState extends State<ModernDatePicker> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SfDateRangePicker(
          selectionMode: DateRangePickerSelectionMode.single,
          showNavigationArrow: true,
          backgroundColor: Colors.white,
          selectionColor: const Color(0xff363062),
          todayHighlightColor: const Color(0xff363062),
          selectionShape: DateRangePickerSelectionShape.circle,
          monthViewSettings: const DateRangePickerMonthViewSettings(
            firstDayOfWeek: 1,
            showTrailingAndLeadingDates: true,
            dayFormat: 'EEE',
          ),
          onSelectionChanged: (args) {
            setState(() {
              _selectedDate = args.value;
            });
            if (_selectedDate != null) {
              widget.onDateSelected(_selectedDate!); // передаем наружу
            }
          },
        ),
      ),
    );
  }
}
