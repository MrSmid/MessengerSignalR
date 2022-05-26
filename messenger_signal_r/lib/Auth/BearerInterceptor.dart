import 'package:dio/dio.dart';
import 'package:messenger_signal_r/storage/secure_storage.dart';

class BearerInterceptor extends Interceptor {

  Dio dio;

  BearerInterceptor(this.dio);

  @override
  Future onRequest(RequestOptions options,
      RequestInterceptorHandler handler) async {
    final token = await SecureStorage.getAccessToken();
    if (token != null) {
      options.headers.addAll({"Authorization": "Bearer ${token}"});
    }
    return handler.next(options);
  }



}



/*

 @override
  Future onRequest(RequestOptions options) async {
    final token = await oauth.fetchOrRefreshAccessToken();
    print(token.accessToken);
    if (token != null) {
      options.headers.addAll({"Authorization": "Bearer ${token.accessToken}"});
    }
    return options;
  }


 @override
  Future onError(DioError error) async {
    RequestOptions options = error.requestOptions;
    if (error.response?.statusCode == 401) {
      final token = await oauth.refreshAccessToken();
      if (token != null) {
        options.headers
            .addAll({"Authorization": "Bearer ${token.accessToken}"});
      }
      return dio.request(options.path);
    }
    return error;
  }
*/






