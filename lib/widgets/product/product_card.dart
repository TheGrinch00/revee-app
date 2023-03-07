import 'package:flutter/material.dart';

import 'package:revee/models/product.dart';
import 'package:revee/screens/product_details.dart';

import 'package:revee/utils/theme.dart';

import 'package:revee/widgets/generic/revee_loader.dart';

class ProductCard extends StatelessWidget {
  final double labelHeight;
  final Product prod;
  final bool isChosen;
  final bool hideLabel;

  const ProductCard({
    Key? key,
    required this.prod,
    required this.labelHeight,
    this.isChosen = false,
    this.hideLabel = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const placeholderImgUrl =
        "https://via.placeholder.com/500.webp/FFFFFF/E20074?text=Revée+S.R.L.";
    return SizedBox(
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 3,
        shadowColor: CustomColors.violaScuro,
        child: InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ProductDetailsScreen(
                product: prod,
              ),
            ),
          ),
          child: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Image.network(
                  prod.imgsUrls.isEmpty ? placeholderImgUrl : prod.imgsUrls[0],
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) =>
                      loadingProgress == null
                          ? child
                          : Center(
                              child: ReveeBouncingLoader(),
                            ),
                ),
              ),
              if (isChosen)
                Align(
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Container(
                      color: Theme.of(context).primaryColor.withOpacity(0.8),
                      child: const Center(
                        child: Icon(
                          Icons.check_circle_outline_outlined,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ),
              if (!hideLabel)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: labelHeight,
                    decoration: BoxDecoration(
                      color: CustomColors.violaScuro.withOpacity(0.8),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                          prod.name,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.headline6!.copyWith(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
