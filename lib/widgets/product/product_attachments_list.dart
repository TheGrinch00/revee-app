import 'package:flutter/material.dart';
import 'package:revee/models/product.dart';

import 'package:share_plus/share_plus.dart';

import 'package:revee/utils/theme.dart';

import 'package:revee/widgets/generic/animated_slide_opacity.dart';
import 'package:revee/widgets/product/attachment_tile.dart';

class ProductAttachmentsList extends StatelessWidget {
  final List<Document> documents;
  final String productName;
  final double maxWidth;

  const ProductAttachmentsList({
    Key? key,
    required this.productName,
    required this.documents,
    required this.maxWidth,
  }) : super(key: key);

  Widget generateSingleTile(int index, int cols) {
    final isPaddingNeeded = cols > 1;
    final remainder = index % cols;
    const spacing = 5.0;

    final double leftPadding = isPaddingNeeded
        ? remainder != 0
            ? spacing
            : 0
        : 0;

    final double rightPadding = isPaddingNeeded
        ? remainder != cols - 1
            ? spacing
            : 0
        : 0;

    return Flexible(
      child: Padding(
        padding: EdgeInsets.only(left: leftPadding, right: rightPadding),
        child: index < documents.length
            ? AnimatedSlideOpacity(
                key: Key(index.toString()),
                millisDelay: 100 * index,
                child: AttachmentTile(
                  document: documents[index],
                  productName: productName,
                ),
              )
            : const ListTile(),
      ),
    );
  }

  List<Widget> generateTiles() {
    final cols = (maxWidth ~/ 450) + 1;
    final rows = (documents.length / cols).ceil();

    return [
      for (int i = 0; i < rows; i++)
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int j = 0; j < cols; j++)
              generateSingleTile(i * cols + j, cols),
          ],
        ),
    ];
  }

  Future<void> shareAllAttachments() async {
    final StringBuffer sharedText = StringBuffer();

    sharedText
        .write("Ecco tutti i documenti relativi al prodotto '$productName':");
    sharedText.write("\n\n");

    for (int i = 0; i < documents.length; i++) {
      final current = documents[i];

      // Add each attachment to the body
      sharedText.write("${current.name}: ${current.url}\n");
    }

    await Share.share(
      sharedText.toString(),
      subject: "Revée - Documenti per '$productName'",
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Documenti",
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(color: CustomColors.violaScuro),
              ),
              if (documents.length > 1)
                TextButton(
                  onPressed: shareAllAttachments,
                  child: const Text("Condividi tutti"),
                ),
            ],
          ),
          const SizedBox(height: 10),
          if (documents.isNotEmpty)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: generateTiles(),
            ),
          if (documents.isEmpty)
            const Text("Non ci sono allegati per questo prodotto"),
        ],
      ),
    );
  }
}
