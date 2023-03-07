import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revee/mixins/screen_load_feedback.dart';
import 'package:revee/screens/visit_create_screen.dart';
import 'package:revee/widgets/generic/revee_loader.dart';
import 'package:revee/widgets/visits/visits_filters.dart';
import 'package:revee/widgets/visits/visits_list.dart';
import 'package:revee/widgets/visits/visits_list_app_bar.dart';

import 'package:revee/providers/visits_provider.dart';
import 'package:revee/widgets/drawer/app_drawer.dart';

class VisitsScreen extends StatefulWidget {
  static const String routeName = "/visits";

  @override
  _VisitsScreenState createState() => _VisitsScreenState();
}

class _VisitsScreenState extends State<VisitsScreen> with ScreenLoadFeedback {
  @override
  void initState() {
    super.initState();
    checkAndShowFeedback(context);
  }

  @override
  Widget build(BuildContext context) {
    final visitsProvider = Provider.of<VisitsProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: const VisitsListAppBar(),
      drawer: AppDrawer(
        currentRoute: VisitsScreen.routeName,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(VisitCreateScreen.routeName);
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const VisitsFilters(),
            FutureBuilder(
              future: visitsProvider.fetchVisits(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Expanded(
                    child: Center(
                      child: ReveeBouncingLoader(),
                    ),
                  );
                }

                return const Expanded(
                  child: VisitsList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
