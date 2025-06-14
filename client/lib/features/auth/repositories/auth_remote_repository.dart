import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthRemoteRepository {
  //Signup Function
  Future<Map<String, dynamic>> signup({
    required final name,
    required final email,
    required final password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );
      if (response.statusCode != 201) {
        throw 'Failed to signup';
      }
      final user = jsonDecode(response.body) as Map<String, dynamic>;
      return user;
    } catch (e) {
      throw e;
    }
  }

  //Login Function
  Future<void> login({required final email, required final password}) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      print(response.body);
      print(response.statusCode);
    } catch (e) {
      print(e);
    }
  }
}
