import 'package:flutter/material.dart';

import 'package:revee/models/doctor.dart';

import 'package:revee/utils/theme.dart';

import 'package:revee/widgets/employee/circle_avatar_doctor.dart';

class HeaderDoctorCard extends StatelessWidget {
  final Doctor doctor;

  const HeaderDoctorCard({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      child: Row(
        children: [
          CircleAvatarDoctor(photoUrl: doctor.photoURL),
          const SizedBox(
            height: 8,
            width: 8,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${doctor.name} ${doctor.surname}",
                style: Theme.of(context).textTheme.headline5!.copyWith(
                      color: CustomColors.revee,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                "Titolo",
                style: Theme.of(context).primaryTextTheme.subtitle1!.copyWith(
                      color: CustomColors.revee,
                    ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
