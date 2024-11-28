import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://localhost:3001';


  // Método para enviar el formulario de estudio socioeconómico
  Future<void> submitFormularioEstudio(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/estudio_socioeconomico'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al guardar el formulario');
    }
  }

  // Método para registrar un usuario
  Future<void> registerUser (Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al registrar el usuario');
    }
  }

  // Método para iniciar sesión
  Future<Map<String, dynamic>> loginUser (Map<String, dynamic> loginData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(loginData),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al iniciar sesión');
    }

    return jsonDecode(response.body); // Devuelve los datos del usuario
  }

  // Método para enviar un vale de entrada
  Future<void> submitValeEntrada(Map<String, dynamic> valeData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/entradavales'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(valeData),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al guardar el vale de entrada');
    }
  }

  // Método para enviar un vale de salida
  Future<void> submitValeSalida(Map<String, dynamic> valeData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/registro_vales'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(valeData),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al guardar el vale de salida');
    }
  }

  // Método para obtener todos los vales
  Future<List<dynamic>> getVales() async {
    final response = await http.get(Uri.parse('$baseUrl/registro_vales'));

    if (response.statusCode != 200) {
      throw Exception('Error al obtener los vales');
    }

    return jsonDecode(response.body); // Devuelve la lista de vales
  }

  // Método para registrar despensas
  Future<void> submitRegistroDespensas(Map<String, dynamic> despensaData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/registro-despensas'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(despensaData),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al registrar las despensas');
    }
  }

  // Método para obtener despensas
  Future<List<dynamic>> getDespensas() async {
    final response = await http.get(Uri.parse('$baseUrl/despensas/sin-ruta'));

    if (response.statusCode != 200) {
      throw Exception('Error al obtener las despensas');
    }

    return jsonDecode(response.body); // Devuelve la lista de despensas
  }
}