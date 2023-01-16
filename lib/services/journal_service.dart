import 'dart:convert';
import 'dart:io';

import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/services/web_client.dart';
import 'package:http/http.dart' as http;

class JournalService {
  static const String resource = 'journals/';
  WebClient webClient = WebClient();
  String url = WebClient.url;
  http.Client client = WebClient().client;

  String getUrl() {
    return "$url$resource";
  }

  // salvando os dados
  Future<bool> register(
    Journal journal,
    String token,
  ) async {
    final uriParse = Uri.parse(getUrl());
    String jsonJournal = json.encode(journal.toMap());
    http.Response response = await client.post(
      uriParse,
      body: jsonJournal,
      headers: {
        'Content-type': "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode != 201) {
      if (json.decode(response.body) == "jwt expired") {
        throw TokenNotValidException();
      }
      throw HttpException(response.body);
    }
    return true;
  }

  // editando os dados
  Future<bool> edit(
    String id,
    Journal journal,
    String token,
  ) async {
    final uriParse = Uri.parse('${getUrl()}$id');

    String jsonJournal = json.encode(journal.toMap());
    http.Response response = await client.put(
      uriParse,
      headers: {
        'Content-type': "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonJournal,
    );

    if (response.statusCode != 201) {
      if (json.decode(response.body) == "jwt expired") {
        throw TokenNotValidException();
      }
      throw HttpException(response.body);
    }
    return true;
  }

  Future<List<Journal>> getAll({
    required String id,
    required String token,
  }) async {
    http.Response response = await client.get(
      Uri.parse("${url}users/$id/journals"),
      headers: {"Authorization": "Bearer $token"},
    );
    if (response.statusCode != 200) {
      if (json.decode(response.body) == "jwt expired") {
        throw TokenNotValidException();
      }
      throw HttpException(response.body);
    }

    List<Journal> list = [];
    List<dynamic> listDynamic = json.decode(response.body);
    for (var jsonMap in listDynamic) {
      list.add(Journal.fromMap(jsonMap));
    }

    return list;
  }

  Future<bool> delete(String idJournal, String token) async {
    final uriParse = Uri.parse("${getUrl()}$idJournal");

    http.Response response = await http.delete(
      uriParse,
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode != 200) {
      if (json.decode(response.body) == "jwt expired") {
        throw TokenNotValidException();
      }
      throw HttpException(response.body);
    }
    return true;
  }
}

class TokenNotValidException implements Exception {}
