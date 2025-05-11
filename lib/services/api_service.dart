import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static final ApiService _instance = ApiService._internal();
  
  factory ApiService() => _instance;
  
  ApiService._internal();
  
  final String baseUrl = "143.198.118.203:8100";
  final String user = "test";
  final String pass = "test2023";
  
  String get basicAuth {
    final creds = '$user:$pass';
    return 'Basic ${base64Encode(utf8.encode(creds))}';
  }
  
  // Método genérico para GET
  Future<dynamic> get(String endpoint) async {
    try {
      final uri = Uri.http(baseUrl, endpoint);
      final response = await http.get(
        uri,
        headers: {
          'authorization': basicAuth,
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));
      
      return _processResponse(response);
    } on SocketException {
      throw Exception('No hay conexión a internet');
    } on HttpException {
      throw Exception('No se encontró el servicio solicitado');
    } on FormatException {
      throw Exception('Formato de respuesta incorrecto');
    } catch (e) {
      throw Exception('Error desconocido: ${e.toString()}');
    }
  }
  
  // Método genérico para POST
  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final uri = Uri.http(baseUrl, endpoint);
      final response = await http.post(
        uri,
        headers: {
          'authorization': basicAuth,
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      ).timeout(const Duration(seconds: 10));
      
      return _processResponse(response);
    } on SocketException {
      throw Exception('No hay conexión a internet');
    } on HttpException {
      throw Exception('No se encontró el servicio solicitado');
    } on FormatException {
      throw Exception('Formato de respuesta incorrecto');
    } catch (e) {
      throw Exception('Error desconocido: ${e.toString()}');
    }
  }
  
  dynamic _processResponse(http.Response response) {
    print('API Response Status: ${response.statusCode}');
    print('API Response Body: ${response.body}');
    
    switch (response.statusCode) {
      case 200:
        try {
          final decoded = json.decode(response.body);
          return decoded;
        } catch (e) {
          print('Error decodificando respuesta: $e');
          print('Respuesta original: ${response.body}');
          throw Exception('Error al procesar la respuesta del servidor: $e');
        }
      case 400:
        throw Exception('Solicitud incorrecta: ${response.body}');
      case 401:
      case 403:
        throw Exception('No autorizado: ${response.body}');
      case 404:
        throw Exception('Recurso no encontrado: ${response.body}');
      case 500:
        throw Exception('Error interno del servidor: ${response.body}');
      default:
        throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }
}
