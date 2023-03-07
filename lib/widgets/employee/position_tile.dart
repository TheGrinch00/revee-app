import 'package:flutter/material.dart';
import 'package:revee/models/position.dart';
import 'package:revee/utils/theme.dart';

class PositionTile extends StatelessWidget {
  const PositionTile({Key? key, required this.position}) : super(key: key);

  final Position position;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          position.facility?.name ?? "Ospedale non disponibile",
          style: Theme.of(context).textTheme.headline5!.copyWith(
                color: CustomColors.violaScuro,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          position.facility?.address ?? "Indirizzo non disponibile",
          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                color: CustomColors.violaScuro.withOpacity(0.6),
                fontStyle: FontStyle.italic,
                fontSize: 12,
              ),
        ),
        Text(
          position.meetingDetails,
          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                color: CustomColors.violaScuro.withOpacity(0.6),
                fontStyle: FontStyle.italic,
                fontSize: 12,
              ),
        ),
      ],
    );
  }
}
