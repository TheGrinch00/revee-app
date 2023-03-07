import 'package:flutter/material.dart';

class PasswordFormField extends StatefulWidget {
  const PasswordFormField({
    Key? key,
    this.validator,
    this.onSaved,
    this.decoration = const InputDecoration(),
    this.onChanged,
    this.onFieldSubmitted,
    this.textInputAction,
    this.focusNode,
  }) : super(key: key);

  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final InputDecoration? decoration;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;

  @override
  _PasswordFormFieldState createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool _showPassword = false;
  Color iconColor = Colors.grey;

  // Logic to change icon color based on wether the field has focus or not
  late final FocusNode _fieldFocusNode = (widget.focusNode ?? FocusNode())
    ..addListener(() {
      if (iconColor == Colors.grey && _fieldFocusNode.hasFocus) {
        setState(() {
          iconColor = Theme.of(context).primaryColor;
        });
      } else if (iconColor == Theme.of(context).primaryColor &&
          !_fieldFocusNode.hasFocus) {
        setState(() {
          iconColor = Colors.grey;
        });
      }
    });

  @override
  void dispose() {
    if (widget.focusNode == null) _fieldFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        TextFormField(
          focusNode: _fieldFocusNode,
          obscureText: !_showPassword,
          validator: widget.validator,
          onSaved: widget.onSaved,
          decoration: widget.decoration,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onFieldSubmitted,
          textInputAction: widget.textInputAction,
        ),
        Positioned(
          top: 7,
          right: 5,
          child: IconButton(
            icon: Icon(
              _showPassword
                  ? Icons.remove_red_eye
                  : Icons.remove_red_eye_outlined,
              color: iconColor,
            ),
            onPressed: () {
              setState(() {
                // Change Icon
                _showPassword = !_showPassword;

                // Request focus for the field
                _fieldFocusNode.requestFocus();
              });
            },
          ),
        ),
      ],
    );
  }
}
