import 'package:flutter/material.dart';

import 'package:revee/utils/theme.dart';

import 'package:revee/screens/profile_screen.dart';

class DrawerListTile extends StatelessWidget {
  final Icon icon;
  final String pageName;
  final String routeName;
  final bool isSelected;

  const DrawerListTile({
    required this.icon,
    required this.pageName,
    required this.routeName,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.05,
      ),
      decoration: BoxDecoration(
        color: isSelected ? CustomColors.revee.withAlpha(30) : Colors.white,
        borderRadius: BorderRadius.circular(50),
      ),
      child: ListTile(
        dense: true,
        selected: isSelected,
        leading: icon,
        title: Text(pageName),
        onTap: isSelected
            ? null
            : routeName == ProfileScreen.routeName
                ? () => Navigator.of(context).pushNamed(routeName)
                : () => Navigator.of(context).pushReplacementNamed(routeName),
      ),
    );
  }
}
