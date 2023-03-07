import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimePicker extends StatefulWidget {
  const TimePicker({Key? key, this.emptyText}) : super(key: key);

  final String? emptyText;

  @override
  TimePickerState createState() => TimePickerState();
}

class TimePickerState extends State<TimePicker> {
  TimeOfDay? selectedTime;

  String get timeString {
    if (selectedTime == null) {
      return widget.emptyText ?? "Seleziona orario";
    }

    final tempDate =
        DateTime(0, 0, 0, selectedTime!.hour, selectedTime!.minute);

    return DateFormat("HH:mm").format(tempDate);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final temp = await showTimePicker(
          context: context,
          initialTime: const TimeOfDay(hour: 0, minute: 0),
        );

        setState(() {
          selectedTime = temp;
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
              timeString,
              style: Theme.of(context).textTheme.headline4!.copyWith(
                    color: selectedTime == null
                        ? Colors.grey[600]
                        : Theme.of(context).secondaryHeaderColor,
                    fontSize: 16,
                  ),
            ),
            Icon(
              Icons.access_time_outlined,
              color: selectedTime == null
                  ? Colors.grey[600]
                  : Theme.of(context).secondaryHeaderColor,
            ),
          ],
        ),
      ),
    );
  }
}
