import 'package:flutter/cupertino.dart';
import 'package:revee/models/ward.dart';

import 'dart:developer' as dev;

import 'package:revee/providers/backend_connector.dart';
import 'package:revee/providers/feedback_provider.dart';

class WardProvider with ChangeNotifier {
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

  static const String resource = 'Wards';

  late FeedbackProvider _feedback;
  late BackendConnector _backend;
  late BuildContext _context;

  List<Ward> _wards = [];

  List<Ward> get wards {
    return [..._wards];
  }

  Future<List<Ward>> fetchWards() async {
    try {
      final data =
          await _backend.getResource<List<dynamic>>(WardProvider.resource);

      final List<Ward> temp = [];

      for (final wardData in data) {
        temp.add(Ward.fromJson(wardData as Map<String, dynamic>));
      }

      _wards = [...temp];

      notifyListeners();
      return wards;
    } catch (err) {
      dev.log(err.toString());
      _feedback.showFailFeedback(
        _context,
        "C'è stato un problema durante l'accesso con Google",
      );
      return [];
    }
  }
}
