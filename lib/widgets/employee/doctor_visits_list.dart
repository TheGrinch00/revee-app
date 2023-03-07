import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revee/models/position.dart';
import 'package:revee/models/visit.dart';
import 'package:revee/providers/doctor_provider.dart';
import 'package:revee/screens/visit_create_screen.dart';
import 'package:revee/utils/theme.dart';
import 'package:revee/widgets/employee/position_selection_dialog.dart';
import 'package:revee/widgets/generic/hero_dialog_route.dart';
import 'package:revee/widgets/generic/light_box_shadow.dart';
import 'package:revee/widgets/visits/visit_tile.dart';

class DoctorVisitsList extends StatefulWidget {
  const DoctorVisitsList({Key? key}) : super(key: key);

  @override
  State<DoctorVisitsList> createState() => _DoctorVisitsListState();
}

class _DoctorVisitsListState extends State<DoctorVisitsList> {
  @override
  Widget build(BuildContext context) {
    final doctorProvider = Provider.of<DoctorProvider>(context);
    final doctor = doctorProvider.detailDoctor;
    final List<Visit> doctorVisits = doctor?.visits ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "visite",
          style: Theme.of(context).textTheme.headline4!.copyWith(
            fontSize: 20.0,
            color: CustomColors.violaScuro,
            fontFeatures: const [
              FontFeature.enable('smcp'),
            ],
          ),
        ),
        const SizedBox(height: 10.0),
        LightBoxShadow(
          child: Card(
            margin: EdgeInsets.zero,
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: doctorVisits.isEmpty
                        ? null
                        : min(175, doctorVisits.length * 67),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ...List.generate(
                            doctorVisits.length,
                            (index) => Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                VisitTile(
                                  visit: doctorVisits[index],
                                ),
                                const Divider(
                                  color: CustomColors.violaScuro,
                                  height: 0,
                                  thickness: 0,
                                  indent: 0,
                                  endIndent: 0,
                                ),
                              ],
                            ),
                          ),
                          if (doctorVisits.isNotEmpty)
                            const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final chosenPosition =
                            await Navigator.of(context).push<Position?>(
                          HeroDialogRoute(
                            isDismissable: true,
                            builder: (context) => PositionSelectionDialog(
                              options: doctor?.positions ?? [],
                            ),
                          ),
                        );

                        if (chosenPosition == null) return;
                        if (!mounted) return;
                        await Navigator.of(context).pushNamed(
                          VisitCreateScreen.routeName,
                          arguments: VisitCreateArguments(
                            doctor: doctor,
                            position: chosenPosition,
                          ),
                        );
                      },
                      child: Text(
                        "AGGIUNGI",
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
