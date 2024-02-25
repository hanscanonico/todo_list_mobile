import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const String baseUrl = 'https://task-tracker-api.fly.dev';
const FlutterSecureStorage _storage = FlutterSecureStorage();

class UserService {
  Future<dynamic> createUser(Map<String, dynamic> userData) async {
    var response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(userData),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create user');
    }
  }

  Future<void> signIn(String email, String password) async {
    var response = await http.post(
      Uri.parse('$baseUrl/users/sign_in'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'user': {'email': email, 'password': password}
      }),
    );

    print('email : ${email}');
    print('password : ${password}');
    print('response : ${response}');
    String? token = response.headers['authorization']?.split(' ').last;

    print('response.statusCode : ${response.statusCode}');
    print('response.body : ${response.body}');
    if (response.statusCode == 201 && token != null) {
      print('token : ${token}');

      await _storage.write(key: 'token', value: token);
    } else {
      throw Exception('Failed to sign in');
    }
  }
}
