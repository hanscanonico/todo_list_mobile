import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todo_list_mobile/functions.dart';

class ListService {
  // 'https://task-tracker-api.fly.dev'
  final String baseUrl = 'https://task-tracker-api.fly.dev';

  Future<List<dynamic>> getLists() async {
    String? token = await getToken();
    var response = await http.get(
      Uri.parse('$baseUrl/lists'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load lists');
    }
  }

  Future<dynamic> createList(Map<String, dynamic> listData) async {
    String? token = await getToken();
    var response = await http.post(
      Uri.parse('$baseUrl/lists'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(listData),
    );
    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create list');
    }
  }

  Future<dynamic> getList(int listId) async {
    String? token = await getToken();
    var response = await http.get(
      Uri.parse('$baseUrl/lists/$listId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print('response: ${response.body}');
    print('token: $token');
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load list');
    }
  }

  Future<dynamic> updateList(int listId, Map<String, dynamic> listData) async {
    String? token = await getToken();
    var response = await http.patch(
      Uri.parse('$baseUrl/lists/$listId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(listData),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update list');
    }
  }

  Future<void> deleteList(int listId) async {
    String? token = await getToken();
    var response = await http.delete(
      Uri.parse('$baseUrl/lists/$listId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete list');
    }
  }
}
