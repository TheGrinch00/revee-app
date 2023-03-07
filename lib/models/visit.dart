import 'dart:developer' as dev;

import 'package:revee/models/helpers.dart' show dateFromUTC;

import 'package:revee/models/product.dart';
import 'package:revee/models/doctor.dart';
import 'package:revee/providers/visit_create_edit_provider.dart';

class Visit {
  final int id;
  final String? title;
  final DateTime? scheduledDate;
  final DateTime realDate;
  final int positionId;
  final int agentId; //"MemberId" in DB
  final List<Product> products;
  final List<VisitSample> samples;
  final bool guaine;
  final bool ricettarioGuaine;
  final bool ricettarioGel;
  final bool isEditable;
  final int cuffieSalaOperatoria;
  final int campioniGel;
  final Doctor? doctor;
  final String? report;
  final String? hospitalName;

  //there weren't in old app
  final int cuffie;
  final bool gel;
  final int employeeId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Visit({
    required this.employeeId,
    this.hospitalName,
    this.title,
    this.createdAt,
    this.updatedAt,
    required this.id,
    this.report,
    this.scheduledDate,
    this.doctor,
    required this.realDate,
    required this.positionId,
    required this.agentId,
    required this.products,
    required this.samples,
    required this.isEditable,
    this.cuffie = 0,
    this.campioniGel = 0,
    this.cuffieSalaOperatoria = 0,
    this.ricettarioGuaine = false,
    this.ricettarioGel = false,
    this.guaine = false,
    this.gel = false,
  });

  String get nameAndSurnameDoctor {
    return "${doctor?.name} ${doctor?.surname}";
  }

  ///Convert [json] from json map to Visit
  static Visit? fromJson(Map<String, dynamic> json) {
    final List<Product> products = [];
    final List<VisitSample> samples = [];

    if (json.containsKey("products")) {
      final productsData = json["products"];

      for (final productData in productsData) {
        final temp = Product.fromJson(productData as Map<String, dynamic>);

        products.add(temp);
      }
    }

    if (json.containsKey("samples")) {
      final samplesData = json["samples"];

      for (final sampleData in samplesData) {
        final temp = VisitSample.fromJson(sampleData as Map<String, dynamic>);
        if (temp != null) {
          samples.add(temp);
        }
      }
    }

    try {
      final doctorData = json["employee"] as Map<String, dynamic>?;
      late final Doctor? doctor;

      if (doctorData != null) {
        doctor = Doctor.fromJson(doctorData);
      } else {
        doctor = null;
      }

      final fetchedScheduledDate = json["ScheduledDate"] as String?;
      final fetchedRealDate = json["RealDate"] as String;

      return Visit(
        id: json['id'] as int,
        positionId: json['PositionId'] as int,
        title: json["Name"] as String?,
        scheduledDate: fetchedScheduledDate == null
            ? null
            : dateFromUTC(fetchedScheduledDate),
        realDate: dateFromUTC(fetchedRealDate)!,
        report: json['Report'] as String?,
        agentId: json['MemberId'] as int,
        products: products,
        samples: samples,
        doctor: doctor,
        hospitalName: json.containsKey("position")
            ? json["position"]["facility"]["FacilityName"] as String?
            : null,
        employeeId: json['EmployeeId'] as int,
        createdAt: dateFromUTC(json['createdAt'] as String),
        updatedAt: dateFromUTC(json['updatedAt'] as String),
        isEditable: (DateTime.now()
                        .difference(
                          dateFromUTC(json['createdAt'] as String) ??
                              DateTime.now(),
                        )
                        .inHours /
                    24)
                .round() <=
            1, //True if less or equal than 1 day
      );
    } catch (e) {
      dev.log(e.toString());
      dev.log(json.toString());
      return null;
    }
  }
}
