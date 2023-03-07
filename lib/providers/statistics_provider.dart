import 'package:flutter/material.dart';
import 'package:revee/models/statistics.dart';
import 'package:revee/providers/backend_connector.dart';
import 'package:revee/providers/feedback_provider.dart';
import 'dart:developer' as dev;

class StatisticsProvider with ChangeNotifier {
  late FeedbackProvider _feedbackProvider;
  late BackendConnector _backendConnector;

  BaseStatistics? baseStatistics;

  void update(BackendConnector backend, FeedbackProvider feedback) {
    _backendConnector = backend;
    _feedbackProvider = feedback;
    notifyListeners();
  }

  Future<BaseStatistics?> fetchBaseStatistics() async {
    try {
      final data = await _backendConnector.getRequest(
        '/members/me/stats',
        isJson: true,
      ) as Map<String, dynamic>;

      dev.log(data.toString());

      baseStatistics = BaseStatistics.fromJson(data);

      notifyListeners();
      return baseStatistics;
    } catch (e) {
      dev.log(e.toString(), error: e);
    }
    return null;
  }

  Future<BaseStatistics?> getBaseStats() async {
    if (baseStatistics == null) {
      await fetchBaseStatistics();
    }
    return baseStatistics;
  }
}
