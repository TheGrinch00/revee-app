import 'package:flutter/cupertino.dart';
import 'package:revee/models/position.dart';

import 'package:revee/providers/backend_connector.dart';
import 'package:revee/providers/feedback_provider.dart';

class PositionProvider with ChangeNotifier {
  void update(
    BackendConnector backend,
    FeedbackProvider feedback,
    BuildContext ctx,
  ) {
    _backend = backend;
    _feedback = feedback;
    _context = ctx;
    notifyListeners();
  }

  static const String resource = 'Positions';
  static const Map<String, dynamic> includeFilter = {
    "include": [
      "ward",
      "employment",
      {"facility": "type"}
    ]
  };

  late FeedbackProvider _feedback;
  late BackendConnector _backend;
  late BuildContext _context;

  List<Position> _positions = [];

  List<Position> get positions {
    return [..._positions];
  }

  Future<List<Position>> fetchPositionsByDoctorId(int doctorId) async {
    try {
      final whereFilter = {
        "where": {
          "and": [
            {
              "EmployeeId": doctorId,
            },
          ],
        },
      };

      final data = await _backend.getResource<List<dynamic>>(
        PositionProvider.resource,
        isJson: true,
        jsonFilters: [whereFilter, includeFilter],
      );

      final List<Position> temporaryList = [];

      for (final positionData in data) {
        final temp = Position.fromJson(positionData as Map<String, dynamic>);

        if (temp != null) {
          temporaryList.add(temp);
        }
      }

      _positions = [...temporaryList];

      notifyListeners();
      return positions;
    } catch (e) {
      _feedback.showFailFeedback(
        _context,
        "Il server ha risposto con errore",
      );
      return [];
    }
  }
}
