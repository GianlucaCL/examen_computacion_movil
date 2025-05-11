// lib/screens/product_detail_screen.dart

import 'package:flutter/material.dart';
import '../models/productos.dart';  // Ajusta según tu ruta

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Recibimos un Listado (no Product) desde los argumentos de la ruta
    print('ProductDetailScreen: Recibiendo argumentos...');
    
    // Validación segura de argumentos con logs para depuración
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args == null) {
      print('ERROR: ProductDetailScreen recibió argumentos NULL');
      return Scaffold(
        appBar: AppBar(title: const Text('Detalle de Producto')),
        body: const Center(
          child: Text(
            'No se recibió información del producto.\nVuelve a la lista e intenta de nuevo.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.red),
          ),
        ),
      );
    }
    
    if (args is! Listado) {
      print('ERROR: ProductDetailScreen recibió argumentos de tipo ${args.runtimeType}, no Listado');
      return Scaffold(
        appBar: AppBar(title: const Text('Detalle de Producto')),
        body: Center(
          child: Text(
            'Tipo de datos incorrecto: ${args.runtimeType}\nVuelve a la lista e intenta de nuevo.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, color: Colors.red),
          ),
        ),
      );
    }
    
    // Si llegamos aquí, args es seguro un Listado
    print('ProductDetailScreen: Argumentos correctos recibidos (tipo Listado)');
    final Listado producto = args; // No necesitamos cast, ya validamos el tipo

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de Producto')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Si hay URL de imagen, la mostramos
            if (producto.productImage.isNotEmpty)
              Center(
                child: Image.network(
                  producto.productImage,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),

            const SizedBox(height: 16),
            Text('ID: ${producto.productId}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Nombre: ${producto.productName}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 8),
            Text('Precio: \$${producto.productPrice}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Estado: ${producto.productState}',
                style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
