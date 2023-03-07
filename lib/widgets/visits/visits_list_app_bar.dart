import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revee/providers/visits_filters_provider.dart';
import 'package:revee/widgets/appbar/revee_app_bar.dart';

class VisitsListAppBar extends StatelessWidget implements PreferredSizeWidget {
  const VisitsListAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final visitsFilterType =
        Provider.of<VisitsFiltersProvider>(context).filterType;

    late final String appBarTitle;

    switch (visitsFilterType) {
      case FilterTypes.NONE:
        appBarTitle = "Tutte le visite";
        break;
      case FilterTypes.TODAY:
        appBarTitle = "Visite di oggi";
        break;
      case FilterTypes.THIS_WEEK:
        appBarTitle = "Visite della settimana";
        break;
      case FilterTypes.CUSTOM:
        appBarTitle = "Le tue visite";
        break;
    }

    return ReveeAppBar(title: appBarTitle);
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
