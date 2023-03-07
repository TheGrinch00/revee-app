import 'dart:developer' as dev;

import 'package:flutter/material.dart';

import 'package:revee/utils/theme.dart';
import 'package:revee/utils/custom_rect_tween.dart';

import 'package:revee/widgets/generic/password_field.dart';

class ChangePasswordContainer extends StatelessWidget {
  const ChangePasswordContainer({Key? key, required this.heroTag})
      : super(key: key);

  final String heroTag;

  @override
  Widget build(BuildContext context) {
    // Ugly hack but I don't know how to avoid overflows
    final isKeyBoardClosed =
        MediaQuery.of(context).viewInsets == EdgeInsets.zero;

    return SafeArea(
      child: Stack(
        children: [
          AnimatedAlign(
            alignment:
                isKeyBoardClosed ? Alignment.center : Alignment.topCenter,
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 200),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 16.0,
                    left: 16.0,
                    right: 16.0,
                  ),
                  child: Hero(
                    createRectTween: (begin, end) => CustomRectTween(
                      begin: begin!,
                      end: end!,
                    ),
                    tag: heroTag,
                    child: Material(
                      color: Colors.transparent,
                      child: SingleChildScrollView(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.only(
                            top: 20.0,
                            left: 20.0,
                            right: 20.0,
                            bottom: 10.0,
                          ),
                          child: const ChangePasswordForm(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({Key? key}) : super(key: key);

  @override
  _ChangePasswordFormState createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  bool _logoutFromDevices = true;

  late final _formKey = GlobalKey<FormState>();

  String? _currentPassword;
  String? _newPassword;
  String? _confirmPassword;

  final _newPasswordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  Future<void> submitForm() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) return;

    _formKey.currentState!.save();

    dev.log("Pass: $_currentPassword");
    dev.log("Nuova: $_newPassword");
    dev.log("Conferma: $_confirmPassword");
  }

  @override
  void dispose() {
    _newPasswordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Cambia Password",
            style: TextStyle(
              color: CustomColors.violaScuro,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 12),
          PasswordFormField(
            decoration: const InputDecoration(
              labelText: "Password attuale",
            ),
            onSaved: (val) => _currentPassword = val,
            validator: (val) => (val == null || val.isEmpty)
                ? "Questo campo è richiesto"
                : null,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => _newPasswordFocusNode.requestFocus(),
          ),
          const SizedBox(height: 8),
          PasswordFormField(
            decoration: const InputDecoration(
              labelText: "Nuova password",
            ),
            onSaved: (val) => _newPassword = val,
            validator: (val) => (val == null || val.isEmpty)
                ? "Questo campo è richiesto"
                : null,
            onChanged: (val) => _newPassword = val,
            textInputAction: TextInputAction.next,
            focusNode: _newPasswordFocusNode,
            onFieldSubmitted: (_) => _confirmPasswordFocusNode.requestFocus(),
          ),
          const SizedBox(height: 8),
          PasswordFormField(
            decoration: const InputDecoration(
              labelText: "Conferma password",
            ),
            onSaved: (val) => _confirmPassword = val,
            validator: (val) => (val == null || val.isEmpty)
                ? "Questo campo è richiesto"
                : val != _newPassword
                    ? "Le password non coincidono"
                    : null,
            textInputAction: TextInputAction.done,
            focusNode: _confirmPasswordFocusNode,
            onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Esci da tutti i dispositivi",
                style: TextStyle(
                  color: CustomColors.violaScuro,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Switch.adaptive(
                activeColor: Theme.of(context).primaryColor,
                value: _logoutFromDevices,
                onChanged: (newVal) {
                  setState(() {
                    _logoutFromDevices = newVal;
                  });
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: submitForm,
                child: const Text(
                  "Salva",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Annulla"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
