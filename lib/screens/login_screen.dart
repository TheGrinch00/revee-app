import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revee/providers/auth_provider.dart';
import 'package:revee/widgets/login/otp_code_step.dart';

import 'package:revee/widgets/login/sign_in_google_button.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = "/login";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Container(
            margin: const EdgeInsets.all(10),
            alignment: Alignment.center,
            child: Consumer<AuthProvider>(
              builder: (context, auth, _) => Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 60, bottom: 30),
                    child: LimitedBox(
                      maxHeight: MediaQuery.of(context).size.height * 0.25,
                      maxWidth: MediaQuery.of(context).size.width * 0.60,
                      child: Image.asset(
                        'assets/images/login-logo.png',
                      ),
                    ),
                  ),
                  const Expanded(
                    child: SizedBox(),
                  ),
                  if (auth.authStatus == AuthStatus.LOGGED_OUT)
                    const SignInGoogleButton()
                  else if (auth.authStatus == AuthStatus.VERIFYING_CODE)
                    const OTPCodeStep(),
                  const Expanded(
                    flex: 2,
                    child: SizedBox(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
