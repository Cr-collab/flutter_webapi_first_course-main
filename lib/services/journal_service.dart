import 'package:flutter_webapi_first_course/services/http_interceptors.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/http.dart';

http.Client client = InterceptedClient.build(interceptors: [
  LoggingInterceptor(),
]);

class JournalService {
  static const String url = 'http://192.168.0.140:3000/';
  static const String resource = 'learnhttp2/';

  String getUrl() {
    return "$url$resource";
  }

  register(String content) async {
    final uriParse = Uri.parse(getUrl());
    final a = await client.post(uriParse, body: {"content": content});
    print(a);
  }

  Future<String> get() async {
    http.Response response = await client.get(Uri.parse(getUrl()));
    print(response.body);
    return response.body;
  }
}
