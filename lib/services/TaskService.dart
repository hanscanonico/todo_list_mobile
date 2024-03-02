import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:todo_list_mobile/functions.dart';

class TaskService {
  // 'https://task-tracker-api.fly.dev'
  final String baseUrl = 'https://task-tracker-api.fly.dev';
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<List<dynamic>> getTasks(int listId) async {
    String? token = await getToken();
    var response = await http.get(
      Uri.parse('$baseUrl/lists/$listId/tasks'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<dynamic> createTask(int listId, Map<String, dynamic> taskData) async {
    String? token = await getToken();
    var response = await http.post(
      Uri.parse('$baseUrl/lists/$listId/tasks'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(taskData),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create task');
    }
  }

  Future<dynamic> getTask(int listId, int taskId) async {
    String? token = await getToken();
    var response = await http
        .get(Uri.parse('$baseUrl/lists/$listId/tasks/$taskId'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load task');
    }
  }

  Future<dynamic> updateTask(
      int listId, int taskId, Map<String, dynamic> taskData) async {
    String? token = await getToken();
    var response = await http.patch(
      Uri.parse('$baseUrl/lists/$listId/tasks/$taskId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(taskData),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update task');
    }
  }

  Future<void> deleteTask(int listId, int taskId) async {
    String? token = await getToken();
    var response = await http
        .delete(Uri.parse('$baseUrl/lists/$listId/tasks/$taskId'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    }
  }

  Future<dynamic> toggleTask(int listId, int taskId) async {
    String? token = await getToken();

    var response = await http.patch(
        Uri.parse('$baseUrl/lists/$listId/tasks/$taskId/toggle'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to toggle task');
    }
  }
}
