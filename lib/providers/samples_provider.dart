import 'package:flutter/foundation.dart';

import 'package:revee/providers/feedback_provider.dart';
import 'package:revee/providers/backend_connector.dart';

import 'package:revee/models/sample.dart';

class SamplesProvider with ChangeNotifier {
  static const resourceName = "Samples";

  static const jsonWhereFilter = {
    "where": {
      "and": [
        {
          "disabled": false,
        },
      ],
    },
  };

  late FeedbackProvider _feedback;
  late BackendConnector _backend;

  List<Sample> _samples = [];
  List<Sample> get samples => [..._samples];

  void update(BackendConnector backend, FeedbackProvider feedback) {
    _backend = backend;
    _feedback = feedback;
    notifyListeners();
  }

  Future<void> fetchSamples() async {
    final oldSamples = [..._samples];

    try {
      _samples = [];

      final response = await _backend.getResource<dynamic>(
        resourceName,
        isJson: true,
        jsonFilters: [jsonWhereFilter],
      );

      for (final sampleData in response) {
        final temp = Sample.fromJson(sampleData as Map<String, dynamic>);

        if (temp != null) {
          _samples.add(temp);
        }
      }

      notifyListeners();
    } catch (error) {
      _samples = [...oldSamples];
      print(error.toString());
    }
  }
}
