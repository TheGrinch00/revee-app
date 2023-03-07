import 'package:flutter/material.dart';
import 'dart:developer' as dev;

import 'package:revee/providers/backend_connector.dart';
import 'package:revee/providers/feedback_provider.dart';

import 'package:revee/models/division.dart';
import 'package:revee/models/facility.dart';

class FacilityProvider with ChangeNotifier {
  // The actual resource used in the URL
  static const resourceName = "Facilities";

  late FeedbackProvider _feedback;
  late BackendConnector _backend;
  late BuildContext _context;

  List<Facility> _facilities = [];

  List<Facility> get facilities => [..._facilities];

  List<Facility> _searchFacilities = [];
  List<Facility> get searchFacilities => [..._searchFacilities];

  void update(
    BackendConnector backend,
    FeedbackProvider feedback,
    BuildContext context,
  ) {
    _backend = backend;
    _feedback = feedback;
    _context = context;
    notifyListeners();
  }

  Future<List<Facility>> fetchFacilities() async {
    try {
      final body = await _backend.getResource<List<dynamic>>(
        FacilityProvider.resourceName,
        filters: ["[include]=type"],
      );

      final List<Facility> fetchedFacilities = [];

      for (final facilityData in body) {
        final temp = Facility.fromJson(facilityData as Map<String, dynamic>);
        if (temp != null) {
          fetchedFacilities.add(temp);
        }
      }

      _facilities = [...fetchedFacilities];

      notifyListeners();

      return facilities;
    } catch (err) {
      dev.log(err.toString());
      _feedback.showFailFeedback(
        _context,
        "C'è stato un problema nel trasferire i dati sui medici ",
      );
      return [];
    }
  }

  Future<List<Division>> fetchDivisions() async {
    try {
      final body = await _backend.getResource<List<dynamic>>(
        "AllowedDivisions",
      );

      final List<Division> fetchedDivisions = [];

      for (final divisionData in body) {
        final temp = Division.fromJson(divisionData as Map<String, dynamic>);
        // ignore: unnecessary_null_comparison
        if (temp != null) {
          fetchedDivisions.add(temp);
        }
      }

      notifyListeners();

      return fetchedDivisions;
    } catch (err) {
      dev.log(err.toString());
      _feedback.showFailFeedback(
        _context,
        "C'è stato un problema nel trasferire i dati sulle provincie ",
      );
      return [];
    }
  }

  ///Create and insert to the DB a new Facility
  Future<Facility?> postFacility({
    required String name,
    required String division,
    required String type,
    String? telephone,
    String? email,
    String? website,
    String? address,
    String? houseNumber,
    String? cap,
  }) async {
    try {
      int divisionId = 6;
      switch (type) {
        case 'Ospedale pubblico':
          {
            divisionId = 6;
          }
          break;

        case 'Ospedale privato':
          {
            divisionId = 7;
          }
          break;

        case 'Farmacia':
          {
            divisionId = 8;
          }
          break;

        case 'Studio medico':
          {
            divisionId = 9;
          }
          break;

        case 'Parafarmacia':
          {
            divisionId = 10;
          }
          break;
      }

      final jsonBody = {
        "FacilityName": name,
        "TypeId": divisionId,
        "Division": division,
        "PhoneNumber": telephone ?? "",
        "Email": email ?? "",
        "Website": website ?? "",
        "Street": address ?? "",
        "HouseNumber": houseNumber ?? "",
        "Disable": false,
        "PostalCode": cap ?? "",
      };

      final responseBody =
          await _backend.postResource<dynamic>(resourceName, jsonBody);
      final temp = Facility.fromJson(responseBody as Map<String, dynamic>);

      if (temp != null) {
        _facilities.add(temp);
        notifyListeners();
      }

      return temp;
    } catch (err) {
      dev.log(err.toString());
      return null;
    }
  }

  ///Patch a facility
  Future<Facility?> patchFacility({
    required int id,
    required String name,
    required String division,
    required String type,
    String? telephone,
    String? email,
    String? website,
    String? address,
    String? houseNumber,
    String? cap,
  }) async {
    try {
      int divisionId = 6;
      switch (type) {
        case 'Ospedale pubblico':
          {
            divisionId = 6;
          }
          break;

        case 'Ospedale privato':
          {
            divisionId = 7;
          }
          break;

        case 'Farmacia':
          {
            divisionId = 8;
          }
          break;

        case 'Studio medico':
          {
            divisionId = 9;
          }
          break;

        case 'Parafarmacia':
          {
            divisionId = 10;
          }
          break;
      }

      final jsonBody = {
        "FacilityName": name,
        "TypeId": divisionId,
        "Division": division,
        "PhoneNumber": telephone ?? "",
        "Email": email ?? "",
        "Website": website ?? "",
        "Street": address ?? "",
        "HouseNumber": houseNumber ?? "",
        "Disable": false,
        "PostalCode": cap ?? "",
      };

      final responseBody =
          await _backend.patch<dynamic>(resourceName, jsonBody, id);
      final temp = Facility.fromJson(responseBody as Map<String, dynamic>);

      if (temp != null) {
        final index = _facilities.indexWhere((element) => element.id == id);
        if(index >= 0) {
          _facilities[index] = temp;
        } else {
          _facilities.add(temp);
        }
        notifyListeners();
      }

      return temp;
    } catch (err) {
      dev.log(err.toString());
      return null;
    }
  }

  Future<List<Facility>> searchFacilitiesByString(String searchString) async {
    Future.delayed(Duration.zero, () async {
      final List<Facility> temp = [];
      for (final fac in _facilities) {
        if (fac.name.toLowerCase().contains(searchString.toLowerCase())) {
          temp.add(fac);
        }
      }

      _searchFacilities = [...temp];
      notifyListeners();

      return _searchFacilities;
    });

    return _searchFacilities;
  }
}
