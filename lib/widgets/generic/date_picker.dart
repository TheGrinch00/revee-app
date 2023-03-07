import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({
    Key? key,
    this.emptyText,
    this.fontSize = 16,
    this.firstDate,
    this.lastDate,
    this.onDateChanged,
    this.defaultValue,
    this.initialDate,
  }) : super(key: key);

  final String? emptyText;
  final double? fontSize;

  final DateTime? defaultValue;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTime? initialDate;

  final void Function(DateTime?)? onDateChanged;

  @override
  DatePickerState createState() => DatePickerState();
}

class DatePickerState extends State<DatePicker> {
  DateTime? selectedDate;

  String get dateString {
    if (selectedDate == null) {
      return widget.emptyText ?? "Seleziona giorno";
    }

    return DateFormat("dd MMMM yyyy").format(selectedDate!);
  }

  @override
  void initState() {
    super.initState();

    selectedDate = widget.defaultValue;
  }

  final now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final temp = await showDatePicker(
          context: context,
          firstDate: widget.firstDate ??
              DateTime.now().subtract(const Duration(days: 3)),
          initialDate: widget.initialDate ?? now,
          lastDate:
              widget.lastDate ?? DateTime(now.year + 1, now.month, now.day),
        );

        widget.onDateChanged?.call(temp);

        setState(() {
          selectedDate = temp;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey[600]!,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              dateString,
              style: Theme.of(context).textTheme.headline4!.copyWith(
                    color: selectedDate == null
                        ? Colors.grey[600]
                        : Theme.of(context).secondaryHeaderColor,
                    fontSize: widget.fontSize,
                  ),
            ),
            Icon(
              Icons.calendar_today,
              color: selectedDate == null
                  ? Colors.grey[600]
                  : Theme.of(context).secondaryHeaderColor,
            ),
          ],
        ),
      ),
    );
  }
}
