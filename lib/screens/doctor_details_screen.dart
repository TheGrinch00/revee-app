import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:revee/providers/doctor_provider.dart';

import 'package:revee/models/doctor.dart';

import 'package:revee/widgets/employee/detail_anagraphic_card.dart';
import 'package:revee/widgets/employee/positions_list.dart';
import 'package:revee/widgets/employee/doctor_visits_list.dart';
import 'package:revee/widgets/generic/revee_loader.dart';
import 'package:revee/widgets/visits/plan_visit_button.dart';
import 'package:revee/widgets/appbar/revee_app_bar.dart';

class DoctorDetailScreen extends StatelessWidget {
  final Doctor doctor;
  const DoctorDetailScreen({Key? key, required this.doctor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final employeeProvider =
        Provider.of<DoctorProvider>(context, listen: false);

    return Scaffold(
      appBar: ReveeAppBar(title: "Dr. ${doctor.surname} ${doctor.name}"),
      floatingActionButton: PlanVisitButton(
        initialTitle: "Visita al Dr. ${doctor.name} ${doctor.surname}",
      ),
      body: FutureBuilder<Doctor?>(
        future: employeeProvider.getDoctorById(doctor.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: ReveeBouncingLoader(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SizedBox(height: 16.0),
                  DetailAnagraphicCard(),
                  SizedBox(height: 30.0),
                  PositionsList(),
                  SizedBox(height: 30.0),
                  DoctorVisitsList(),
                  SizedBox(height: 16.0),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
