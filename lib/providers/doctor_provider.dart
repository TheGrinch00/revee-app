import 'dart:io';

import 'package:flutter/material.dart';
import 'package:revee/models/position.dart';
import 'package:revee/providers/backend_connector.dart';
import 'dart:developer' as dev;
import 'package:revee/models/doctor.dart';
import 'package:revee/providers/feedback_provider.dart';

class DoctorProvider with ChangeNotifier {
  // The actual resource used in the URL
  static const resourceName = "Employees";

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

  // ignore: unused_field
  late FeedbackProvider _feedback;
  late BackendConnector _backend;

  List<Doctor> _doctors = [];
  List<Doctor> get doctors => [..._doctors];

  List<Doctor> _expiringDoctors = [];
  List<Doctor> get expiringDoctors => [..._expiringDoctors];

  List<Doctor> _searchDoctors = [];
  List<Doctor> get searchDoctors => [..._searchDoctors];

  Doctor? _detailDoctor;
  Doctor? get detailDoctor => _detailDoctor;

  void update(BackendConnector backend, FeedbackProvider feedback) {
    _backend = backend;
    _feedback = feedback;
    notifyListeners();
  }

  String getImageUrl(String nameFile) {
    return _backend.getImageUrl(nameFile);
  }

  void addPositionToDetailEmployee(Position position) {
    _detailDoctor?.positions.add(position);
    notifyListeners();
  }

  Future<List<Doctor>> fetchDoctors() async {
    final body = await _backend.getResource<List<dynamic>>(
      DoctorProvider.resourceName,
      filters: ["[include]=category", "[where][Disabled]=0"],
    );

    final List<Doctor> temp = [];

    for (final employeeData in body) {
      final tempEmployee =
          Doctor.fromJson(employeeData as Map<String, dynamic>);
      if (tempEmployee != null) {
        temp.add(tempEmployee);
      }
    }

    _doctors = [...temp];
    notifyListeners();

    return doctors;
  }

  Future<void> fetchExpiringEmployees() async {
    final expiringDoctorsData = await _backend.getRequest<List<dynamic>>(
      "Members/me/expired",
    );

    final List<Doctor> temp = [];

    for (final employeeData in expiringDoctorsData) {
      final tempEmployee =
          Doctor.fromJson(employeeData as Map<String, dynamic>);
      if (tempEmployee != null) {
        temp.add(tempEmployee);
      }
    }

    _expiringDoctors = [...temp]..sort(
        (doctorA, doctorB) => doctorA > doctorB ? -1 : 1,
      );
    notifyListeners();
  }

  Future<Doctor?> getDoctorById(int id) async {
    final doctorData = await _backend.getRequest<dynamic>(
      "${DoctorProvider.resourceName}/$id",
      isJson: true,
      jsonFilters: [jsonInclude],
    );

    final employee = Doctor.fromJson(doctorData as Map<String, dynamic>);

    if (employee != null) {
      _detailDoctor = employee;
      notifyListeners();
      return employee;
    } else {
      return null;
    }
  }

  Future<Position?> createEmployeePosition(
    BuildContext context, {
    required int doctorId,
    required int wardId,
    required int employmentId,
    required int facilityId,
    TimeOfDay? visitStart,
    TimeOfDay? visitEnd,
    int? weekday,
  }) async {
    final body = {
      "EmployeeId": doctorId,
      "WardId": wardId,
      "EmploymentId": employmentId,
      "FacilityId": facilityId,
      "MeetingStartHour": visitStart?.hour,
      "MeetingStartMinute": visitStart?.minute,
      "MeetingEndHour": visitEnd?.hour,
      "MeetingEndMinute": visitEnd?.minute,
      "MeetingDay": weekday,
      "Disabled": false,
    };

    final uri = "${DoctorProvider.resourceName}/$doctorId/Positions";

    final positionData =
        await _backend.postRequest<dynamic>(context, uri, body: body);

    if (positionData == null) {
      return null;
    }

    final positionId = positionData["id"] as int?;

    if (positionId == null) {
      return null;
    }

    final positionIncludes = {
      "include": [
        "ward",
        "employment",
        {"facility": "type"}
      ]
    };

    final completePositionData = await _backend.getRequest<dynamic>(
      "Positions/$positionId",
      isJson: true,
      jsonFilters: [positionIncludes],
    );

    return Position.fromJson(completePositionData as Map<String, dynamic>);
  }

  ///Create and insert to the DB a new Doctor
  Future<Doctor?> postDoctor({
    required String name,
    required String surname,
    required String email,
    String? note,
    required String category,
    DateTime? birthDate,
    String? categoryReason,
    String? numeroTelefono,
    String? urlPhoto,
  }) async {
    try {
      final jsonBody = {
        "EmployeeName": name,
        "EmployeeSurname": surname,
        "EmployeePhoneNumber": numeroTelefono ?? "",
        "EmployeeEmail": email,
        "EmployeeBirthDate": birthDate!.toIso8601String(),
        "EmployeeProfilePictureURL": urlPhoto ?? "",
        "CategoryId": category == "Fascia A" ? 1 : 2,
        "CategoryReason": categoryReason ?? "",
        "Comment": note ?? "",
      };
      final responseBody =
          await _backend.postResource<dynamic>(resourceName, jsonBody);
      final temp = Doctor.fromJson(responseBody as Map<String, dynamic>);

      if (temp != null) {
        _doctors.add(temp);
        notifyListeners();
      }

      return temp;
    } catch (err) {
      dev.log(err.toString());
      return null;
    }
  }

  ///update a doctor
  Future<Doctor?> patchDoctor({
    required int id,
    required String name,
    required String surname,
    required String email,
    String? note,
    required String category,
    DateTime? birthDate,
    String? categoryReason,
    String? numeroTelefono,
    String? urlPhoto,
  }) async {
    try {
      final jsonBody = {
        "id": id,
        "EmployeeName": name,
        "EmployeeSurname": surname,
        "EmployeePhoneNumber": numeroTelefono ?? "",
        "EmployeeEmail": email,
        "EmployeeBirthDate": birthDate!.toIso8601String(),
        "EmployeeProfilePictureURL": urlPhoto ?? "",
        "CategoryId": category == "Fascia A" ? 1 : 2,
        "CategoryReason": categoryReason ?? "",
        "Comment": note ?? "",
      };
      final responseBody =
          await _backend.patch<dynamic>(resourceName, jsonBody, id);
      final temp = Doctor.fromJson(responseBody as Map<String, dynamic>);

      if (temp != null) {
        final index = _doctors.indexWhere((element) => element.id == id);
        if (index >= 0) {
          _doctors[index] = temp;
        } else {
          _doctors.add(temp);
        }
        notifyListeners();
      }

      return temp;
    } catch (err) {
      dev.log(err.toString());
      return null;
    }
  }

  Future<String?>? uploadImage(File? picture) {
    try {
      if (picture != null) {
        return _backend.uploadImage(picture);
      } else {
        return null;
      }
    } catch (err) {
      dev.log(err.toString());
    }
    return null;
  }

  List<Doctor> searchDoctorsByString(String searchString) {
    _searchDoctors = _doctors.where((doctor) {
      return doctor.name.toLowerCase().contains(searchString.toLowerCase()) ||
          doctor.surname.toLowerCase().contains(searchString.toLowerCase()) ||
          doctor.nameAndSurname
              .toLowerCase()
              .contains(searchString.toLowerCase());
    }).toList();
    notifyListeners();

    return searchDoctors;
  }
}
