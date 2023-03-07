import 'package:flutter/material.dart';

import 'package:revee/models/product.dart';

import 'package:revee/providers/backend_connector.dart';
import 'package:revee/providers/feedback_provider.dart';

class ProductsProvider extends ChangeNotifier {
  late FeedbackProvider _feedback;
  late BackendConnector _backend;

  List<Product> _products = [];
  List<Product> get products => [..._products];

  Map<String, List<Product>> _productsGroupedByCategory = {};
  Map<String, List<Product>> get productsGroupedByCategory =>
      Map.from(_productsGroupedByCategory);

  void update(BackendConnector backend, FeedbackProvider feedback) {
    _backend = backend;
    _feedback = feedback;
    notifyListeners();
  }

  Future<void> fetchProducts(BuildContext ctx) async {
    try {
      final body = await _backend.getResource<List>(
        'products',
        filters: ["[include]=attachments", "[include]=productCategory"],
      );

      final List<Product> tempProds = [];

      for (final productData in body) {
        tempProds.add(Product.fromJson(productData as Map<String, dynamic>));
      }

      _products = [...tempProds];

      // Group products by category
      final Map<String, List<Product>> groupedProducts = {};
      for (final product in _products) {
        if (groupedProducts.containsKey(product.categoryName)) {
          groupedProducts[product.categoryName]!.add(product);
        } else {
          groupedProducts[product.categoryName] = [product];
        }
      }

      _productsGroupedByCategory = {...groupedProducts};

      notifyListeners();
    } catch (error) {
      _feedback.showFailFeedback(ctx, error.toString());
    }
  }

  Future<List<Product>?> fetchProductsCreateVisit(BuildContext ctx) async {
    try {
      final body = await _backend.getResource<List>(
        'products',
        filters: ["[include]=attachments", "[include]=productCategory"],
      );

      final List<Product> tempProds = [];

      for (final productData in body) {
        tempProds.add(Product.fromJson(productData as Map<String, dynamic>));
      }

      _products = [...tempProds];

      notifyListeners();

      return products;
    } catch (error) {
      _feedback.showFailFeedback(ctx, error.toString());
    }
    return null;
  }
}
