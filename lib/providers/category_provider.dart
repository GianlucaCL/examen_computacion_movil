import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/category_service.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryService _service = CategoryService();

  bool _isLoading = true;
  bool _isSaving = false;
  List<Category> _categories = [];
  Category? _selectedCategory;

  // Getters
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  List<Category> get categories => _categories;
  Category get selectedCategory => _selectedCategory!;

  // Setters
  set selectedCategory(Category category) {
    _selectedCategory = category;
    notifyListeners();
  }

  CategoryProvider() {
    loadCategories();
  }

  Future<void> loadCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      _categories = await _service.listCategories();
      print('Categorías cargadas: ${_categories.length}');
    } catch (e) {
      print('Error al cargar categorías: $e');
      // Si hay error, usamos datos de prueba
      _categories = [
        Category(id: 1, name: 'Categoría 1', state: 'Activa'),
        Category(id: 2, name: 'Categoría 2', state: 'Activa'),
      ];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> saveCategory(Category category) async {
    _isSaving = true;
    notifyListeners();

    try {
      if (category.id == 0) {
        // Es una nueva categoría
        final newCategory = await _service.addCategory(category.name);
        _categories.add(newCategory);
      } else {
        // Actualizar categoría existente
        final updatedCategory = await _service.editCategory(category);
        final index = _categories.indexWhere((c) => c.id == category.id);
        if (index >= 0) _categories[index] = updatedCategory;
      }
      return true;
    } catch (e) {
      print('Error al guardar categoría: $e');
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> deleteCategory(int id) async {
    try {
      await _service.deleteCategory(id);
      _categories.removeWhere((c) => c.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      print('Error al eliminar categoría: $e');
      return false;
    }
  }
}
