import 'package:flutter/material.dart';

import 'package:revee/utils/theme.dart';

class DrawerProfileAvatar extends StatelessWidget {
  final String? pictureUrl;
  final String initials;

  const DrawerProfileAvatar({this.pictureUrl, required this.initials});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      child: pictureUrl != null
          ? Image.network(pictureUrl!)
          : Text(
              initials,
              style: const TextStyle(
                color: CustomColors.grigioScuro,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}
