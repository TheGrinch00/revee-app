import 'dart:io';

import 'package:flutter/material.dart';
import 'package:revee/models/product.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:revee/utils/theme.dart';

class AttachmentTile extends StatelessWidget {
  final Document document;
  final String productName;

  const AttachmentTile({
    Key? key,
    required this.document,
    required this.productName,
  }) : super(key: key);

  Widget _generateTileAction(VoidCallback onTap, IconData icon) => Material(
        color: Colors.white,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: IconButton(
          onPressed: onTap,
          icon: Icon(icon),
          color: CustomColors.revee,
        ),
      );

  Future<void> tryLaunch(String url) async => await canLaunch(url)
      ? launch(url)
      : throw "C'è stato un errore aprendo un link";

  Future<void> shareAttachment(String url) async {
    final String sharedText =
        "Ecco il documento: '${document.name}' relativo al prodotto '$productName'\n\n${document.url}";

    await Share.share(
      sharedText,
      subject: "Revée - Documento per '$productName'",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsetsDirectional.only(start: 3),
      decoration: BoxDecoration(
        color: CustomColors.revee,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: ListTile(
          leading: const Icon(
            Icons.picture_as_pdf_outlined,
            color: CustomColors.violaScuro,
          ),
          title: Text(
            document.name,
            maxLines: 1,
            overflow: TextOverflow.fade,
            softWrap: false,
            style: const TextStyle(color: CustomColors.violaScuro),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _generateTileAction(
                () async => {await tryLaunch(document.url)},
                Icons.launch,
              ),
              _generateTileAction(
                () async => {await shareAttachment(document.url)},
                Platform.isIOS ? Icons.ios_share : Icons.share,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
