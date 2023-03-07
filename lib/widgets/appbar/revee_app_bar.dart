import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:revee/utils/theme.dart';

class ReveeAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool automaticallyImplyLeading;
  final VoidCallback? onPopEffect;

  const ReveeAppBar({
    Key? key,
    required this.title,
    this.onPopEffect,
    this.automaticallyImplyLeading = true,
  }) : super(key: key);

  @override
  _ReveeAppBarState createState() => _ReveeAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(56);
}

class _ReveeAppBarState extends State<ReveeAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: CustomColors.violaScuro,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      automaticallyImplyLeading: widget.automaticallyImplyLeading,
      title: Text(
        widget.title,
        style: Theme.of(context).textTheme.headline5!.copyWith(
              color: Colors.white,
            ),
      ),
      leading: widget.automaticallyImplyLeading
          ? null
          : IconButton(
              icon: Icon(
                Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                widget.onPopEffect?.call();
                Navigator.of(context).pop();
              },
            ),
    );
  }
}
