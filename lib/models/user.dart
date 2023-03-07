class ReveeUser {
  String name;
  String surname;
  String phoneNumber;
  String email;
  DateTime birthDate;
  String profilePicture;
  bool privacyAccepted;
  int id;
  int? managerId;
  int? memberId;

  ReveeUser(
    this.name,
    this.surname,
    this.phoneNumber,
    this.email,
    this.birthDate,
    this.profilePicture,
    // ignore: avoid_positional_boolean_parameters
    this.privacyAccepted,
    this.id,
    this.managerId,
    this.memberId,
  );

  factory ReveeUser.fromJson(Map<String, dynamic> json) {
    try {
      return ReveeUser(
        json["MemberName"] as String? ?? "Errore",
        json["MemberSurname"] as String? ?? "Errore",
        json["MemberPhoneNumber"] as String? ?? "0000000000",
        json["email"] as String? ?? "Errore",
        json["MemberBirthdate"] != null
            ? DateTime.parse(json["MemberBirthdate"] as String)
            : DateTime.now(),
        json["MemberProfilePictureURL"] as String? ?? "",
        json["PrivacyAccepted"] as bool? ?? false,
        json["id"] as int? ?? -1,
        json["managerId"] as int?,
        json["memberId"] as int?,
      );
    } catch (e) {
      return ReveeUser(
        "Errore",
        "Errore",
        "0000000000",
        "Errore",
        DateTime.now(),
        "",
        false,
        -1,
        null,
        null,
      );
    }
  }
}
