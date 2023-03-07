import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revee/widgets/generic/animated_slide_opacity.dart';
import 'package:revee/widgets/generic/revee_loader.dart';

import 'package:revee/widgets/appbar/revee_app_bar.dart';
import 'package:revee/widgets/drawer/app_drawer.dart';
import 'package:revee/providers/facility_provider.dart';
import 'package:revee/widgets/generic/no_results.dart';
import 'package:revee/widgets/facility/facility_card.dart';
import 'package:revee/screens/hospital_create_screen.dart';

class HospitalsScreen extends StatefulWidget {
  static const String routeName = "/hospitals";

  @override
  _HospitalsScreenState createState() => _HospitalsScreenState();
}

class _HospitalsScreenState extends State<HospitalsScreen> {
  final myController = TextEditingController();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final facilityProvider =
        Provider.of<FacilityProvider>(context, listen: false);

    return Scaffold(
      appBar: const ReveeAppBar(title: "Strutture"),
      drawer: AppDrawer(
        currentRoute: HospitalsScreen.routeName,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(CreateNewFacilityScreen.routeName);
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: facilityProvider.fetchFacilities(),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? Center(
                  child: ReveeBouncingLoader(),
                )
              : Consumer<FacilityProvider>(
                  builder: (context, facilityProvider, child) {
                    return Container(
                      padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.020,
                      ),
                      child: facilityProvider.facilities.isEmpty
                          ? const NoResults(
                              displayText: "Non sono stati trovati ospedali",
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
                                        facilityProvider
                                            .searchFacilitiesByString(
                                          myController.text,
                                        );
                                      },
                                      controller: myController,
                                      decoration: const InputDecoration(
                                        labelText: 'Cerca una struttura',
                                        suffixIcon: Icon(Icons.search),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.015,
                                  ),
                                  FutureBuilder(
                                    future: facilityProvider
                                        .searchFacilitiesByString(
                                      myController.text,
                                    ),
                                    builder: (context, snapshot) {
                                      if (facilityProvider
                                          .searchFacilities.isEmpty) {
                                        return const NoResults(
                                          displayText:
                                              "Non sono stati trovati ospedali",
                                        );
                                      }
                                      return Column(
                                        children: List.generate(
                                          facilityProvider
                                              .searchFacilities.length,
                                          (index) {
                                            return AnimatedSlideOpacity(
                                              key: ValueKey(
                                                facilityProvider
                                                    .searchFacilities[index].id,
                                              ),
                                              millisDelay: index * 100,
                                              child: FacilityCard(
                                                facility: facilityProvider
                                                    .searchFacilities[index],
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
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
