// lib/services/product_service.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/productos.dart';
import 'api_service.dart';

class ProductService extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Listado> products = [];
  List<Listado> filteredProducts = [];
  bool isLoading = true;
  bool isEditCreate = true;

  // --- Producto “seleccionado” ---
  Listado? _selectedProduct;
  Listado get selectedProduct => _selectedProduct!;
  set selectedProduct(Listado prod) {
    _selectedProduct = prod;
    notifyListeners();
  }

  ProductService() {
    loadProducts();
  }

  /// Carga el listado desde el API
  Future<void> loadProducts() async {
    isLoading = true;
    notifyListeners();

    try {
      final data = await _apiService.get('ejemplos/product_list_rest/');
      final mapa = Product.fromJson(jsonEncode(data));
      products = mapa.listado;
      filteredProducts = List.from(products);
    } catch (e) {
      // Manejo de errores mejorado
      print('Error al cargar productos: ${e.toString()}');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Decide si crea o actualiza
  Future<void> editOrCreateProduct(Listado product) async {
    isEditCreate = true;
    notifyListeners();

    if (product.productId == 0) {
      await createProduct(product);
    } else {
      await updateProduct(product);
    }

    isEditCreate = false;
    notifyListeners();
  }

  /// Actualiza un producto existente
  Future<String> updateProduct(Listado product) async {
    try {
      // Convertir el producto a un mapa para enviarlo a la API
      Map<String, dynamic> productMap = {
        'product_id': product.productId,
        'product_name': product.productName,
        'product_price': product.productPrice,
        'product_image': product.productImage,
        'product_state': product.productState,
      };
      
      print('Enviando datos para actualizar producto: $productMap');
      final data = await _apiService.post('ejemplos/product_edit_rest/', productMap);
      print('Respuesta al actualizar producto: $data');
      
      // Manejar diferentes formatos de respuesta
      if (data is Map && data.containsKey('MSJ')) {
        print('Producto actualizado exitosamente: ${data['MSJ']}');
      }
      
      // Actualizar la lista local
      final idx = products.indexWhere((p) => p.productId == product.productId);
      if (idx >= 0) {
        products[idx] = product;
        // Actualizar también la lista filtrada
        final filteredIdx = filteredProducts.indexWhere((p) => p.productId == product.productId);
        if (filteredIdx >= 0) {
          filteredProducts[filteredIdx] = product;
        }
        notifyListeners();
      }
      
      return '';
    } catch (e) {
      print('Error al actualizar producto: ${e.toString()}');
      return e.toString();
    }
  }

  /// Crea un nuevo producto
  Future<String> createProduct(Listado product) async {
    try {
      // Convertir el producto a un mapa para enviarlo a la API
      Map<String, dynamic> productMap = {
        'product_name': product.productName,
        'product_price': product.productPrice,
        'product_image': product.productImage,
        'product_state': product.productState,
      };
      
      print('Enviando datos para crear producto: $productMap');
      final data = await _apiService.post('ejemplos/product_add_rest/', productMap);
      print('Respuesta al crear producto: $data');
      
      // Manejar diferentes formatos de respuesta
      if (data is Map) {
        int productId = 0;
        
        // Verificar si la respuesta contiene el ID del producto
        if (data.containsKey('product_id')) {
          productId = data['product_id'] as int? ?? 0;
        } else if (data.containsKey('productid')) {
          productId = data['productid'] as int? ?? 0;
        } else if (data.containsKey('MSJ')) {
          // Si solo contiene un mensaje de éxito
          print('Producto creado exitosamente: ${data['MSJ']}');
          // Recargar productos para obtener el nuevo ID
          await loadProducts();
          return '';
        }
        
        // Crear un nuevo producto con el ID asignado
        final newProduct = Listado(
          productId: productId,
          productName: product.productName,
          productPrice: product.productPrice,
          productImage: product.productImage,
          productState: product.productState,
        );
        
        // Solo agregar a la lista si tiene un ID válido
        if (productId > 0) {
          products.add(newProduct);
          filteredProducts = List.from(products);
          notifyListeners();
        } else {
          // Si no tiene ID, recargar la lista completa
          await loadProducts();
        }
        
        return '';
      } else {
        print('Formato de respuesta inesperado al crear producto: $data');
        // Recargar productos por si acaso se creó correctamente
        await loadProducts();
        return 'Formato de respuesta inesperado';
      }
    } catch (e) {
      print('Error al crear producto: ${e.toString()}');
      return e.toString();
    }
  }

  /// Borra un producto y recarga la lista
  Future<bool> deleteProduct(Listado product, BuildContext context) async {
    try {
      await _apiService.post('ejemplos/product_del_rest/', {'product_id': product.productId});
      await loadProducts();
      if (context.mounted) Navigator.of(context).pop();
      return true;
    } catch (e) {
      print('Error al borrar producto: ${e.toString()}');
      return false;
    }
  }

  /// Búsqueda para el SearchDelegate
  List<Listado> searchProducts(String query) {
    return products
        .where((p) => p.productName.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  /// Filtra en tiempo real (por ejemplo para un TextField)
  void filterProducts(String query) {
    if (query.isEmpty) {
      filteredProducts = List.from(products);
    } else {
      filteredProducts = products
          .where(
              (p) => p.productName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  // Getters útiles
  List<Listado> get allProducts => products;
  List<Listado> get filteredProductsList => filteredProducts;
}
