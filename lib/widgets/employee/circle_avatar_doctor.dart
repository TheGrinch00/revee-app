import 'package:flutter/material.dart';

class CircleAvatarDoctor extends StatelessWidget {
  final String? photoUrl;

  const CircleAvatarDoctor({required this.photoUrl});

  @override
  Widget build(BuildContext context) {
    if (photoUrl == "" || photoUrl == null) {
      return const CircleAvatar(
        backgroundImage: AssetImage('assets/icons/DoctorIcon.png'),
      );
    } else {
      return const CircleAvatar(
        backgroundImage: NetworkImage(
          "https://pbs.twimg.com/profile_images/1304985167476523008/QNHrwL2q_400x400.jpg",
        ),
      );
    }
  }
}
