import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revee/providers/auth_provider.dart';
import 'package:revee/screens/expiring_doctors_screen.dart';
import 'package:revee/screens/login_screen.dart';
import 'package:revee/widgets/generic/revee_loader.dart';

import 'dart:developer' as dev;

class DynamicPage extends StatefulWidget {
  const DynamicPage({Key? key}) : super(key: key);

  @override
  _DynamicPageState createState() => _DynamicPageState();
}

class _DynamicPageState extends State<DynamicPage> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return FutureBuilder<bool>(
      future: authProvider.tryAutoLogin(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: ReveeBouncingLoader(),
            ),
          );
        } else {
          if (snapshot.error != null) {
            dev.log(snapshot.error.toString());
            return const Scaffold(
              body: Center(
                child: Text(
                  "Si è verificato un errore sconosciuto durante il controllo dell'autenticazione",
                ),
              ),
            );
          } else {
            return snapshot.data == true
                ? ExpiringDoctorsScreen()
                : LoginScreen();
          }
        }
      },
    );
  }
}
