// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revee/models/position.dart';
import 'package:revee/providers/doctor_provider.dart';
import 'package:revee/providers/feedback_provider.dart';
import 'package:revee/utils/theme.dart';
import 'package:revee/widgets/employee/create_position_form.dart';
import 'package:revee/widgets/employee/position_tile.dart';
import 'package:revee/widgets/generic/hero_dialog_route.dart';
import 'package:revee/widgets/generic/light_box_shadow.dart';

class PositionsList extends StatelessWidget {
  const PositionsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DoctorProvider>(
      builder: (context, provider, child) {
        if (provider.detailDoctor == null) {
          Navigator.of(context).pop();
        }

        final doctor = provider.detailDoctor!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "posizioni lavorative",
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...doctor.positions
                          .map(
                            (position) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                PositionTile(position: position),
                                Divider(
                                  color:
                                      CustomColors.violaScuro.withOpacity(0.5),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            final newPosition =
                                await Navigator.of(context).push<Position?>(
                              HeroDialogRoute(
                                isDismissable: true,
                                builder: (context) =>
                                    CreatePositionForm(doctorId: doctor.id),
                              ),
                            );

                            if (newPosition != null) {
                              Provider.of<DoctorProvider>(
                                context,
                                listen: false,
                              ).addPositionToDetailEmployee(newPosition);
                              Provider.of<FeedbackProvider>(
                                context,
                                listen: false,
                              ).showSuccessFeedback(
                                context,
                                "Posizione lavorativa aggiunta correttamente",
                              );
                            }
                          },
                          child: Text(
                            "AGGIUNGI",
                            style:
                                Theme.of(context).textTheme.headline6!.copyWith(
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
