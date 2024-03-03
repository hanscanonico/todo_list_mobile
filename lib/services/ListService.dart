import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todo_list_mobile/functions.dart';

class ListService {
  final String baseUrl = 'https://task-tracker-api.fly.dev';

  Future<dynamic> _handleRequest(
      Future<http.Response> Function() requestFunction) async {
    var response = await requestFunction();

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      print(response.body);
      throw Exception('Failed to process request');
    }
  }

  Map<String, String> _getHeaders(String? token) {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<dynamic>> getLists() async {
    var response = await _handleRequest(() async => http.get(
          Uri.parse('$baseUrl/lists'),
          headers: _getHeaders(await getToken()),
        ));
    return List<dynamic>.from(response);
  }

  Future<dynamic> createList(Map<String, dynamic> listData) async {
    return _handleRequest(() async => http.post(
          Uri.parse('$baseUrl/lists'),
          headers: _getHeaders(await getToken()),
          body: json.encode(listData),
        ));
  }

  Future<dynamic> getList(int listId) async {
    return _handleRequest(() async => http.get(
          Uri.parse('$baseUrl/lists/$listId'),
          headers: _getHeaders(await getToken()),
        ));
  }

  Future<dynamic> updateList(int listId, Map<String, dynamic> listData) async {
    return _handleRequest(() async => http.patch(
          Uri.parse('$baseUrl/lists/$listId'),
          headers: _getHeaders(await getToken()),
          body: json.encode(listData),
        ));
  }

  Future<void> deleteList(int listId) async {
    await _handleRequest(() async => http.delete(
          Uri.parse('$baseUrl/lists/$listId'),
          headers: _getHeaders(await getToken()),
        ));
  }
}
