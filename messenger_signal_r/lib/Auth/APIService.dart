import 'package:dio/dio.dart';
import 'package:messenger_signal_r/storage/secure_storage.dart';
import '../constants.dart';
import 'BearerInterceptor.dart';

class ApiService {
  var _dio;

  ApiService() {
    _dio = Dio();
    _dio.options.baseUrl = baseURL;
    _dio.interceptors.add(LogInterceptor(responseBody: true));
    _dio.interceptors.add(BearerInterceptor(_dio));
    /*SecureStorage.getAccessToken()
        .then((token) => _dio.options.headers["Authorization"] = "Bearer ${token}");*/
  }

  Future<Response> requestPOST(String path, {Map<String, dynamic>? data}) async{
    return await _dio.post(path, data: data);
  }
}