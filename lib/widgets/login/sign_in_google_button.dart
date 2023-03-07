import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:revee/providers/auth_provider.dart';

class SignInGoogleButton extends StatelessWidget {
  const SignInGoogleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(5);
    const googleColor = Color(0xFF397AF3);
    final authProvider = Provider.of<AuthProvider>(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: radius,
      ),
      child: InkWell(
        onTap: () => authProvider.loginWithGoogle(context),
        borderRadius: radius,
        splashColor: googleColor,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: radius,
            color: googleColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration:
                      BoxDecoration(color: Colors.white, borderRadius: radius),
                  width: 35,
                  child: Image.asset(
                    "assets/icons/google_logo.png",
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Entra con Google',
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(color: Colors.white),
                ),
                const SizedBox(width: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
