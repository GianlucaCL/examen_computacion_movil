import 'package:flutter/material.dart';
import '../models/provider.dart';
import '../services/provider_service.dart';

class ProviderProvider with ChangeNotifier {
  final ProviderService _service = ProviderService();

  List<ProviderModel> providers = [];
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  String _errorMessage = '';
  String get errorMessage => _errorMessage;
  
  bool _hasError = false;
  bool get hasError => _hasError;

  /// Carga la lista de proveedores
  Future<void> loadProviders() async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    notifyListeners();

    try {
      providers = await _service.listProviders();
    } catch (e) {
      _hasError = true;
      _errorMessage = 'Error al cargar los proveedores: ${e.toString()}';
      // Usar datos de respaldo o vacíos en caso de error
      providers = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Agrega un proveedor y refresca
  Future<bool> addProvider({
    required String name,
    required String lastName,
    required String mail,
    String state = 'Activo',
  }) async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    notifyListeners();
    
    try {
      await _service.addProvider(
        name: name,
        lastName: lastName,
        mail: mail,
        state: state,
      );
      await loadProviders();
      return true;
    } catch (e) {
      _hasError = true;
      _errorMessage = 'Error al agregar el proveedor: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Edita un proveedor existente y refresca
  Future<bool> updateProvider(ProviderModel prov) async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    notifyListeners();
    
    try {
      await _service.editProvider(prov);
      await loadProviders();
      return true;
    } catch (e) {
      _hasError = true;
      _errorMessage = 'Error al actualizar el proveedor: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Elimina un proveedor y refresca
  Future<bool> deleteProvider(int id) async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    notifyListeners();
    
    try {
      await _service.deleteProvider(id);
      await loadProviders();
      return true;
    } catch (e) {
      _hasError = true;
      _errorMessage = 'Error al eliminar el proveedor: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  /// Guarda un proveedor (crea o actualiza)
  Future<bool> saveProvider(ProviderModel provider) async {
    if (provider.id == 0) {
      return addProvider(
        name: provider.name,
        lastName: provider.lastName,
        mail: provider.mail,
        state: provider.state,
      );
    } else {
      return updateProvider(provider);
    }
  }
}
