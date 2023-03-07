import 'package:flutter/material.dart';

class ExpiryDaysCounter extends StatelessWidget {
  final int? expiryDays;
  final Color color;
  const ExpiryDaysCounter({
    Key? key,
    required this.expiryDays,
    this.color = Colors.red,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late final String badgeContent;

    if (expiryDays == null) {
      badgeContent = "MAI";
    } else if (expiryDays! < 0) {
      badgeContent = "MAI";
    } else {
      badgeContent = expiryDays.toString();
    }

    return CircleAvatar(
      backgroundColor: color,
      child: Text(
        badgeContent,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
