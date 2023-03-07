import 'package:flutter/material.dart';
import 'dart:developer' as dev;

import 'package:revee/models/doctor.dart';
import 'package:revee/models/position.dart';
import 'package:revee/models/product.dart';
import 'package:revee/models/visit.dart';
import 'package:revee/providers/doctor_provider.dart';
import 'package:revee/providers/visit_create_edit_provider.dart';

import 'package:revee/providers/visits_filters_provider.dart';
import 'package:revee/providers/backend_connector.dart';
import 'package:revee/providers/feedback_provider.dart';

class VisitsProvider extends ChangeNotifier {
  // The actual resource used in the URL
  static const resourceName = "members/me/visits";

  static const jsonIncludeFilter = {
    "include": [
      "samples",
      {
        "products": ["attachments", "productCategory"]
      },
      {
        "employee": ["category", "visits"]
      },
      {
        "position": {"facility": "type"}
      }
    ]
  };

  static const jsonOrderFilter = {
    "order": "RealDate DESC",
  };

  late FeedbackProvider _feedback;
  late BackendConnector _backend;
  late VisitsFiltersProvider _filters;
  late DoctorProvider _doctor;

  late BuildContext _context;

  List<Visit> _visits = [];
  List<Visit> get visits => [..._visits];

  Visit? _visitDetails;
  Visit? get visitDetails => _visitDetails;

  void update(
    BackendConnector backend,
    FeedbackProvider feedback,
    VisitsFiltersProvider filters,
    DoctorProvider doctor,
    BuildContext context,
  ) {
    _backend = backend;
    _feedback = feedback;
    _filters = filters;
    _doctor = doctor;
    _context = context;

    _filters.addListener(() {
      if (_filters.didFiltersChange) {
        fetchVisits();
        _filters.didFiltersChange = false;
      }
    });

    notifyListeners();
  }

  Future<void> fetchVisits() async {
    try {
      final body = await _backend.getResourceWithoutHeader<List<dynamic>>(
        VisitsProvider.resourceName,
        isJson: true,
        jsonFilters: [
          {
            "include": {"employee": "category"}
          },
          jsonOrderFilter,
          _filters.jsonWhereFilters
        ],
      );

      final List<Visit> temp = [];

      for (final visitData in body) {
        final tempVisit = Visit.fromJson(visitData as Map<String, dynamic>);
        if (tempVisit != null) {
          temp.add(tempVisit);
        }
      }

      _visits = [...temp];

      notifyListeners();
    } catch (err) {
      dev.log(err.toString());
      _feedback.showFailFeedback(
        _context,
        "C'è stato un problema nel trasferire i dati sulle visite",
      );
    }
  }

  Future<void> getVisitById(int id) async {
    try {
      final visitData = await _backend.getRequest<dynamic>(
        "visits/$id",
        isJson: true,
        jsonFilters: [jsonIncludeFilter],
      );

      _visitDetails = Visit.fromJson(visitData as Map<String, dynamic>);
    } catch (err) {
      dev.log(err.toString());
      _feedback.showFailFeedback(
        _context,
        "C'è stato un problema nel trasferire i dati sulla visita",
      );
    }
  }

  static const jsonInclude = {
    "include": [
      {
        "positions": [
          "ward",
          "employment",
          {"facility": "type"}
        ]
      },
      "visits",
      "category"
    ]
  };

