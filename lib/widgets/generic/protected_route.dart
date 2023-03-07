import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:revee/providers/auth_provider.dart';
import 'package:revee/widgets/generic/revee_loader.dart';

class ProtectedRoute extends StatefulWidget {
  final Widget successPage;
  final Widget rejectedPage;

  const ProtectedRoute({
    required this.successPage,
    required this.rejectedPage,
  });

  @override
  _ProtectedRouteState createState() => _ProtectedRouteState();
}

class _ProtectedRouteState extends State<ProtectedRoute> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return FutureBuilder<bool>(
      future: authProvider.isUserAuthorized(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: Colors.white,
            child: Center(
              child: ReveeBouncingLoader(),
            ),
          );
        }

        final bool? isAuthorized = snapshot.data;

        if (isAuthorized == null || !isAuthorized) {
          authProvider.logout();
          return widget.rejectedPage;
        }

        return widget.successPage;
      },
    );
  }
}
