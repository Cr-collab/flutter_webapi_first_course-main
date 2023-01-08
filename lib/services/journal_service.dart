import 'dart:convert';

import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/services/http_interceptors.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/http.dart';

http.Client client = InterceptedClient.build(interceptors: [
  LoggingInterceptor(),
]);

class JournalService {
  static const String url = 'http://192.168.0.140:3000/';
  static const String resource = 'journals/';

  String getUrl() {
    return "$url$resource";
  }

  Future<bool> register(Journal journal) async {
    final uriParse = Uri.parse(getUrl());
    String jsonJournal = json.encode(journal.toMap());
    http.Response response = await client.post(
      uriParse,
      body: jsonJournal,
      headers: {'Content-type': "application/json"},
    );

    if (response.statusCode == 201) {
      return true;
    }
    return false;
  }

  Future<String> get() async {
    http.Response response = await client.get(Uri.parse(getUrl()));
    print(response.body);
    return response.body;
  }
}
