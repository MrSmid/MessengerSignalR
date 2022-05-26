import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage{
  static final _storage = FlutterSecureStorage();

  static const String _keyToken = "token";
  static const String _keyUsername = "username";
  static const String _keyUserId = "userId";

  static setAccessToken(String token) async{
    await _storage.write(key: _keyToken, value: token);
  }

  static Future<String?> getAccessToken() async{
    return _storage.read(key: _keyToken);
  }

  static setUsername(String token) async{
    await _storage.write(key: _keyUsername, value: token);
  }

  static Future<String?> getUsername() async{
    return _storage.read(key: _keyUsername);
  }

  static setUserID(String id) async{
    await _storage.write(key: _keyUserId, value: id);
  }

  static Future<int> getUserID() async{
    return _storage.read(key: _keyUserId)
        .then((stringUserID) {
          return int.parse(stringUserID!);
        });
  }
}