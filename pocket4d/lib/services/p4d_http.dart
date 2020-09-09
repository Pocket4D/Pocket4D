import 'package:dio/dio.dart';

Future<Map<String, String>> getBundle(
    {String url,
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    void Function(int, int) onReceiveProgress}) async {
  try {
    Response<Map<String, dynamic>> response =
        await Dio().get(url, options: options ?? Options(responseType: ResponseType.json));
    Map<String, String> result = Map();

    // should identify better when knowing restful apis
    response.data.forEach((k, v) {
      result.putIfAbsent(k, () => v.toString());
    });
    return result;
  } catch (e) {
    throw e;
  }
}
