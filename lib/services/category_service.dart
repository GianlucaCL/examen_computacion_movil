import '../models/category.dart';
import 'api_service.dart';

class CategoryService {
  final ApiService _apiService = ApiService();

  Future<List<Category>> listCategories() async {
    try {
      final data = await _apiService.get('ejemplos/category_list_rest/');
      print('Respuesta de categorías: $data');
      
      if (data is List) {
        return data.map((m) => Category.fromMap(m)).toList();
      } else if (data is Map) {
        // Detectamos la clave correcta en la respuesta
        if (data.containsKey('Listado Categorias')) {
          // La API está devolviendo 'Listado Categorias' como clave
          return (data['Listado Categorias'] as List).map((m) => Category.fromMap(m)).toList();
        } else if (data.containsKey('Categorias Listado')) {
          // La API está devolviendo 'Categorias Listado' como clave
          return (data['Categorias Listado'] as List).map((m) => Category.fromMap(m)).toList();
        } else if (data.containsKey('listado')) {
          // Si la respuesta es un mapa con una clave 'listado'
          return (data['listado'] as List).map((m) => Category.fromMap(m)).toList();
        }
      }
      
      print('Formato de respuesta inesperado: $data');
      throw Exception('Formato de respuesta inesperado');
    } catch (e) {
      print('Error detallado al cargar categorías: $e');
      throw Exception('Error al cargar categorías: ${e.toString()}');
    }
  }

  Future<Category> addCategory(String name, {String state = 'Activa'}) async {
    try {
      final body = {
        'category_name': name,
        'category_state': state
      };
      print('Enviando datos para agregar categoría: $body');
      final data = await _apiService.post('ejemplos/category_add_rest/', body);
      print('Respuesta al agregar categoría: $data');
      
      // La API puede devolver un mensaje de éxito o la categoría creada
      if (data is Map && data.containsKey('MSJ')) {
        print('Categoría agregada exitosamente: ${data['MSJ']}');
        // Crear una categoría con ID temporal (se actualizará al recargar)
        return Category(id: 0, name: name, state: state);
      } else if (data is Map && data.containsKey('category_id')) {
        // Si la API devuelve la categoría creada
        if (data is Map<String, dynamic>) {
          return Category.fromMap(data);
        } else {
          // Convertir Map<dynamic, dynamic> a Map<String, dynamic>
          final Map<String, dynamic> convertedMap = {};
          data.forEach((key, value) {
            if (key is String) {
              convertedMap[key] = value;
            }
          });
          return Category.fromMap(convertedMap);
        }
      } else if (data is Map) {
        // Intentamos extraer algún mensaje o ID
        print('Respuesta no esperada pero procesable: $data');
        return Category(id: 0, name: name, state: state);
      } else {
        print('Formato de respuesta inesperado al agregar: $data');
        throw Exception('Formato de respuesta inesperado al agregar categoría');
      }
    } catch (e) {
      print('Error detallado al agregar categoría: $e');
      throw Exception('Error al agregar categoría: ${e.toString()}');
    }
  }

  Future<Category> editCategory(Category category) async {
    try {
      final body = {
        'category_id': category.id,
        'category_name': category.name,
        'category_state': category.state,
      };
      print('Enviando datos para editar categoría: $body');
      final data = await _apiService.post('ejemplos/category_edit_rest/', body);
      print('Respuesta al editar categoría: $data');
      
      // La API solo devuelve un mensaje de éxito, no la categoría actualizada
      // Devolvemos la misma categoría que recibimos como parámetro
      if (data is Map && data.containsKey('MSJ')) {
        print('Categoría editada exitosamente: ${data['MSJ']}');
        return category; // Devolvemos la misma categoría que enviamos
      } else if (data is Map<String, dynamic> && data.containsKey('category_id')) {
        // Si por alguna razón la API devuelve la categoría
        return Category.fromMap(data);
      } else if (data is Map) {
        // Intentamos extraer algún mensaje de error o éxito
        final message = data.toString();
        print('Respuesta no esperada pero procesable: $message');
        return category; // Devolvemos la misma categoría que enviamos
      } else {
        print('Formato de respuesta inesperado al editar: $data');
        throw Exception('Formato de respuesta inesperado al editar');
      }
    } catch (e) {
      print('Error detallado al editar categoría: $e');
      throw Exception('Error al editar categoría: ${e.toString()}');
    }
  }

  Future<void> deleteCategory(int id) async {
    try {
      await _apiService.post('ejemplos/category_del_rest/', {'category_id': id});
    } catch (e) {
      throw Exception('Error al eliminar categoría: ${e.toString()}');
    }
  }
}
