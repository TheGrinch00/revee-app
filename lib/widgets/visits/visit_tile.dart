import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:revee/models/visit.dart';
import 'package:revee/screens/visit_details.dart';
import 'package:revee/widgets/generic/hero_dialog_route.dart';
import 'package:revee/utils/theme.dart';

class VisitTile extends StatefulWidget {
  final Visit visit;

  const VisitTile({
    required this.visit,
  });

  @override
  _VisitTileState createState() => _VisitTileState();
}

class _VisitTileState extends State<VisitTile> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(
        widget.visit.title ?? "Visita: ${widget.visit.id}",
        style: textTheme.headline4!.copyWith(
          fontWeight: FontWeight.w600,
          color: CustomColors.violaScuro,
        ),
      ),
      subtitle: Text(
        "${widget.visit.doctor!.nameAndSurname} ${DateFormat("d MMM yyyy, HH:mm").format(widget.visit.realDate)}",
        style: textTheme.bodyText2!.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 12,
          color: const Color(0xFF727272),
        ),
      ),
      trailing: const Icon(
        Icons.aspect_ratio_rounded,
        color: CustomColors.violaScuro,
      ),
      onTap: () {
        Navigator.of(context).push(
          HeroDialogRoute(
            isDismissable: true,
            builder: (context) => VisitDetails(visit: widget.visit),
          ),
        );
      },
    );
  }
}
