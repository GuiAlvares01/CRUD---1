import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user.dart';

class ApiService {
  static const String baseUrl = "https://dummyjson.com/users";

  static Future<Map<String, dynamic>?> addUser(User user) async {
    final url = Uri.parse("$baseUrl/add");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "firstName": user.name, 
          "email": user.email,
          "login": user.login,
          "perfil": user.perfil,
          "empresa": user.empresa,
          "sistema": user.sistema,
          "expira": user.expira,
          "isChecked": user.isChecked,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        print("Erro: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("Erro na requisição: $e");
      return null;
    }
  }
}