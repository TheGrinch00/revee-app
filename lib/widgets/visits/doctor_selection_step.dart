import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revee/models/doctor.dart';
import 'package:revee/providers/visit_create_edit_provider.dart';

class DoctorSelectionStep extends StatefulWidget {
  const DoctorSelectionStep({
    Key? key,
    this.onDoctorChosen,
    required this.doctors,
  }) : super(key: key);

  final List<Doctor> doctors;
  final void Function(int)? onDoctorChosen;

  @override
  _DoctorSelectionStepState createState() => _DoctorSelectionStepState();
}

class _DoctorSelectionStepState extends State<DoctorSelectionStep> {
  @override
  Widget build(BuildContext context) {
    final doctors = widget.doctors;
    final visitCreateProvider = Provider.of<VisitCreateProvider>(context);
    final currentDoctor = visitCreateProvider.doctor;

    return Autocomplete<int>(
      optionsBuilder: (input) {
        final userInput = input.text.toLowerCase();

        if (userInput.isEmpty) {
          return [];
        }

        return doctors.where((doc) {
          final inputIsInName = doc.name.toLowerCase().contains(userInput);
          final inputIsInSurname =
              doc.surname.toLowerCase().contains(userInput);

          final inputIsInFullName =
              "${doc.name} ${doc.surname}".toLowerCase().contains(userInput);

          return inputIsInName || inputIsInSurname || inputIsInFullName;
        }).map((doctor) => doctor.id);
      },
      initialValue: currentDoctor != null
          ? TextEditingValue(
              text: "${currentDoctor.name} ${currentDoctor.surname}",
            )
          : null,
      onSelected: (id) {
        final Doctor chosenDoctor =
            doctors.firstWhere((doctor) => doctor.id == id);
        visitCreateProvider.doctor = chosenDoctor;
        widget.onDoctorChosen?.call(id);
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Material(
          type: MaterialType.transparency,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.grey[100],
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    children: options.map((doctorId) {
                      final doctor =
                          doctors.firstWhere((doctor) => doctor.id == doctorId);

                      return Column(
                        key: ValueKey(doctor.id),
                        children: [
                          ListTile(
                            dense: true,
                            leading: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context).secondaryHeaderColor,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: doctor.photoURL != null &&
                                      doctor.photoURL != ''
                                  ? CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(doctor.photoURL!),
                                    )
                                  : const CircleAvatar(
                                      backgroundColor: Colors.white,
                                      backgroundImage: AssetImage(
                                        'assets/icons/doctor-icon.png',
                                      ),
                                    ),
                            ),
                            title: Text("${doctor.name} ${doctor.surname}"),
                            onTap: () => onSelected(doctor.id),
                          ),
                          if (doctorId != options.last)
                            Divider(
                              color: Theme.of(context).secondaryHeaderColor,
                            ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      displayStringForOption: (id) {
        final doctor = doctors.firstWhere((doctor) => doctor.id == id);
        return "${doctor.name} ${doctor.surname}";
      },
    );
  }
}
