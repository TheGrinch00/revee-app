import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revee/providers/products_provider.dart';
import 'package:revee/widgets/appbar/revee_app_bar.dart';
import 'package:revee/widgets/drawer/app_drawer.dart';
import 'package:revee/widgets/generic/revee_loader.dart';
import 'package:revee/widgets/product/accordion_products.dart';

class ProductsAccordionPage extends StatelessWidget {
  static const String routeName = "/products";
  const ProductsAccordionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);

    return Scaffold(
      appBar: const ReveeAppBar(
        title: "Catalogo",
      ),
      drawer: AppDrawer(
        currentRoute: ProductsAccordionPage.routeName,
      ),
      body: SafeArea(
        top: false,
        child: FutureBuilder(
          future: productsProvider.fetchProducts(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: ReveeBouncingLoader(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }

            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: AccordionProducts(),
            );
          },
        ),
      ),
    );
  }
}