  Future<Visit?> postVisit({
    required int agentId,
    required Doctor doctor,
    required Position position,
    String? visitName,
    String? visitDescription,
    List<Product>? products,
    List<VisitSample>? samples,
    required DateTime visitDate,
  }) async {
    try {
      final jsonBody = {
        "MemberId": agentId,
        "EmployeeId": doctor.id,
        "PositionId": position.id,
        "ScheduledDate": visitDate.toIso8601String(),
        "RealDate": visitDate.toIso8601String(),
        "Name": visitName,
        "Report": visitDescription,
      };

      final Map<String, dynamic> responseBody =
          await _backend.postResource<dynamic>(resourceName, jsonBody)
              as Map<String, dynamic>;

      final doctorData = await _backend.getRequest<dynamic>(
        "${DoctorProvider.resourceName}/${doctor.id}",
        isJson: true,
        jsonFilters: [jsonInclude],
      );

      responseBody.addAll({"employee": doctorData as Map<String, dynamic>});

      final temp = Visit.fromJson(responseBody);

      if (temp != null) {
        if (products != null && products.isNotEmpty) {
          for (final prod in products) {
            final jsonBody = {
              "visitId": temp.id,
              "productId": prod.id,
            };

            await _backend.postResource<dynamic>(
              "ProductVisits",
              jsonBody,
            );
          }
        }

        if (samples != null && samples.isNotEmpty) {
          for (final visitSample in samples) {
            final jsonBody = {
              "visitId": temp.id,
              "sampleId": visitSample.sample.id,
              "quantity": visitSample.quantity,
            };

            await _backend.postResource<dynamic>(
              "VisitSamples",
              jsonBody,
            );
          }
        }

        _visits.add(temp);
        notifyListeners();
      }

      return temp;
    } catch (err) {
      dev.log(err.toString());
      return null;
    }
  }

  Future<Visit?> editVisit({
    required int agentId,
    required Doctor doctor,
    required Position position,
    String? visitName,
    String? visitDescription,
    List<Product>? products,
    List<VisitSample>? samples,
    required DateTime visitDate,
    required int visitId,
    List<VisitSample>? samplesBefore, //Samples Selected before edit
    List<Product>? productsBefore, // Products Selected before edit
  }) async {
    try {
      final jsonBody = {
        "MemberId": agentId,
        "EmployeeId": doctor.id,
        "PositionId": position.id,
        "ScheduledDate": visitDate.toIso8601String(),
        "RealDate": visitDate.toIso8601String(),
        "Name": visitName,
        "Report": visitDescription,
        "id": visitId
      };
      final responseBody = await _backend.patch<dynamic>(
        "visits",
        jsonBody,
        visitId,
      );

      final temp = Visit.fromJson(responseBody as Map<String, dynamic>);
      if (temp != null) {
        // Deletes all products from visit
        if (productsBefore != null && productsBefore.isNotEmpty) {
          for (final prod in productsBefore) {
            await _backend.delete<dynamic>(
              "ProductVisits",
              prod.productVisit!.id,
            );
          }
        }

        if (products != null && products.isNotEmpty) {
          for (final prod in products) {
            final jsonBody = {
              "visitId": visitId,
              "productId": prod.id,
            };
            await _backend.postResource<dynamic>(
              "ProductVisits",
              jsonBody,
            );
          }
        }

        // PART SAMPLES
        print("PART SAMPLES");
        //ALL SAMPLES TO 0, surely there is not the most efficient way to avoid this for loop
        if (samplesBefore != null && samplesBefore.isNotEmpty) {
          for (final visitSample in samplesBefore) {
            final jsonBody = {
              "visitId": visitId,
              "sampleId": visitSample.sample.id,
              "quantity": 0,
            };
            await _backend.patch<dynamic>(
              "VisitSamples",
              jsonBody,
              visitSample.visitSampleId ?? -1,
            );
          }
        }

        if (samples != null && samples.isNotEmpty) {
          for (final visitSample in samples) {
            //print(visitSample.quantity.toString());
            final jsonBody = {
              "visitId": visitId,
              "sampleId": visitSample.sample.id,
              "quantity": visitSample.quantity,
            };
            //IF I ADD/ REMOVE SAMPLES THAT USER ALREADY ADDED
            final VisitSample visitSampleBeforeEdit = samplesBefore!.firstWhere(
              (sample) => sample.sample.id == visitSample.sample.id,
              orElse: () => visitSample,
            );
            if (visitSampleBeforeEdit != visitSample) {
              final int? idSample = visitSampleBeforeEdit.visitSampleId;
              //print("Questo è idSample");
              //print(idSample.toString());
              await _backend.patch<dynamic>(
                "VisitSamples",
                jsonBody,
                idSample ?? -1,
              );
            } else {
              //IF I ADD SAMPLES THAT USER NEVER ADDED
              await _backend.postResource<dynamic>(
                "VisitSamples",
                jsonBody,
              );
            }
          }
        }
        _visits.removeWhere((visit) => visit.id == visitId);
        _visits.add(temp);
        notifyListeners();
      }

      return temp;
    } catch (err) {
      dev.log(err.toString());
      return null;
    }
  }
}
