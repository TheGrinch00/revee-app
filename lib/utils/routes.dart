import 'package:flutter/material.dart';
import 'package:revee/screens/dynamic_page.dart';
import 'package:revee/screens/hospital_create_screen.dart';
import 'package:revee/screens/products_accordion_screen.dart';
import 'package:revee/screens/visit_create_screen.dart';

import 'package:revee/screens/profile_screen.dart';
import 'package:revee/widgets/generic/protected_route.dart';

import 'package:revee/screens/doctors_screen.dart';
import 'package:revee/screens/expiring_doctors_screen.dart';
import 'package:revee/screens/hospitals_screen.dart';
import 'package:revee/screens/login_screen.dart';
import 'package:revee/screens/statistics_screen.dart';
import 'package:revee/screens/visits_screen.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  // "/" route is the first loaded by the app if no "home" property is provided.
  '/': (context) => const DynamicPage(),
  LoginScreen.routeName: (context) => LoginScreen(),
  ExpiringDoctorsScreen.routeName: (context) => ProtectedRoute(
        successPage: ExpiringDoctorsScreen(),
        rejectedPage: LoginScreen(),
      ),
  DoctorsScreen.routeName: (context) => ProtectedRoute(
        successPage: DoctorsScreen(),
        rejectedPage: LoginScreen(),
      ),
  HospitalsScreen.routeName: (context) => ProtectedRoute(
        successPage: HospitalsScreen(),
        rejectedPage: LoginScreen(),
      ),
  VisitsScreen.routeName: (context) => ProtectedRoute(
        successPage: VisitsScreen(),
        rejectedPage: LoginScreen(),
      ),
  VisitCreateScreen.routeName: (context) => ProtectedRoute(
        successPage: const VisitCreateScreen(),
        rejectedPage: LoginScreen(),
      ),
  CreateNewFacilityScreen.routeName: (context) => ProtectedRoute(
        successPage: const CreateNewFacilityScreen(),
        rejectedPage: LoginScreen(),
      ),
  ProductsAccordionPage.routeName: (context) => ProtectedRoute(
        successPage: const ProductsAccordionPage(),
        rejectedPage: LoginScreen(),
      ),
  StatisticsScreen.routeName: (context) => ProtectedRoute(
        successPage: StatisticsScreen(),
        rejectedPage: LoginScreen(),
      ),
  ProfileScreen.routeName: (context) => ProtectedRoute(
        successPage: ProfileScreen(),
        rejectedPage: LoginScreen(),
      ),
};
