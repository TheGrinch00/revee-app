import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revee/providers/visits_provider.dart';
import 'package:revee/utils/theme.dart';
import 'package:revee/widgets/generic/animated_slide_opacity.dart';
import 'package:revee/widgets/generic/no_results.dart';
import 'package:revee/widgets/visits/visit_tile.dart';

class VisitsScreenArgs {
  const VisitsScreenArgs({
    this.showFeedback,
    this.feedbackType,
    this.feedbackMessage,
  });

  final bool? showFeedback;
  final String? feedbackType;
  final String? feedbackMessage;
}

class VisitsList extends StatefulWidget {
  const VisitsList({Key? key}) : super(key: key);

  @override
  State<VisitsList> createState() => _VisitsListState();
}

class _VisitsListState extends State<VisitsList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VisitsProvider>(
      builder: (context, visitsProvider, child) {
        final visits = visitsProvider.visits;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: visits.isEmpty
              ? const NoResults(
                  displayText:
                      "Non sono state trovate visite con questi filtri",
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: List.generate(
                        visits.length,
                        (index) => AnimatedSlideOpacity(
                          millisDelay: 100 * index,
                          key: ValueKey(
                            visits[index].id,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              VisitTile(
                                visit: visits[index],
                              ),
                              if (index != visits.length - 1)
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
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}
