import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revee/widgets/generic/animated_slide_opacity.dart';
import 'package:revee/widgets/generic/revee_loader.dart';

import 'package:revee/providers/doctor_provider.dart';

import 'package:revee/screens/doctor_create_screen.dart';

import 'package:revee/widgets/appbar/revee_app_bar.dart';
import 'package:revee/widgets/drawer/app_drawer.dart';
import 'package:revee/widgets/employee/doctor_card.dart';
import 'package:revee/widgets/generic/no_results.dart';

class DoctorsScreen extends StatefulWidget {
  static const String routeName = "/doctors";

  @override
  _DoctorsScreenState createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  final myController = TextEditingController();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final employeeProvider =
        Provider.of<DoctorProvider>(context, listen: false);
    return Scaffold(
      appBar: const ReveeAppBar(title: "Tutti i medici"),
      drawer: AppDrawer(
        currentRoute: DoctorsScreen.routeName,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateNewDoctorScreen(),
            ),
          );
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: employeeProvider.fetchDoctors(),
        builder: (context, snapshot) {
          return (snapshot.connectionState == ConnectionState.waiting)
              ? Center(
                  child: ReveeBouncingLoader(),
                )
              : Consumer<DoctorProvider>(
                  builder: (context, employeeProvider, child) {
                    return Container(
                      padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.015,
                      ),
                      child: employeeProvider.doctors.isEmpty
                          ? const NoResults(
                              displayText: "Non sono stati trovati medici",
                            )
                          : SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.015,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0,
                                    ),
                                    child: TextField(
                                      onChanged: (text) {
                                        employeeProvider.searchDoctorsByString(
                                          myController.text,
                                        );
                                      },
                                      controller: myController,
                                      decoration: const InputDecoration(
                                        labelText: 'Cerca un medico',
                                        suffixIcon: Icon(Icons.search),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.015,
                                  ),
                                  Column(
                                    children: List.generate(
                                      employeeProvider.searchDoctors.length,
                                      (index) => AnimatedSlideOpacity(
                                        millisDelay: index * 100,
                                        key: ValueKey(
                                          employeeProvider
                                              .searchDoctors[index].id,
                                        ),
                                        child: DoctorCard(
                                          doctor: employeeProvider
                                              .searchDoctors[index],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    );
                  },
                );
        },
      ),
    );
  }
}
