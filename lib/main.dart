import 'package:flutter/material.dart';
import 'package:todo_list_mobile/screens/ListsPage.dart';
import 'package:todo_list_mobile/screens/LoginPage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  Widget _defaultHome = LoginPage(); // Default to login page

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  void _checkToken() async {
    String? token = await _storage.read(key: 'token');
    if (token != null) {
      setState(() {
        _defaultHome = ListsPage(); // Change to list page if token exists
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: _defaultHome,
    );
  }
}
