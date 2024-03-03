import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:todo_list_mobile/functions.dart';

const String baseUrl = 'https://task-tracker-api.fly.dev';
const FlutterSecureStorage _storage = FlutterSecureStorage();

class UserService {
  Future<dynamic> _handleRequest(
      Future<http.Response> Function() requestFunction) async {
    var response = await requestFunction();
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 204) {
      return response.body.isEmpty ? null : json.decode(response.body);
    } else {
      throw Exception(
          'Failed to process request with status: ${response.statusCode}');
    }
  }

  Map<String, String> _getHeaders({String? token}) {
    return {
      'Content-Type': 'application/json',
      'Authorization': token != null ? 'Bearer $token' : '',
    };
  }

  Future<dynamic> createUser(Map<String, dynamic> userData) async {
    return _handleRequest(() async => http.post(
          Uri.parse('$baseUrl/users'),
          headers: _getHeaders(),
          body: json.encode(userData),
        ));
  }

  Future<void> signIn(String email, String password) async {
    var response = await http.post(
      Uri.parse('$baseUrl/users/sign_in'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'user': {'email': email, 'password': password}
      }),
    );

    print('email: $email');
    print('password: $password'); // Be careful logging passwords
    print('response: ${response.body}');

    String? token = response.headers['authorization']?.split(' ').last;

    if (response.statusCode == 201 && token != null) {
      print('token: $token');
      await _storage.write(key: 'token', value: token);
    } else {
      throw Exception('Failed to sign in. Status code: ${response.statusCode}');
    }
  }

  Future<void> signOut() async {
    String? token = await getToken();
    await _handleRequest(() async => http.delete(
          Uri.parse('$baseUrl/users/sign_out'),
          headers: _getHeaders(token: token),
        ));
    await _storage.delete(key: 'token');
  }
}
