import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/services/product_service.dart';

class ProductSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final productService = Provider.of<ProductService>(context, listen: false);
    final results = productService.products
        .where((p) => p.productName.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (_, i) {
        final product = results[i];
        return ListTile(
          title: Text(product.productName),
          subtitle: Text('\$${product.productPrice}'),
          onTap: () {
            // Aquí puedes navegar o agregar al carrito
            close(context, product);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final productService = Provider.of<ProductService>(context, listen: false);
    final suggestions = productService.products
        .where((p) => p.productName.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (_, i) {
        final product = suggestions[i];
        return ListTile(
          title: Text(product.productName),
          onTap: () {
            query = product.productName;
            showResults(context);
          },
        );
      },
    );
  }
}
