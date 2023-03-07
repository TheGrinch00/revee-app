// ignore_for_file: use_build_context_synchronously
import 'package:revee/models/employment.dart';
import 'package:revee/models/ward.dart';
import 'package:revee/providers/doctor_provider.dart';

import 'package:revee/utils/extensions/time_of_day_extension.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revee/models/facility.dart';
import 'package:revee/models/position.dart';
import 'package:revee/providers/employment_provider.dart';
import 'package:revee/providers/facility_provider.dart';
import 'package:revee/providers/feedback_provider.dart';
import 'package:revee/providers/ward_provider.dart';
import 'package:revee/widgets/facility/facility_dropdown_select.dart';
import 'package:revee/widgets/generic/dropdown_string_select.dart';
import 'package:revee/widgets/generic/revee_loader.dart';
import 'package:revee/widgets/generic/time_picker.dart';

const days = [
  "Lunedì",
  "Martedì",
  "Mercoledì",
  "Giovedì",
  "Venerdì",
  "Sabato",
  "Domenica",
];

class CreatePositionForm extends StatefulWidget {
  const CreatePositionForm({Key? key, required this.doctorId})
      : super(key: key);

  final int doctorId;

  @override
  _CreatePositionFormState createState() => _CreatePositionFormState();
}

class _CreatePositionFormState extends State<CreatePositionForm> {
  final _facilitySelectKey = GlobalKey<FacilitiesDropdownSelectState>();
  final _employmentsSelectKey = GlobalKey<DropdownEmploymentsSelectState>();
  final _wardsSelectKey = GlobalKey<DropdownWardsSelectState>();
  final _meetingDaySelectKey = GlobalKey<DropdownStringSelectState>();
  final _startTimeKey = GlobalKey<TimePickerState>();
  final _endTimeKey = GlobalKey<TimePickerState>();

  Future<Position?> onSubmit() async {
    final feedbackProvider =
        Provider.of<FeedbackProvider>(context, listen: false);

    final facility = _facilitySelectKey.currentState?.chosenFacility;
    final employment = _employmentsSelectKey.currentState?.chosenValue;
    final ward = _wardsSelectKey.currentState?.chosenValue;
    final meetingDay = _meetingDaySelectKey.currentState?.chosenValue;
    final startTime = _startTimeKey.currentState?.selectedTime;
    final endTime = _endTimeKey.currentState?.selectedTime;
    int? meetingDayNumber;

    if (facility == null) {
      feedbackProvider.showFailFeedback(
        context,
        "Devi selezionare un ospedale",
      );
      return null;
    }

    if (employment == null) {
      feedbackProvider.showFailFeedback(
        context,
        "Devi selezionare un impiego",
      );
      return null;
    }

    if (ward == null) {
      feedbackProvider.showFailFeedback(
        context,
        "Devi selezionare un reparto",
      );
      return null;
    }

    if (meetingDay != null) {
      meetingDayNumber = days.indexOf(meetingDay);
    }

    if ((startTime == null && endTime != null) ||
        (endTime == null && startTime != null)) {
      feedbackProvider.showFailFeedback(
        context,
        "Una volta selezionato uno dei due orari, devi selezionare anche l'altro",
      );
      return null;
    }

    if (startTime != null && endTime != null) {
      if (startTime > endTime) {
        feedbackProvider.showFailFeedback(
          context,
          "L'orario di fine non può precedere l'orario d'inizio",
        );
        return null;
      }
    }

    final createdPosition =
        await Provider.of<DoctorProvider>(context, listen: false)
            .createEmployeePosition(
      context,
      doctorId: widget.doctorId,
      wardId: ward.id,
      employmentId: employment.id,
      facilityId: facility.id,
      visitStart: startTime,
      visitEnd: endTime,
      weekday: meetingDayNumber,
    );

    return createdPosition;
  }

  @override
  Widget build(BuildContext context) {
    final facilityProvider =
        Provider.of<FacilityProvider>(context, listen: false);
    final employmentProvider =
        Provider.of<EmploymentProvider>(context, listen: false);
    final wardsProvider = Provider.of<WardProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Material(
          type: MaterialType.transparency,
          child: SizedBox(
            width: double.infinity,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Nuovo impiego",
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    const SizedBox(height: 20),
                    Flexible(
                      child: FutureBuilder<List<Facility>>(
                        builder: (ctx, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: ReveeBouncingLoader(),
                            );
                          }

                          if (snapshot.hasData) {
                            final facilities = snapshot.data!;
                            return FacilitiesDropdownSelect(
                              key: _facilitySelectKey,
                              options: facilities,
                            );
                          }
                          return const Center(
                            child: Text("Si è verificato un errore"),
                          );
                        },
                        future: facilityProvider.fetchFacilities(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    FutureBuilder<List<Employment>>(
                      future: employmentProvider.fetchEmployments(context),
                      builder: (ctx, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: ReveeBouncingLoader(),
                          );
                        }

                        if (snapshot.hasData) {
                          final employments = snapshot.data!;

                          return DropdownEmploymentsSelect(
                            key: _employmentsSelectKey,
                            hint: "Seleziona un impiego (Obbligatorio)",
                            options: employments,
                          );
                        }

                        return const Center(
                          child: Text("Si è verificato un errore"),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    FutureBuilder<List<Ward>>(
                      future: wardsProvider.fetchWards(),
                      builder: (ctx, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: ReveeBouncingLoader(),
                          );
                        }

                        if (snapshot.hasData) {
                          final wards = snapshot.data!;

                          return DropdownWardsSelect(
                            key: _wardsSelectKey,
                            hint: "Seleziona un reparto (Obbligatorio)",
                            options: wards,
                          );
                        }

                        return const Center(
                          child: Text("Si è verificato un errore"),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    DropdownStringSelect(
                      key: _meetingDaySelectKey,
                      hint: "Giorno di visita",
                      options: days,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TimePicker(
                            key: _startTimeKey,
                            emptyText: "Orario inizio",
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TimePicker(
                            key: _endTimeKey,
                            emptyText: "Orario fine",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    CreatePositionActions(onSubmit: onSubmit),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CreatePositionActions extends StatefulWidget {
  const CreatePositionActions({Key? key, required this.onSubmit})
      : super(key: key);

  final Future<Position?> Function() onSubmit;

  @override
  _CreatePositionActionsState createState() => _CreatePositionActionsState();
}

class _CreatePositionActionsState extends State<CreatePositionActions> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(null);
          },
          child: const Text("Annulla"),
        ),
        ElevatedButton(
          onPressed: () async {
            setState(() {
              _isLoading = true;
            });

            final result = await widget.onSubmit();

            setState(() {
              _isLoading = false;
            });

            Navigator.of(context).pop(result);
          },
          child: _isLoading
              ? SizedBox(
                  height: Theme.of(context).buttonTheme.height * 0.5,
                  width: Theme.of(context).buttonTheme.height * 0.5,
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : const Text("Crea"),
        )
      ],
    );
  }
}
