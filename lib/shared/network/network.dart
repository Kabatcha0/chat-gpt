import 'package:chatgpt/shared/const.dart';
import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;
  static init() {
    dio = Dio(BaseOptions(
        baseUrl: baseUrl,
        receiveDataWhenStatusError: true,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $apiKeys"
        }));
  }

  static Future<Response> getUrl({required String path}) async {
    return await dio.get(path);
  }

  static Future<Response> postUrl({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    return await dio.post(path, data: data);
  }
}
