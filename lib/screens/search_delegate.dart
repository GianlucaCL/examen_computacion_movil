// lib/screens/search_delegate.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// tu modelo: Product + Listado
import '../providers/product_provider.dart'; // Provider que expone List<Listado> products
import '../routes/app_routes.dart'; // tus rutas nombradas

class ProductSearchDelegate extends SearchDelegate<void> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) {
            close(context, null); // cierra el buscador
          } else {
            query = '';
            showSuggestions(context); // limpia y vuelve a sugerencias
          }
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null), // cierra el buscador
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context, listen: false);
    final suggestions = provider.products.where((p) {
      return p.productName.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final producto = suggestions[index];
        return ListTile(
          title: Text(producto.productName),
          onTap: () {
            query = producto.productName;
            showResults(context); // muestra buildResults
          },
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context, listen: false);
    final results = provider.products.where((p) {
      return p.productName.toLowerCase().contains(query.toLowerCase());
    }).toList();

    if (results.isEmpty) {
      return Center(child: Text('No se encontraron productos para "$query"'));
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final producto = results[index];
        return ListTile(
          leading: producto.productImage.isNotEmpty
              ? Image.network(
                  producto.productImage,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )
              : const SizedBox(width: 50, height: 50),
          title: Text(producto.productName),
          subtitle: Text('\$${producto.productPrice}'),
          onTap: () {
            close(context, null); // cierra el buscador
            Navigator.pushNamed(
              context,
              AppRoutes.productDetail,
              arguments: producto, // pasamos el Listado
            );
          },
        );
      },
    );
  }
}
