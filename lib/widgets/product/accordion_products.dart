import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:revee/models/product.dart';
import 'package:revee/providers/products_provider.dart';
import 'package:revee/providers/visit_create_edit_provider.dart';
import 'package:revee/widgets/generic/accordion.dart';
import 'package:revee/widgets/product/product_card.dart';

import 'package:revee/utils/extensions/list_extension.dart';

class AccordionProducts extends StatefulWidget {
  const AccordionProducts({
    Key? key,
    this.isCreatingVisit = false,
  }) : super(key: key);

  final bool isCreatingVisit;

  @override
  State<AccordionProducts> createState() => AccordionProductsState();
}

class AccordionProductsState extends State<AccordionProducts> {
  List<List<Product?>> getProductsByRow(
    List<Product> prods,
    int columnsCount,
  ) =>
      prods.fold([], (acc, prod) {
        if (acc.isEmpty) {
          return [
            [prod]
          ];
        }

        if (acc.last.length < columnsCount) {
          return [
            ...acc.sublist(0, acc.length - 1),
            [...acc.last, prod]
          ];
        }

        return [
          ...acc,
          [prod]
        ];
      });

  @override
  Widget build(BuildContext context) {
    return Consumer2<ProductsProvider, VisitCreateProvider>(
      builder: (ctx, productsProvider, visitCreateProvider, child) {
        final groupedProducts = productsProvider.productsGroupedByCategory;

        final categories = groupedProducts.keys.toList();

        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              categories.length,
              (index) {
                final categoryName = categories[index];
                final products = groupedProducts[categoryName] ?? [];

                return MuiAccordion(
                  key: ValueKey(categoryName),
                  title: Text(categoryName),
                  index: index,
                  totalElements: categories.length,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final columnsCount =
                              (constraints.maxWidth ~/ 300) + 2;

                          final productsByRow = getProductsByRow(
                            products,
                            columnsCount,
                          );
                          productsByRow.last = productsByRow.last.padRight(
                            columnsCount,
                            null,
                          );

                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: productsByRow
                                .map(
                                  (row) => Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: row
                                        .map(
                                          (prod) => Expanded(
                                            child: prod == null
                                                ? const SizedBox()
                                                : GestureDetector(
                                                    onTap: () =>
                                                        visitCreateProvider
                                                            .toggleProduct(
                                                      prod,
                                                    ),
                                                    child: AspectRatio(
                                                      // Just more readable
                                                      aspectRatio: 1.0 / 1.0,
                                                      child: AbsorbPointer(
                                                        absorbing: widget
                                                            .isCreatingVisit,
                                                        child: ProductCard(
                                                          prod: prod,
                                                          isChosen:
                                                              visitCreateProvider
                                                                  .selectedProducts
                                                                  .any(
                                                            (p) =>
                                                                prod.id == p.id,
                                                          ),
                                                          labelHeight: 30.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                )
                                .toList(),
                          );
                        },
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
