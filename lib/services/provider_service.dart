import '../models/provider.dart';
import 'api_service.dart';

class ProviderService {
  final ApiService _apiService = ApiService();

  Future<List<ProviderModel>> listProviders() async {
    try {
      final data = await _apiService.get('ejemplos/provider_list_rest/');
      print('Respuesta de proveedores: $data');
      
      if (data is List) {
        return data.map((m) => ProviderModel.fromMap(m)).toList();
      } else if (data is Map) {
        // Detectamos la clave correcta en la respuesta
        if (data.containsKey('Proveedores Listado')) {
          // La API está devolviendo 'Proveedores Listado' como clave
          return (data['Proveedores Listado'] as List).map((m) => ProviderModel.fromMap(m)).toList();
        } else if (data.containsKey('listado')) {
          // Si la respuesta es un mapa con una clave 'listado'
          return (data['listado'] as List).map((m) => ProviderModel.fromMap(m)).toList();
        }
      }
      
      print('Formato de respuesta inesperado para proveedores: $data');
      throw Exception('Formato de respuesta inesperado para proveedores');
    } catch (e) {
      print('Error detallado al cargar proveedores: $e');
      throw Exception('Error al cargar proveedores: ${e.toString()}');
    }
  }

  Future<ProviderModel> addProvider({
    required String name,
    required String lastName,
    required String mail,
    String state = 'Activo',
  }) async {
    try {
      final body = {
        'provider_name': name,
        'provider_last_name': lastName,
        'provider_mail': mail,
        'provider_state': state,
      };
      
      final data = await _apiService.post('ejemplos/provider_add_rest/', body);
      return ProviderModel.fromMap(data);
    } catch (e) {
      throw Exception('Error al agregar proveedor: ${e.toString()}');
    }
  }

  Future<ProviderModel> editProvider(ProviderModel prov) async {
    try {
      final body = {
        'provider_id': prov.id,
        'provider_name': prov.name,
        'provider_last_name': prov.lastName,
        'provider_mail': prov.mail,
        'provider_state': prov.state,
      };
      
      print('Enviando datos para editar proveedor: $body');
      final data = await _apiService.post('ejemplos/provider_edit_rest/', body);
      print('Respuesta al editar proveedor: $data');
      
      // La API solo devuelve un mensaje de éxito, no el proveedor actualizado
      // Devolvemos el mismo proveedor que recibimos como parámetro
      if (data is Map && data.containsKey('MSJ')) {
        print('Proveedor editado exitosamente: ${data['MSJ']}');
        return prov; // Devolvemos el mismo proveedor que enviamos
      } else if (data is Map<String, dynamic> && (data.containsKey('provider_id') || data.containsKey('providerid'))) {
        // Si por alguna razón la API devuelve el proveedor
        return ProviderModel.fromMap(data);
      } else if (data is Map) {
        // Intentamos extraer algún mensaje de error o éxito
        final message = data.toString();
        print('Respuesta no esperada pero procesable: $message');
        return prov; // Devolvemos el mismo proveedor que enviamos
      } else {
        print('Formato de respuesta inesperado al editar proveedor: $data');
        throw Exception('Formato de respuesta inesperado al editar proveedor');
      }
    } catch (e) {
      print('Error detallado al editar proveedor: $e');
      throw Exception('Error al editar proveedor: ${e.toString()}');
    }
  }

  Future<void> deleteProvider(int id) async {
    try {
      await _apiService.post('ejemplos/provider_del_rest/', {'provider_id': id});
    } catch (e) {
      throw Exception('Error al eliminar proveedor: ${e.toString()}');
    }
  }
}
