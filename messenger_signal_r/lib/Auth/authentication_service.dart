
import 'package:dio/dio.dart';
import 'package:messenger_signal_r/Model/token_response.dart';
import 'package:messenger_signal_r/storage/secure_storage.dart';

import '../constants.dart';

class AuthenticationService{

  static final Dio _dio = Dio();

  static Future<bool> authentication(String username, String password) async{
    var params = {
      "username" : username,
      "password" : password
    };
    final encodedData = params.entries
        .toList()
        .map((entry) => [
      Uri.encodeComponent(entry.key),
      Uri.encodeComponent(entry.value)
    ].join('='))
        .join('&');
    bool isException = false;
    print("${baseURL}token?${encodedData}");
    await _dio.post("${baseURL}token?${encodedData}")
        .then((response) {
        TokenResponse tokenResponse = TokenResponse.fromJson(response.data);
        String? token = tokenResponse.accessToken;
        String? name = tokenResponse.username;
        int? id = tokenResponse.userId;
        print(token);
        SecureStorage.setAccessToken(token!);
        SecureStorage.setUsername(name!);
        SecureStorage.setUserID(id.toString());
    }).catchError((err) {
      print(err.response.data);
      isException = true;
    });
    if (isException) {
      return false;
    }
    return true;
  }

}