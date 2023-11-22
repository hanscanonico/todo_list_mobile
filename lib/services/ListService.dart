import 'dart:convert';
import 'package:http/http.dart' as http;

class ListService {
  final String baseUrl = 'http://localhost:3000';

  Future<List<dynamic>> getLists() async {
    var response = await http.get(Uri.parse('$baseUrl/lists'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load lists');
    }
  }

  Future<dynamic> createList(Map<String, dynamic> listData) async {
    var response = await http.post(
      Uri.parse('$baseUrl/lists'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(listData),
    );
    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create list');
    }
  }

  Future<dynamic> getList(int listId) async {
    var response = await http.get(Uri.parse('$baseUrl/lists/$listId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load list');
    }
  }

  Future<dynamic> updateList(int listId, Map<String, dynamic> listData) async {
    var response = await http.patch(
      Uri.parse('$baseUrl/lists/$listId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(listData),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update list');
    }
  }

  Future<void> deleteList(int listId) async {
    var response = await http.delete(Uri.parse('$baseUrl/lists/$listId'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete list');
    }
  }
}
