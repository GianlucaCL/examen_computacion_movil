import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/productos.dart';

class CartProvider extends ChangeNotifier {
  final List<Listado> _items = [];
  List<Listado> get items => _items;
  int get itemCount => _items.length;

  void addItem(Listado product) {
    _items.add(product);
    notifyListeners();
  }

  void removeItem(Listado product) {
    _items.remove(product);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  int get totalPrice => _items.fold(0, (sum, item) => sum + item.productPrice);
}
