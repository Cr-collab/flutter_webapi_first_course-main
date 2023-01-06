import 'package:http/http.dart' as http;

var client = http.Client();

class JournalService {
  static const String url = 'http://192.168.0.140:3000/';
  static const String resource = 'learnhttp/';

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
