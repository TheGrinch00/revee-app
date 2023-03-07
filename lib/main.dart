import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:revee/firebase_options.dart';
import 'package:revee/providers/backend_connector.dart';
import 'package:revee/providers/employment_provider.dart';
import 'package:revee/providers/feedback_provider.dart';
import 'package:revee/providers/samples_provider.dart';
import 'package:revee/providers/statistics_provider.dart';
import 'package:revee/providers/position_provider.dart';
import 'package:revee/providers/visits_filters_provider.dart';
import 'package:revee/providers/ward_provider.dart';
import 'package:revee/providers/auth_provider.dart';
import 'package:revee/providers/products_provider.dart';
import 'package:revee/providers/doctor_provider.dart';
import 'package:revee/providers/visit_create_edit_provider.dart';
import 'package:revee/providers/visits_provider.dart';
import 'package:revee/providers/facility_provider.dart';

import 'package:revee/widgets/generic/revee_loader.dart';

import 'package:revee/utils/routes.dart';
import 'package:revee/utils/theme.dart' show reveeTheme;

void main() {
  Intl.defaultLocale = 'it_IT';
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Revee());
}

class Revee extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    final Future<FirebaseApp> fbApp = Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    return FutureBuilder(
      future: fbApp,
      builder: (context, snapshot) => snapshot.hasError
          ? Material(
              child: Center(
                child: ReveeBouncingLoader(),
              ),
            )
          : snapshot.hasData
              ? MultiProvider(
                  providers: [
                    ChangeNotifierProvider(create: (ctx) => FeedbackProvider()),
                    ChangeNotifierProvider(
                      create: (ctx) => VisitsFiltersProvider(),
                    ),
                    ChangeNotifierProxyProvider<FeedbackProvider, AuthProvider>(
                      create: (ctx) => AuthProvider(),
                      update: (ctx, feedback, auth) => auth!..update(feedback),
                    ),
                    ChangeNotifierProvider(
                      create: (_) => VisitCreateDoctorProvider(),
                    ),
                    ChangeNotifierProxyProvider<VisitCreateDoctorProvider,
                        VisitCreateProvider>(
                      create: (_) => VisitCreateProvider(),
                      update: (ctx, doctorProvider, visitCreateProv) =>
                          visitCreateProv!..update(doctorProvider),
                    ),
                    ChangeNotifierProxyProvider2<AuthProvider, FeedbackProvider,
                        BackendConnector>(
                      create: (ctx) => BackendConnector(),
                      update: (ctx, auth, feedback, backend) =>
                          backend!..update(auth, feedback),
                    ),
                    ChangeNotifierProxyProvider2<BackendConnector,
                        FeedbackProvider, ProductsProvider>(
                      create: (ctx) => ProductsProvider(),
                      update: (ctx, backend, feedback, products) =>
                          products!..update(backend, feedback),
                    ),
                    ChangeNotifierProxyProvider2<BackendConnector,
                        FeedbackProvider, SamplesProvider>(
                      create: (ctx) => SamplesProvider(),
                      update: (ctx, backend, feedback, samples) =>
                          samples!..update(backend, feedback),
                    ),
                    ChangeNotifierProxyProvider2<BackendConnector,
                        FeedbackProvider, EmploymentProvider>(
                      create: (ctx) => EmploymentProvider(),
                      update: (ctx, backend, feedback, employments) =>
                          employments!..update(backend, feedback),
                    ),
                    ChangeNotifierProxyProvider2<BackendConnector,
                        FeedbackProvider, WardProvider>(
                      create: (ctx) => WardProvider(),
                      update: (ctx, backend, feedback, wards) =>
                          wards!..update(backend, feedback, ctx),
                    ),
                    ChangeNotifierProxyProvider2<BackendConnector,
                        FeedbackProvider, DoctorProvider>(
                      create: (ctx) => DoctorProvider(),
                      update: (ctx, backend, feedback, employees) =>
                          employees!..update(backend, feedback),
                    ),
                    ChangeNotifierProxyProvider4<
                        BackendConnector,
                        FeedbackProvider,
                        VisitsFiltersProvider,
                        DoctorProvider,
                        VisitsProvider>(
                      create: (ctx) => VisitsProvider(),
                      update: (
                        ctx,
                        backend,
                        feedback,
                        filters,
                        doctor,
                        visits,
                      ) =>
                          visits!
                            ..update(backend, feedback, filters, doctor, ctx),
                    ),
                    ChangeNotifierProxyProvider2<BackendConnector,
                        FeedbackProvider, PositionProvider>(
                      create: (ctx) => PositionProvider(),
                      update: (ctx, backend, feedback, position) =>
                          position!..update(backend, feedback, ctx),
                    ),
                    ChangeNotifierProxyProvider2<BackendConnector,
                        FeedbackProvider, FacilityProvider>(
                      create: (ctx) => FacilityProvider(),
                      update: (ctx, backend, feedback, facilities) =>
                          facilities!..update(backend, feedback, ctx),
                    ),
                    ChangeNotifierProxyProvider2<BackendConnector,
                        FeedbackProvider, StatisticsProvider>(
                      create: (ctx) => StatisticsProvider(),
                      update: (ctx, backend, feedback, stats) =>
                          stats!..update(backend, feedback),
                    ),
                  ],
                  child: MaterialApp(
                    debugShowCheckedModeBanner: false,
                    localizationsDelegates:
                        GlobalMaterialLocalizations.delegates,
                    title: 'Revée',
                    theme: reveeTheme,
                    routes: routes,
                    supportedLocales: const [Locale('it')],
                  ),
                )
              : Material(
                  child: Center(
                    child: ReveeBouncingLoader(),
                  ),
                ),
    );
  }
}
