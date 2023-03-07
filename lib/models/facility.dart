import 'dart:developer' as dev;

import 'package:revee/models/facility_type.dart';
import 'package:revee/models/helpers.dart';

class Facility {
  final int id;
  final int typeId;
  final String name;
  final String province;
  final String shortName;
  final String region;
  final String? phoneNumber;
  final String? email;
  final String? website;
  final String? street;
  final String? houseNumber;
  final String? postalCode;
  final FacilityType facilityType;
  final bool isEditable;

  Facility({
    required this.id,
    required this.name,
    required this.typeId,
    required this.province,
    required this.shortName,
    required this.region,
    required this.isEditable,
    this.phoneNumber,
    this.email,
    this.website,
    this.street,
    this.houseNumber,
    this.postalCode,
    required this.facilityType,
  });

  String get address {
    final StringBuffer completeAddress = StringBuffer();

    if (street != null && (street?.isNotEmpty ?? false)) {
      completeAddress.write(street);
      completeAddress.write(', ');
    }

    if (houseNumber != null && (houseNumber?.isNotEmpty ?? false)) {
      completeAddress.write(houseNumber);
      completeAddress.write(', ');
    }

    if (postalCode != null && (postalCode?.isNotEmpty ?? false)) {
      completeAddress.write(postalCode);
      completeAddress.write(', ');
    }

    completeAddress.write(province);
    completeAddress.write(" ($shortName)");

    return completeAddress.toString();
  }

  ///Convert [json] from json map to Facility
  static Facility? fromJson(Map<String, dynamic> json) {
    try {
      final divisionData = json['FullDivision'] as Map<String, dynamic>;

      final provinceShortName = divisionData['shortName'] as String;
      final province = divisionData['province'] as String;
      final region = divisionData['region'] as String;

      return Facility(
        id: json['id'] as int,
        name: json['FacilityName'] as String,
        typeId: json['TypeId'] as int,
        phoneNumber: json['PhoneNumber'] as String?,
        email: (json['Email'] as String?) ?? "",
        website: json['Website'] as String?,
        street: (json['Street'] as String?) ?? "",
        houseNumber: (json['HouseNumber'] as String?) ?? "",
        postalCode: (json['PostalCode'] as String?) ?? "",
        province: province,
        shortName: provinceShortName,
        region: region,
        facilityType:
            FacilityType.fromJson(json["type"] as Map<String, dynamic>),
        isEditable: (DateTime.now()
                        .difference(
                          dateFromUTC(
                                json['createdAt'] as String? ??
                                    DateTime.now().toUtc().toString(),
                              ) ??
                              DateTime.now(),
                        )
                        .inHours /
                    24)
                .round() <=
            1, //True if less or equal than 1 day,,
      );
    } catch (e) {
      dev.log(e.toString());
      return null;
    }
  }
}
