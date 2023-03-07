import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:revee/providers/auth_provider.dart';
import 'package:revee/providers/feedback_provider.dart';
import 'package:revee/screens/expiring_doctors_screen.dart';

class OTPCodeStep extends StatefulWidget {
  const OTPCodeStep({Key? key}) : super(key: key);

  @override
  _OTPCodeStepState createState() => _OTPCodeStepState();
}

class _OTPCodeStepState extends State<OTPCodeStep> {
  final TextEditingController otpCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final feedbackProvider =
        Provider.of<FeedbackProvider>(context, listen: false);

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Consumer<AuthProvider>(
          builder: (context, auth, _) => RichText(
            text: TextSpan(
              text:
                  'Al fine di mantenere il tuo account sicuro, è stato inviato un codice di verifica al numero ',
              children: [
                TextSpan(
                  text:
                      "*******${auth.phoneNumber.substring(auth.phoneNumber.length - 3)}",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
              style: Theme.of(context).textTheme.headline6!.copyWith(),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 25),
        TextField(
          controller: otpCodeController,
          decoration: const InputDecoration(
            hintText: 'Codice di verifica',
            border: OutlineInputBorder(),
            isDense: false,
          ),
          keyboardType: TextInputType.number,
          autofocus: true,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          maxLength: 6,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            if (otpCodeController.text.isEmpty) {
              feedbackProvider.showFailFeedback(
                context,
                "Inserisci il codice OTP",
              );
            } else if (otpCodeController.text.length != 6) {
              feedbackProvider.showFailFeedback(
                context,
                "Il codice OTP deve essere di 6 cifre",
              );
            } else {
              authProvider.verifyCode(otpCodeController.text).then((success) {
                if (success) {
                  Navigator.of(context)
                      .pushReplacementNamed(ExpiringDoctorsScreen.routeName);
                }
              });
            }
          },
          child: const Text('Accedi'),
        ),
      ],
    );
  }
}
