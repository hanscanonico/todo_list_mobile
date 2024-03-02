import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:todo_list_mobile/constants.dart';

Future<String?> getToken() async {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  return await _storage.read(key: tokenKey);
}
