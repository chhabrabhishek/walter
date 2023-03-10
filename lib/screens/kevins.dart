import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:walter/widgets/kevinwidget.dart';

class Kevins extends StatelessWidget {
  const Kevins({super.key, required this.minionId, required this.name});

  final int? minionId;
  final String? name;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'walter',
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.dark,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            name?.toString() ?? '',
            style: GoogleFonts.dosis(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: false,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: const <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: Icon(
                Icons.account_balance_rounded,
              ),
            ),
          ],
        ),
        body: KevinWidget(minionId: minionId, name: name),
      ),
    );
  }
}
