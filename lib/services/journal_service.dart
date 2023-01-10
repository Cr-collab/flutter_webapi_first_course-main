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

  // salvando os dados
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

  // editando os dados
  Future<bool> edit(String id, Journal journal) async {
    final uriParse = Uri.parse('${getUrl()}$id');

    String jsonJournal = json.encode(journal.toMap());
    http.Response response = await client.put(
      uriParse,
      headers: {'Content-type': "application/json"},
      body: jsonJournal,
    );

    if (response.statusCode == 201) {
      return true;
    }
    return false;
  }

  Future<List<Journal>> getAll() async {
    http.Response response = await client.get(Uri.parse(getUrl()));
    if (response.statusCode != 200) {
      throw Exception();
    }

    List<Journal> list = [];
    List<dynamic> listDynamic = json.decode(response.body);
    for (var jsonMap in listDynamic) {
      list.add(Journal.fromMap(jsonMap));
    }

    return list;
  }

  Future<bool> delete(String id) async {
    final uriParse = Uri.parse('${getUrl()}$id');

    http.Response response = await http.delete(uriParse);

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }
}
