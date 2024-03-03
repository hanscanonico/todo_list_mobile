import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todo_list_mobile/functions.dart';

class TaskService {
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

  Future<List<dynamic>> getTasks(int listId) async {
    var response = await _handleRequest(() async => http.get(
          Uri.parse('$baseUrl/lists/$listId/tasks'),
          headers: _getHeaders(await getToken()),
        ));
    return List<dynamic>.from(response);
  }

  Future<dynamic> createTask(int listId, Map<String, dynamic> taskData) async {
    return _handleRequest(() async => http.post(
          Uri.parse('$baseUrl/lists/$listId/tasks'),
          headers: _getHeaders(await getToken()),
          body: json.encode(taskData),
        ));
  }

  Future<dynamic> getTask(int listId, int taskId) async {
    return _handleRequest(() async => http.get(
          Uri.parse('$baseUrl/lists/$listId/tasks/$taskId'),
          headers: _getHeaders(await getToken()),
        ));
  }

  Future<dynamic> updateTask(
      int listId, int taskId, Map<String, dynamic> taskData) async {
    return _handleRequest(() async => http.patch(
          Uri.parse('$baseUrl/lists/$listId/tasks/$taskId'),
          headers: _getHeaders(await getToken()),
          body: json.encode(taskData),
        ));
  }

  Future<void> deleteTask(int listId, int taskId) async {
    await _handleRequest(() async => http.delete(
          Uri.parse('$baseUrl/lists/$listId/tasks/$taskId'),
          headers: _getHeaders(await getToken()),
        ));
  }

  Future<dynamic> toggleTask(int listId, int taskId) async {
    return _handleRequest(() async => http.patch(
          Uri.parse('$baseUrl/lists/$listId/tasks/$taskId/toggle'),
          headers: _getHeaders(await getToken()),
        ));
  }
}
