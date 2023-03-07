import 'package:flutter/material.dart';
import 'package:revee/models/employment.dart';

import 'dart:developer' as dev;

import 'package:revee/providers/backend_connector.dart';
import 'package:revee/providers/feedback_provider.dart';

class EmploymentProvider with ChangeNotifier {
  void update(BackendConnector backend, FeedbackProvider feedback) {
    _backend = backend;
    _feedback = feedback;
    notifyListeners();
  }

  static const String resource = 'Employments';

  late FeedbackProvider _feedback;
  late BackendConnector _backend;

  List<Employment> _employments = [];

  List<Employment> get employments {
    return [..._employments];
  }

  Future<List<Employment>> fetchEmployments(BuildContext ctx) async {
    try {
      final data = await _backend
          .getResource<List<dynamic>>(EmploymentProvider.resource);

      final List<Employment> temp = [];

      for (final employmentData in data) {
        temp.add(Employment.fromJson(employmentData as Map<String, dynamic>));
      }

      _employments = [...temp];

      notifyListeners();
      return employments;
    } catch (err) {
      dev.log(err.toString());
      _feedback.showFailFeedback(
        ctx,
        "C'è stato un problema nel trasferire i dati sui medici ",
      );
      return [];
    }
  }
}
