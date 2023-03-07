import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revee/providers/auth_provider.dart';
import 'package:revee/providers/feedback_provider.dart';
import 'package:revee/utils/extensions/time_of_day_extension.dart';
import 'package:revee/widgets/generic/date_picker.dart';
import 'package:revee/widgets/generic/time_picker.dart';

class VisitPlanningDialog extends StatefulWidget {
  const VisitPlanningDialog({
    Key? key,
    this.initialTitle,
    this.initialLocation,
    this.initialDescription,
  }) : super(key: key);

  final String? initialTitle;
  final String? initialLocation;
  final String? initialDescription;

  @override
  _VisitPlanningDialogState createState() => _VisitPlanningDialogState();
}

class _VisitPlanningDialogState extends State<VisitPlanningDialog> {
  final _formKey = GlobalKey<FormState>();

  final _visitDateKey = GlobalKey<DatePickerState>();
  final _visitStartTimeKey = GlobalKey<TimePickerState>();
  final _visitEndTimeKey = GlobalKey<TimePickerState>();

  String? title;
  String? description;
  String? location;
  DateTime? day;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  bool isLoading = false;

  Future<void> _submitForm() async {
    final feedbackProvider =
        Provider.of<FeedbackProvider>(context, listen: false);
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();

    startTime = _visitStartTimeKey.currentState!.selectedTime;
    endTime = _visitEndTimeKey.currentState!.selectedTime;
    day = _visitDateKey.currentState!.selectedDate;

    if (startTime == null || startTime == null || day == null) {
      feedbackProvider.showFailFeedback(
        context,
        "Il giorno, l'inizio e la fine dell'evento sono obbligatori",
      );

      return;
    }

    if (startTime! > endTime!) {
      feedbackProvider.showFailFeedback(
        context,
        "La fine non può precedere l'inizio dell'evento",
      );

      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final DateTime startDate = DateTime(
      day!.year,
      day!.month,
      day!.day,
      startTime!.hour,
      startTime!.minute,
    );

    final DateTime endDate = DateTime(
      day!.year,
      day!.month,
      day!.day,
      endTime!.hour,
      endTime!.minute,
    );

    final success = await authProvider.createCalendarEvent(
      startDate: startDate,
      endDate: endDate,
      title: title,
      description: description,
      location: location,
    );
    if (!mounted) return;
    Navigator.of(context).pop(success);
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: SizedBox(
            width: double.infinity,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        "Pianifica su Google Calendar",
                        style: Theme.of(context).textTheme.headline5!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).secondaryHeaderColor,
                            ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Titolo evento (opzionale)',
                        ),
                        onSaved: (value) => title = value,
                        initialValue: widget.initialTitle,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Descrizione (opzionale)',
                        ),
                        onSaved: (value) => description = value,
                        minLines: 3,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Luogo (opzionale)',
                        ),
                        onSaved: (value) => location = value,
                        initialValue: widget.initialLocation,
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: DatePicker(
                          key: _visitDateKey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TimePicker(
                              key: _visitStartTimeKey,
                              emptyText: "Inizio",
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TimePicker(
                              key: _visitEndTimeKey,
                              emptyText: "Fine",
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Annulla"),
                          ),
                          ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () async {
                                    setState(() {
                                      isLoading = true;
                                    });

                                    await _submitForm();

                                    setState(() {
                                      isLoading = false;
                                    });
                                  },
                            child: isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text("Crea"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
