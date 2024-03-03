import 'package:flutter/material.dart';
import 'package:todo_list_mobile/functions.dart';
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
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await UserService()
                    .signIn(_emailController.text, _passwordController.text);
                if (await getToken() != null) {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => ListsPage()));
                }
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
