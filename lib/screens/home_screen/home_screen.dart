import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/screens/commom/exception_dialog.dart';
import 'package:flutter_webapi_first_course/screens/home_screen/widgets/home_screen_list.dart';
import 'package:flutter_webapi_first_course/services/journal_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/journal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // O último dia apresentado na lista
  DateTime currentDay = DateTime.now();

  // Tamanho da lista
  int windowPage = 10;

  // A base de dados mostrada na lista
  Map<String, Journal> database = {};
  JournalService service = JournalService();
  final ScrollController _listScrollController = ScrollController();
  int? userId;
  String? token;

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Título basado no dia atual
        title: Text(
          "${currentDay.day}  |  ${currentDay.month}  |  ${currentDay.year}",
        ),
        actions: [
          IconButton(
              onPressed: () => refresh(), icon: const Icon(Icons.refresh)),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              onTap: (() {
                logout();
              }),
              title: const Text("Deslogar"),
              leading: const Icon(
                Icons.logout,
              ),
            ),
          ],
        ),
      ),
      body: (userId != null && token != null)
          ? ListView(
              controller: _listScrollController,
              children: generateListJournalCards(
                windowPage: windowPage,
                currentDay: currentDay,
                database: database,
                refreshFunction: refresh,
                userId: userId!,
                token: token!,
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  void logout() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.clear();
      Navigator.pushReplacementNamed(context, "login");
    });
  }

  void refresh() async {
    await SharedPreferences.getInstance().then((prefs) {
      String? tokenA = prefs.getString("accessToken");
      String? email = prefs.getString("email");
      int? id = prefs.getInt("id");

      if (tokenA != null && email != null && id != null) {
        setState(() {
          userId = id;
          token = tokenA;
        });

        service
            .getAll(
          id: id.toString(),
          token: token!,
        )
            .then((List<Journal> listJournal) {
          setState(() {
            database = {};
            for (Journal journal in listJournal) {
              database[journal.id] = journal;
            }
          });
        });
      } else {
        Navigator.pushReplacementNamed(context, "login");
      }
    }).catchError(
      (error) {
        showExceptionDialog(
          context,
          content: error.message,
        ).then((value) => logout());
      },
      test: (error) => error is TokenNotValidException,
    ).catchError(
      (error) {
        showExceptionDialog(
          context,
          content: error.message,
        );
      },
      test: (error) => error is HttpException,
    );
  }
}
