import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revee/providers/auth_provider.dart';

import 'package:revee/utils/theme.dart';

import 'package:revee/widgets/drawer/drawer_profile_avatar.dart';

class AppDrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = Provider.of<AuthProvider>(context, listen: false).user!;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 30,
        vertical: size.height * 0.02,
      ),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Row(
        children: [
          DrawerProfileAvatar(
            initials:
                "${user.name.substring(0, 1)}${user.surname.substring(0, 1)}",
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${user.name} ${user.surname}",
                overflow: TextOverflow.fade,
                softWrap: false,
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      color: CustomColors.revee,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                user.email,
                overflow: TextOverflow.fade,
                softWrap: false,
                style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      color: Colors.white,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
