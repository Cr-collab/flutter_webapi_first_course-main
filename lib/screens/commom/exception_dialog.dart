import 'package:flutter/material.dart';

Future<dynamic> showExceptionDialog(
  BuildContext context, {
  String title = "Um Problema acontenceu!",
  required String content,
}) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("OK!"),
            ),
          ],
        );
      });
}
