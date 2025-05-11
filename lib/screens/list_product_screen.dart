import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/product_card.dart';
import '../screens/search_delegate.dart';
import '../routes/app_routes.dart';
import '../models/productos.dart';

class ListProductScreen extends StatelessWidget {
  const ListProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProductProvider>(
      create: (_) => ProductProvider()..loadProducts(),
      child: _ListProductView(),
    );
  }
}

class _ListProductView extends StatelessWidget {
  const _ListProductView({Key? key}) : super(key: key);
  
  // Método para confirmar la eliminación de un producto
  void _confirmDelete(BuildContext context, ProductProvider provider, Listado product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Estás seguro de eliminar "${product.productName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await provider.deleteProduct(product.productId);
              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Producto eliminado correctamente')),
                );
              } else if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Error al eliminar el producto')),
                );
              }
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    
    if (productProvider.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Listado de productos')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    
    final products = productProvider.products;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Listado de productos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ProductSearchDelegate(),
              );
            },
          ),
          Consumer<CartProvider>(
            builder: (_, cart, __) => Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.cart);
                  },
                ),
                if (cart.itemCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '${cart.itemCount}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (_, i) {
          final prod = products[i];
          return GestureDetector(
            onTap: () {
              // Navegamos a detalle
              Navigator.pushNamed(
                context,
                AppRoutes.productDetail,
                arguments: prod,
              );
            },
            child: ProductCard(
              product: prod,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Botón de editar
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      productProvider.selectedProduct = prod;
                      Navigator.pushNamed(
                        context,
                        AppRoutes.productForm,
                        arguments: prod,
                      );
                    },
                  ),
                  // Botón de eliminar
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _confirmDelete(context, productProvider, prod),
                  ),
                  // Botón de agregar al carrito
                  IconButton(
                    icon: const Icon(Icons.add_shopping_cart, color: Colors.green),
                    onPressed: () {
                      Provider.of<CartProvider>(context, listen: false)
                          .addItem(prod);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Producto agregado al carrito')),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar a la pantalla de agregar nuevo producto
          Navigator.pushNamed(context, AppRoutes.productForm);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
