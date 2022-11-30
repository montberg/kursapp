import 'package:flutter/material.dart';
import 'package:fluttermark/login_page.dart';
import 'package:fluttermark/main_page.dart';
import 'package:google_fonts/google_fonts.dart';
void main() {
  runApp(const MyApp());
}
const Color textColor = Color.fromARGB(255, 48, 48, 48);
class MyApp extends StatelessWidget {
  
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      title: 'FlutterMark',
      theme: ThemeData(
        fontFamily: GoogleFonts.rubik().fontFamily,
        textTheme: GoogleFonts.rubikTextTheme(textTheme).copyWith(
          headline6: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal, color: textColor),
          headline4: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: textColor),
        ),
      ),
      //TODO return loginpage
      home: LoginPage(),
    );
  }
}
