import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/productos.dart';

class ProductProvider extends ChangeNotifier {
  final String _baseUrl = "143.198.118.203:8100";
  final String _user = "test";
  final String _pass = "test2023";
  
  List<Listado> _products = [];
  bool _isLoading = false;
  bool _isSaving = false;

  List<Listado> get products => _products;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;

  // Producto seleccionado para editar
  Listado? _selectedProduct;
  Listado get selectedProduct => _selectedProduct!;
  set selectedProduct(Listado product) {
    _selectedProduct = product;
    notifyListeners();
  }

  ProductProvider() {
    loadProducts();
  }

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final url = Uri.http(_baseUrl, 'ejemplos/product_list_rest/');
      final basicAuth = 'Basic ${base64Encode(utf8.encode('$_user:$_pass'))}';
      final resp = await http.get(url, headers: {'authorization': basicAuth});

      if (resp.statusCode == 200) {
        final mapa = Product.fromJson(resp.body);
        _products = mapa.listado;
        print('Productos cargados: ${_products.length}');
      } else {
        print('Error ${resp.statusCode} al cargar productos');
        // Si hay error, usamos datos de prueba
        _products = [
          Listado(productId: 1, productName: 'Producto 1', productPrice: 10, productImage: '', productState: 'Activo'),
          Listado(productId: 2, productName: 'Producto 2', productPrice: 15, productImage: '', productState: 'Activo'),
        ];
      }
    } catch (e) {
      print('Error al cargar productos: $e');
      // Si hay excepción, usamos datos de prueba
      _products = [
        Listado(productId: 1, productName: 'Producto 1', productPrice: 10, productImage: '', productState: 'Activo'),
        Listado(productId: 2, productName: 'Producto 2', productPrice: 15, productImage: '', productState: 'Activo'),
      ];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<bool> saveProduct(Listado product) async {
    _isSaving = true;
    notifyListeners();
    
    try {
      // Preparar la URL y el cuerpo de la solicitud
      final url = product.productId == 0
          ? Uri.http(_baseUrl, 'ejemplos/product_add_rest/')
          : Uri.http(_baseUrl, 'ejemplos/product_edit_rest/');
      
      // Preparar el mapa de datos correcto (no usar toJson que codifica dos veces)
      final Map<String, dynamic> productMap = product.toMap();
      
      print('Enviando producto: $productMap a ${url.toString()}');
      
      final basicAuth = 'Basic ${base64Encode(utf8.encode('$_user:$_pass'))}';
      final resp = await http.post(
        url,
        body: jsonEncode(productMap),
        headers: {
          'authorization': basicAuth,
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      print('Respuesta: ${resp.statusCode} - ${resp.body}');

      if (resp.statusCode == 200) {
        // Intentar analizar la respuesta
        final responseData = jsonDecode(resp.body);
        print('Respuesta decodificada: $responseData');
        
        if (product.productId == 0) {
          // Es un nuevo producto
          // Intentar obtener el ID asignado por el servidor
          int newId = 0;
          if (responseData is Map) {
            if (responseData.containsKey('product_id')) {
              newId = responseData['product_id'] as int? ?? 0;
            } else if (responseData.containsKey('productid')) {
              newId = responseData['productid'] as int? ?? 0;
            }
          }
          
          if (newId > 0) {
            // Si tenemos un ID válido, actualizar el producto
            product.productId = newId;
          } else {
            // Si no hay ID, usar uno temporal y recargar
            product.productId = DateTime.now().millisecondsSinceEpoch;
            // Recargar la lista después para obtener el ID real
            Future.delayed(Duration(milliseconds: 500), () => loadProducts());
          }
          
          _products.add(product);
        } else {
          // Actualizar producto existente
          final index = _products.indexWhere((p) => p.productId == product.productId);
          if (index >= 0) _products[index] = product;
        }
        return true;
      } else {
        print('Error ${resp.statusCode} al guardar producto: ${resp.body}');
        return false;
      }
    } catch (e) {
      print('Error al guardar producto: $e');
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> deleteProduct(int id) async {
    try {
      final url = Uri.http(_baseUrl, 'ejemplos/product_del_rest/');
      final basicAuth = 'Basic ${base64Encode(utf8.encode('$_user:$_pass'))}';
      
      final resp = await http.post(
        url,
        body: jsonEncode({"product_id": id}),
        headers: {
          'authorization': basicAuth,
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (resp.statusCode == 200) {
        _products.removeWhere((p) => p.productId == id);
        notifyListeners();
        return true;
      } else {
        print('Error ${resp.statusCode} al eliminar producto');
        return false;
      }
    } catch (e) {
      print('Error al eliminar producto: $e');
      return false;
    }
  }
}
