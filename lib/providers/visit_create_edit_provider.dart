import 'package:flutter/foundation.dart';

import 'package:revee/models/doctor.dart';
import 'package:revee/models/position.dart';
import 'package:revee/models/product.dart';
import 'package:revee/models/sample.dart';

class VisitSample {
  final int? visitSampleId;
  final Sample sample;
  int quantity;

  VisitSample({
    this.visitSampleId,
    required this.sample,
    required this.quantity,
  });

  static VisitSample? fromJson(Map<String, dynamic> json) {
    final visitSampleId = json["VisitSample"]["id"] as int?;
    final quantity = json["VisitSample"]["quantity"] as int?;

    final sample = Sample.fromJson(json);

    if (visitSampleId == null || sample == null || quantity == null) {
      return null;
    }

    return VisitSample(
      visitSampleId: visitSampleId,
      sample: sample,
      quantity: quantity,
    );
  }
}

class VisitCreateProvider with ChangeNotifier {
  late VisitCreateDoctorProvider _doctorProvider;

  Doctor? _doctor;
  Position? _position;
  String? _visitName;
  String? _visitDescription;
  List<Product> _selectedProducts = [];
  List<VisitSample> _selectedSamples = [];
  DateTime? _visitDate;

  Doctor? get doctor => _doctor;
  Position? get position => _position;
  String? get visitName => _visitName;
  String? get visitDescription => _visitDescription;
  List<Product> get selectedProducts => [..._selectedProducts];
  List<VisitSample> get selectedSamples => [..._selectedSamples];
  DateTime? get visitDate => _visitDate;

  set doctor(Doctor? value) {
    if (_doctor == null && value == null) return;
    if (_doctor?.id == value?.id) return;

    _doctorProvider.doctorId = value?.id;
    _doctor = value;
    _position = null;
    notifyListeners();
  }

  set position(Position? value) {
    if (_position == null && value == null) return;
    if (_position?.id == value?.id) return;

    _position = value;
    notifyListeners();
  }

  set visitName(String? value) {
    if (_visitName == null && value == null) return;
    if (_visitName == value) return;

    _visitName = value;
    notifyListeners();
  }

  set visitDescription(String? value) {
    if (_visitDescription == null && value == null) return;
    if (_visitDescription == value) return;

    _visitDescription = value;
    notifyListeners();
  }

  set visitDate(DateTime? value) {
    _visitDate = value;
    notifyListeners();
  }

  set selectedProducts(List<Product> products) {
    _selectedProducts = [...products];
    notifyListeners();
  }

  void toggleProduct(Product p) {
    if (_selectedProducts.any((prod) => p.id == prod.id)) {
      _selectedProducts.removeWhere((prod) => prod.id == p.id);
    } else {
      _selectedProducts.add(p);
    }
    notifyListeners();
  }

  void setSample(Sample s, {int? quantity, bool? isGiven = false}) {
    final isSampleAlreadyAdded =
        _selectedSamples.any((sample) => sample.sample.id == s.id);

    if (s.type == AllowedTypes.BOOL) {
      if (isSampleAlreadyAdded) {
        if (!(isGiven ?? false)) {
          _selectedSamples.removeWhere((sample) => sample.sample.id == s.id);
        } else {
          _selectedSamples
              .firstWhere((sample) => sample.sample.id == s.id)
              .quantity = 1;
        }
      } else {
        if (isGiven == true) {
          _selectedSamples.add(VisitSample(sample: s, quantity: 1));
        }
      }
    } else if (s.type == AllowedTypes.NUMBER) {
      if (quantity == null || quantity <= 0) {
        if (isSampleAlreadyAdded) {
          _selectedSamples.removeWhere((sample) => sample.sample.id == s.id);
        }
      } else {
        if (isSampleAlreadyAdded) {
          _selectedSamples
              .firstWhere((sample) => sample.sample.id == s.id)
              .quantity = quantity;
        } else {
          _selectedSamples.add(VisitSample(sample: s, quantity: quantity));
        }
      }
    }

    notifyListeners();
  }

  void update(VisitCreateDoctorProvider doctorProvider) {
    _doctorProvider = doctorProvider;
    notifyListeners();
  }

  void clear() {
    _doctor = null;
    _position = null;
    _visitName = null;
    _visitDescription = null;
    _selectedProducts = [];
    _selectedSamples = [];
    _visitDate = null;
    _doctorProvider.clear();
    notifyListeners();
  }
}

class VisitCreateDoctorProvider with ChangeNotifier {
  int? _doctorId;

  int? get doctorId => _doctorId;

  set doctorId(int? value) {
    if (_doctorId == null && value == null) return;
    if (_doctorId == value) return;

    _doctorId = value;
    notifyListeners();
  }

  void clear() {
    _doctorId = null;
    notifyListeners();
  }
}
