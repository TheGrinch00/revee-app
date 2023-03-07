import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revee/widgets/generic/animated_slide_opacity.dart';
import 'package:revee/widgets/generic/revee_loader.dart';

import 'package:revee/providers/doctor_provider.dart';

import 'package:revee/widgets/appbar/revee_app_bar.dart';
import 'package:revee/widgets/employee/doctor_card.dart';
import 'package:revee/widgets/generic/no_results.dart';
import 'package:revee/widgets/drawer/app_drawer.dart';

class ExpiringDoctorsScreen extends StatefulWidget {
  static const String routeName = "/expiring";

  @override
  _ExpiringDoctorsScreenState createState() => _ExpiringDoctorsScreenState();
}

class _ExpiringDoctorsScreenState extends State<ExpiringDoctorsScreen> {
  @override
  Widget build(BuildContext context) {
    final employeeProvider =
        Provider.of<DoctorProvider>(context, listen: false);

    return Scaffold(
      appBar: const ReveeAppBar(title: "Medici in scadenza"),
      drawer: AppDrawer(
        currentRoute: ExpiringDoctorsScreen.routeName,
      ),
      body: FutureBuilder(
        future: employeeProvider.fetchExpiringEmployees(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: ReveeBouncingLoader(),
            );
          }

          return Consumer<DoctorProvider>(
            builder: (ctx, provider, child) => Container(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.width * 0.015),
              child: provider.expiringDoctors.isEmpty
                  ? const NoResults(
                      displayText: "Non sono stati trovati medici",
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: List.generate(
                          provider.expiringDoctors.length,
                          (index) => AnimatedSlideOpacity(
                            millisDelay: index * 100,
                            key: ValueKey(provider.expiringDoctors[index].id),
                            child: DoctorCard(
                              doctor: provider.expiringDoctors[index],
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
