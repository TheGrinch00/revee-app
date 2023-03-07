import 'package:revee/models/facility.dart';

class Position {
  int? id;
  final String? employment;
  final String? ward;
  final Facility? facility;
  final int? meetingDay;
  final int? meetingStartHour;
  final int? meetingStartMinute;
  final int? meetingEndHour;
  final int? meetingEndMinute;

  Position({
    this.id, //In old app defaul value -1
    required this.employment,
    required this.ward,
    required this.facility,
    required this.meetingDay,
    required this.meetingStartHour,
    required this.meetingStartMinute,
    required this.meetingEndHour,
    required this.meetingEndMinute,
  });

  bool get hasTimingData {
    return meetingStartHour != null &&
        meetingStartMinute != null &&
        meetingEndHour != null &&
        meetingEndMinute != null;
  }

  String get meetingDetails {
    if (!hasTimingData) {
      return 'Info temporali non disponibili';
    }
    late final String stringDay;

    switch (meetingDay) {
      case 0:
        stringDay = "Lunedì";
        break;
      case 1:
        stringDay = "Martedì";
        break;
      case 2:
        stringDay = "Mercoledì";
        break;
      case 3:
        stringDay = "Giovedì";
        break;
      case 4:
        stringDay = "Venerdì";
        break;
      case 5:
        stringDay = "Sabato";
        break;
      case 6:
        stringDay = "Domenica";
        break;
      default:
        stringDay = "Tutti i giorni";
    }

    final String formattedStartTime =
        "${meetingStartHour.toString().padLeft(2, '0')}:${meetingStartMinute.toString().padLeft(2, '0')}";
    final String formattedEndTime =
        "${meetingEndHour.toString().padLeft(2, '0')}:${meetingEndMinute.toString().padLeft(2, '0')}";

    return "$stringDay dalle $formattedStartTime alle $formattedEndTime";
  }

  ///Convert [json] from json map to Position
  static Position? fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int?;
    final employment = json["employment"]["Employment"] as String?;
    final ward = json["ward"]["Ward"] as String?;
    final meetingDay = json["MeetingDay"] as int?;
    final meetingStartHour = json["MeetingStartHour"] as int?;
    final meetingStartMinute = json["MeetingStartMinute"] as int?;
    final meetingEndHour = json["MeetingEndHour"] as int?;
    final meetingEndMinute = json["MeetingEndMinute"] as int?;
    final facilityData = json["facility"];

    late final Facility? facility;

    if (facilityData != null) {
      final f = Facility.fromJson(json["facility"] as Map<String, dynamic>);

      if (f != null) {
        facility = f;
      }
    }

    return Position(
      id: id,
      employment: employment,
      ward: ward,
      facility: facility,
      meetingDay: meetingDay,
      meetingStartHour: meetingStartHour,
      meetingStartMinute: meetingStartMinute,
      meetingEndHour: meetingEndHour,
      meetingEndMinute: meetingEndMinute,
    );
  }
}
