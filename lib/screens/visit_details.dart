import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revee/models/visit.dart';
import 'package:revee/providers/visits_provider.dart';
import 'package:revee/widgets/generic/revee_loader.dart';
import 'package:revee/widgets/visits/visits_card.dart';

class VisitDetails extends StatelessWidget {
  const VisitDetails({Key? key, required this.visit}) : super(key: key);

  final Visit visit;

  @override
  Widget build(BuildContext context) {
    final visitsProvider = Provider.of<VisitsProvider>(context, listen: false);

    Widget _buildLoadingWidget() => Center(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            child: Card(
              child: SizedBox(
                height: 100,
                child: Center(
                  child: ReveeBouncingLoader(),
                ),
              ),
            ),
          ),
        );

    return Material(
      type: MaterialType.transparency,
      child: FutureBuilder(
        future: visitsProvider.getVisitById(visit.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingWidget();
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(12),
            child: Center(
              child: Consumer<VisitsProvider>(
                builder: (context, visitsProvider, _) =>
                    visitsProvider.visitDetails == null
                        ? const Center(
                            child: Text("Si è verificato un errore"),
                          )
                        : VisitCard(
                            visit: visitsProvider.visitDetails!,
                          ),
              ),
            ),
          );
        },
      ),
    );
  }
}
