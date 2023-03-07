import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:revee/widgets/generic/hero_dialog_route.dart';
import 'package:revee/widgets/generic/revee_loader.dart';

import 'package:revee/utils/theme.dart';

class ProductImagesCarousel extends StatelessWidget {
  final List<String> imagesUrls;
  final double maxWidth;

  const ProductImagesCarousel({
    Key? key,
    required this.imagesUrls,
    required this.maxWidth,
  }) : super(key: key);

  double evaluateViewportFraction() {
    return maxWidth <= 430
        ? 0.8
        : maxWidth <= 1200
            ? 0.6
            : 0.3;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Galleria",
          style: Theme.of(context)
              .textTheme
              .headline3!
              .copyWith(color: CustomColors.violaScuro),
        ),
        const SizedBox(height: 10),
        CarouselSlider(
          items: [
            for (var i = 0; i < imagesUrls.length; i++)
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    HeroDialogRoute(
                      isDismissable: true,
                      builder: (context) => Hero(
                        tag: imagesUrls[i],
                        child: Center(
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: CustomColors.violaScuro,
                                width: 2,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: InteractiveViewer(
                                child: Image.network(
                                  imagesUrls[i],
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, loadingProgress) =>
                                          loadingProgress == null
                                              ? child
                                              : Center(
                                                  child: ReveeBouncingLoader(),
                                                ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                child: Hero(
                  tag: imagesUrls[i],
                  child: Container(
                    key: Key("$i"),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: CustomColors.violaScuro,
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        imagesUrls[i],
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) =>
                            loadingProgress == null
                                ? child
                                : Center(
                                    child: ReveeBouncingLoader(),
                                  ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
          options: CarouselOptions(
            enableInfiniteScroll: false,
            enlargeCenterPage: true,
            viewportFraction: evaluateViewportFraction(),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
