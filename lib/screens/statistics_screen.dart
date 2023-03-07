import 'package:flutter/material.dart';
import 'package:revee/screens/charts_page.dart';

import 'package:revee/widgets/appbar/revee_app_bar.dart';

class StatisticsScreen extends StatelessWidget {
  static const String routeName = "/stats";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ReveeAppBar(
        title: "Statistiche",
      ),
      body: ChartsPage(),
    );
  }
}
