import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:walter/widgets/loginwidget.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'walter',
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.dark,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'walter',
            style: GoogleFonts.dosis(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ),
        body: const LoginWidget(),
      ),
    );
  }
}
