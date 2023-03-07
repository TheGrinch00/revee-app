import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoResults extends StatelessWidget {
  final String? displayText;

  const NoResults({Key? key, this.displayText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Lottie.asset(
          "assets/animations/lottie_no_results.json",
        ),
        if(displayText != null)
        Text(displayText!),
      ],
    );
  }
}
