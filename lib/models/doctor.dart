import 'package:flutter/material.dart';
import 'package:revee/models/position.dart';
import 'package:revee/models/visit.dart';

import 'package:revee/models/helpers.dart' show dateFromUTC;

enum DoctorStatus {
  VISITED,
  EXPIRED,
  NEVER_VISITED,
}

// @TODO: Complete with positions and visits

class Doctor {
  final int id;
  final String name;
  final String surname;
  final String? phoneNumber;
  final String email;
  final DateTime? birthDate;
  final String? photoURL;
  final bool privacy;
  final DateTime? creationDate;
  final String? categoryReason;
  final bool isEditable;
  final int categoryRegularity;
  final String categoryName;
  final DateTime? lastVisit;
  final DateTime? firstVisit;
  final String? note;
  final DoctorStatus status;
  final int? expirationDays;
  final List<Position> positions;
  final List<Visit> visits;

  Doctor({
    this.id = -1,
    required this.name,
    required this.surname,
    this.phoneNumber,
    required this.email,
    this.birthDate,
    this.photoURL,
    this.privacy = false,
    required this.creationDate,
    required this.isEditable,
    required this.categoryRegularity,
    required this.categoryName,
    this.positions = const [],
    this.visits = const [],
    this.firstVisit,
    this.lastVisit,
    this.note,
    this.categoryReason,
    this.status = DoctorStatus.VISITED,
    required this.expirationDays,
  });
  String get nameAndSurname => "$name $surname";

  Color get gravityColor {
    if (status == DoctorStatus.VISITED) {
      return Colors.blue;
    }

    if (expirationDays! < 0) {
      return Colors.red;
    } else if (expirationDays! <= 10) {
      return Colors.green;
    } else if (expirationDays! <= 20) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  ///Convert [json] from json map to Employee
  static Doctor? fromJson(Map<String, dynamic> json) {
    try {
      final expiredDays = json["daysExpired"] as int?;
      late final DoctorStatus status;

      if (expiredDays == null) {
        status = DoctorStatus.VISITED;
      } else if (expiredDays == -1) {
        status = DoctorStatus.NEVER_VISITED;
      } else {
        status = DoctorStatus.EXPIRED;
      }

      final id = json['id'] as int;

      // Anagraphics
      final name = json["EmployeeName"] as String;
      final surname = json["EmployeeSurname"] as String;
      final phoneNumber = json["EmployeePhoneNumber"] as String?;
      final email = json["EmployeeEmail"] as String;
      final birthDate = json["EmployeeBirthDate"] as String?;
      final photoURL = json["EmployeeProfilePictureURL"] as String?;

      // Generic data
      final creationDate = json["CreationDate"] as String?;
      final privacy = json["PrivacyAccepted"] as bool;
      final firstVisit = json["FirstVisit"] as String?;
      final lastVisit = json["LastVisit"] as String?;
      final note = json["Comment"] as String?;

      // Category
      final categoryName = json["category"]["Category"] as String;
      final categoryRegularity = json["category"]["Regularity"] as int;
      final categoryReason = json["CategoryReason"] as String?;

      // Positions
      final positionsData = json["positions"] as List<dynamic>? ?? [];
      final List<Position> positions = [];

      for (final positionData in positionsData) {
        final tempPosition =
            Position.fromJson(positionData as Map<String, dynamic>);

        if (tempPosition != null) {
          positions.add(tempPosition);
        }
      }

      // Visits
      final visitsData = json["visits"] as List<dynamic>? ?? [];
      final List<Visit> visits = [];

      for (final visitData in visitsData) {
        final tempVisit = Visit.fromJson(visitData as Map<String, dynamic>);

        if (tempVisit != null) {
          visits.add(tempVisit);
        }
      }

      return Doctor(
        id: id,
        name: name,
        surname: surname,
        phoneNumber: phoneNumber,
        email: email,
        photoURL: photoURL,
        privacy: privacy,
        birthDate: birthDate == null ? null : dateFromUTC(birthDate),
        creationDate: creationDate == null ? null : dateFromUTC(creationDate),
        firstVisit: firstVisit == null ? null : dateFromUTC(firstVisit),
        lastVisit: lastVisit == null ? null : dateFromUTC(lastVisit),
        note: note ?? "",
        categoryName: categoryName,
        categoryRegularity: categoryRegularity,
        categoryReason: categoryReason,
        isEditable: (DateTime.now()
                        .difference(
                          dateFromUTC(json['createdAt'] as String) ??
                              DateTime.now(),
                        )
                        .inHours /
                    24)
                .round() <=
            1, //True if less or equal than 1 day,
        status: status,
        expirationDays: expiredDays,
        positions: positions,
        visits: visits
          ..sort((v1, v2) => v1.realDate.isBefore(v2.realDate) ? 1 : -1),
      );
    } catch (e) {
      return null;
    }
  }

  bool operator >(Doctor other) {
    if (expirationDays == null) return true;
    if (other.expirationDays == null) return false;
    if (expirationDays == -1) return true;
    if (other.expirationDays == -1) return false;

    return (expirationDays! - other.expirationDays!) > 0;
  }
}
