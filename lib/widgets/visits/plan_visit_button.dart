import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revee/providers/feedback_provider.dart';
import 'package:revee/widgets/generic/hero_dialog_route.dart';

import 'package:revee/widgets/visits/visit_planning_dialog.dart';

class PlanVisitButton extends StatefulWidget {
  const PlanVisitButton({
    Key? key,
    this.initialTitle,
    this.initialDescription,
    this.initialLocation,
  }) : super(key: key);

  final String? initialTitle;
  final String? initialDescription;
  final String? initialLocation;

  @override
  State<PlanVisitButton> createState() => _PlanVisitButtonState();
}

class _PlanVisitButtonState extends State<PlanVisitButton> {
  @override
  Widget build(BuildContext context) {
    final feedbackProvider =
        Provider.of<FeedbackProvider>(context, listen: false);

    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).secondaryHeaderColor.withOpacity(0.5),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              "Pianifica",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 10),
            Icon(Icons.calendar_today_outlined, color: Colors.white),
          ],
        ),
      ),
      onTap: () async {
        final bool? outcome = await Navigator.of(context).push<bool?>(
          HeroDialogRoute(
            isDismissable: true,
            builder: (context) => Material(
              type: MaterialType.transparency,
              child: VisitPlanningDialog(
                initialTitle: widget.initialTitle,
                initialLocation: widget.initialLocation,
                initialDescription: widget.initialDescription,
              ),
            ),
          ),
        );

        // Closed by user
        if (outcome == null) return;

        if (!mounted) return;
        if (outcome) {
          feedbackProvider.showSuccessFeedback(
            context,
            "Evento creato con successo",
          );
        } else {
          feedbackProvider.showFailFeedback(
            context,
            "Errore durante la creazione dell'evento",
          );
        }
      },
    );
  }
}
