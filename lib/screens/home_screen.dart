import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../routes/app_routes.dart';
import '../providers/category_provider.dart';
import '../providers/product_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Inicio'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.category), text: 'Categorías'),
              Tab(icon: Icon(Icons.inventory), text: 'Productos'),
            ],
          ),
        ),
        drawer: Drawer(
          child: Column(
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.deepPurple),
                child: Center(
                  child: Icon(
                    Icons.shopping_bag,
                    size: 64,
                    color: Colors.white,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.inventory),
                title: const Text('Productos'),
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.products);
                },
              ),
              ListTile(
                leading: const Icon(Icons.category),
                title: const Text('Categorías'),
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.categories);
                },
              ),
              ListTile(
                leading: const Icon(Icons.people),
                title: const Text('Proveedores'),
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.providers);
                },
              ),
              const Spacer(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Cerrar sesión'),
                onTap: () {
                  // Si tienes lógica de logout, llámala aquí.
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                },
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ChangeNotifierProvider<CategoryProvider>(
              create: (_) => CategoryProvider()..loadCategories(),
              child: const _CategoriesTab(),
            ),
            ChangeNotifierProvider<ProductProvider>(
              create: (_) => ProductProvider()..loadProducts(),
              child: const _ProductsTab(),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navegar a la pantalla de agregar nuevo producto
            Navigator.pushNamed(context, AppRoutes.productForm);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class _CategoriesTab extends StatelessWidget {
  const _CategoriesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<CategoryProvider>();

    return categoryProvider.isLoading
        ? const Center(child: CircularProgressIndicator())
        : categoryProvider.categories.isEmpty
            ? const Center(child: Text('No hay categorías'))
            : ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: categoryProvider.categories.length,
                itemBuilder: (context, index) {
                  final category = categoryProvider.categories[index];
                  return Card(
                    child: ListTile(
                      title: Text(category.name),
                      subtitle: Text('Estado: ${category.state}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.categoryForm,
                                arguments: category,
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => categoryProvider.deleteCategory(category.id),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
  }
}

class _ProductsTab extends StatelessWidget {
  const _ProductsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();

    return productProvider.isLoading
        ? const Center(child: CircularProgressIndicator())
        : productProvider.products.isEmpty
            ? const Center(child: Text('No hay productos'))
            : ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: productProvider.products.length,
                itemBuilder: (context, index) {
                  final product = productProvider.products[index];
                  return Card(
                    child: ListTile(
                      title: Text(product.productName),
                      subtitle: Text('Precio: \$${product.productPrice.toStringAsFixed(2)}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.shopping_cart),
                        onPressed: () {
                          // Agregar lógica para agregar al carrito
                        },
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.productDetail,
                          arguments: product,
                        );
                      },
                    ),
                  );
                },
              );
  }
}
