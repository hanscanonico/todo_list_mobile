import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:todo_list_mobile/screens/ListsPage.dart';
import 'package:todo_list_mobile/services/UserService.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Identifier',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20), // Adds space between the two TextFields
            TextField(
              controller: _passwordController,
              obscureText: true, // Hides the password
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20), // Adds space above the button
            ElevatedButton(
              onPressed: () async {
                await UserService()
                    .signIn(_emailController.text, _passwordController.text);

                if (_storage.read(key: 'token') != null) {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => ListsPage()));
                }
                // Implement your login logic here

                print(
                    'Identifier: ${_emailController.text}, Password: ${_passwordController.text}');
              },
              child: Text('Connect'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
