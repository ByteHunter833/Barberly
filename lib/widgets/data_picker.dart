import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ModernDatePicker extends StatefulWidget {
  const ModernDatePicker({super.key});

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

          headerHeight: 50,
          headerStyle: const DateRangePickerHeaderStyle(
            backgroundColor: Color(0xffF0F2FF),
            textAlign: TextAlign.center,
            textStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xff363062),
            ),
          ),

          // Цвет выделения и сегодняшнего дня
          selectionColor: const Color(0xff363062),
          todayHighlightColor: const Color(0xff363062),

          selectionShape: DateRangePickerSelectionShape.circle,

          monthViewSettings: const DateRangePickerMonthViewSettings(
            firstDayOfWeek: 1,
            showTrailingAndLeadingDates: true,
            dayFormat: 'EEE',
          ),

          // Стили ячеек
          monthCellStyle: DateRangePickerMonthCellStyle(
            textStyle: const TextStyle(
              color: Colors.black87,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            todayTextStyle: const TextStyle(
              color: Color(0xff363062),
              fontWeight: FontWeight.w700,
            ),
            disabledDatesTextStyle: TextStyle(color: Colors.grey.shade400),

            // Выходные ярче
            weekendTextStyle: const TextStyle(
              color: Color(0xff9C27B0),
              fontWeight: FontWeight.w600,
            ),
          ),

          showTodayButton: false,

          onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
            setState(() {
              _selectedDate = args.value;
            });

            debugPrint('Выбранная дата: $_selectedDate');
          },
        ),
      ),
    );
  }
}
