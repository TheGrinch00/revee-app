import 'package:flutter/material.dart';

import 'package:revee/models/doctor.dart';

import 'package:revee/widgets/appbar/revee_app_bar.dart';

class ModifyDoctorScreen extends StatefulWidget {
  final Doctor doctor;

  const ModifyDoctorScreen({
    Key? key,
    required this.doctor,
  }) : super(key: key);

  @override
  _ModifyDoctorScreenState createState() => _ModifyDoctorScreenState();
}

class _ModifyDoctorScreenState extends State<ModifyDoctorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReveeAppBar(
        title: "Modifica ${widget.doctor.surname} ${widget.doctor.name}",
      ),
      body: Container(),
    );
  }
}
