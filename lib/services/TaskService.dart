import 'dart:convert';
import 'package:http/http.dart' as http;

class TaskService {
  final String baseUrl = 'http://localhost:3000';

  Future<List<dynamic>> getTasks(int listId) async {
    var response = await http.get(Uri.parse('$baseUrl/lists/$listId/tasks'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<dynamic> createTask(int listId, Map<String, dynamic> taskData) async {
    var response = await http.post(
      Uri.parse('$baseUrl/lists/$listId/tasks'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(taskData),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create task');
    }
  }

  Future<dynamic> getTask(int listId, int taskId) async {
    var response =
        await http.get(Uri.parse('$baseUrl/lists/$listId/tasks/$taskId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load task');
    }
  }

  Future<dynamic> updateTask(
      int listId, int taskId, Map<String, dynamic> taskData) async {
    var response = await http.patch(
      Uri.parse('$baseUrl/lists/$listId/tasks/$taskId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(taskData),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update task');
    }
  }

  Future<void> deleteTask(int listId, int taskId) async {
    var response =
        await http.delete(Uri.parse('$baseUrl/lists/$listId/tasks/$taskId'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    }
  }

  Future<dynamic> toggleTask(int listId, int taskId) async {
    var response = await http.patch(
      Uri.parse('$baseUrl/lists/$listId/tasks/$taskId/toggle'),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to toggle task');
    }
  }
}
