import 'package:flutter/material.dart';

class LightBoxShadow extends StatelessWidget {
  const LightBoxShadow({Key? key, required this.child})
      : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 5,
          )
        ],
      ),
      child: child,
    );
  }
}
