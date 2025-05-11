// lib/screens/categories_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/category_provider.dart';
import '../routes/app_routes.dart';
import '../models/category.dart';

class CategoriesListScreen extends StatelessWidget {
  const CategoriesListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Creamos y disparamos la carga aquí
    return ChangeNotifierProvider<CategoryProvider>(
      create: (_) => CategoryProvider()..loadCategories(),
      child: const _CategoriesListView(),
    );
  }
}

class _CategoriesListView extends StatelessWidget {
  const _CategoriesListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<CategoryProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Listado de Categorías')),
      body: prov.isLoading
          ? const Center(child: CircularProgressIndicator())
          : prov.categories.isEmpty
              ? const Center(child: Text('No hay categorías'))
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: prov.categories.length,
                  itemBuilder: (context, i) {
                    final Category cat = prov.categories[i];
                    return Card(
                      child: ListTile(
                        title: Text(cat.name),
                        subtitle: Text('Estado: ${cat.state}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.categoryForm,
                                  arguments: cat,
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => prov.deleteCategory(cat.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.categoryForm);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
