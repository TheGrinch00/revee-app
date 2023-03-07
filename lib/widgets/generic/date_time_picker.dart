import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:revee/utils/theme.dart';

class DateTimePicker extends StatefulWidget {
  const DateTimePicker({
    Key? key,
    this.emptyText,
    this.firstDate,
    this.lastDate,
    this.onDatePicked,
    this.initialDate,
  }) : super(key: key);

  final String? emptyText;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;

  final void Function(DateTime?)? onDatePicked;

  @override
  DateTimePickerState createState() => DateTimePickerState();
}

class DateTimePickerState extends State<DateTimePicker> {
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
  }

  String get timeString {
    if (selectedDate == null) {
      return widget.emptyText ?? "Seleziona una data";
    }

    return DateFormat("dd MMM yyyy, HH:mm").format(selectedDate!);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        late final DateTime? chosenDate;
        late final TimeOfDay? chosenTime;

        chosenDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: widget.firstDate ?? DateTime.now(),
          lastDate: widget.lastDate ?? DateTime(2022),
        );

        if (chosenDate != null) {
          chosenTime = await showTimePicker(
            context: context,
            initialTime: const TimeOfDay(hour: 0, minute: 0),
          );
        }

        if (chosenDate != null && chosenTime != null) {
          final temp = DateTime(
            chosenDate.year,
            chosenDate.month,
            chosenDate.day,
            chosenTime.hour,
            chosenTime.minute,
          );
          setState(() {
            selectedDate = temp;
            widget.onDatePicked?.call(temp);
          });
        } else {
          setState(() {
            selectedDate = null;
            widget.onDatePicked?.call(null);
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey[600]!,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          timeString,
          style: Theme.of(context).textTheme.headline4!.copyWith(
                color: CustomColors.violaScuro,
                fontSize: 12,
              ),
        ),
      ),
    );
  }
}
