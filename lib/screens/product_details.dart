import 'package:flutter/material.dart';

import 'package:revee/models/product.dart';

import 'package:revee/utils/theme.dart';

import 'package:revee/widgets/appbar/revee_app_bar.dart';
import 'package:revee/widgets/product/product_attachments_list.dart';
import 'package:revee/widgets/product/product_images_carousel.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  const ProductDetailsScreen({Key? key, required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: ReveeAppBar(
        title: product.name,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: size.height * 0.025),
            child: LayoutBuilder(
              builder: (context, constraints) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ProductImagesCarousel(
                    maxWidth: constraints.maxWidth,
                    imagesUrls: product.imgsUrls,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                    child: Divider(
                      indent: size.width * 0.1,
                      endIndent: size.width * 0.1,
                      color: CustomColors.violaScuro,
                      thickness: 1,
                    ),
                  ),
                  ProductAttachmentsList(
                    documents: product.docs,
                    productName: product.name,
                    maxWidth: constraints.maxWidth,
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
