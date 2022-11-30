import 'package:flutter/material.dart';
import 'package:fluttermark/main.dart';
import 'package:fluttermark/user_info.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'main_page.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Container(
        width: 350,
        height: 315,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  offset: const Offset(0, 0),
                  blurRadius: 5,
                  spreadRadius: 0)
            ]),
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Вход в сеть", style: Theme.of(context).textTheme.headline4),
              const SizedBox(height: 20),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                              width: 0.7,
                              color: Colors.black.withOpacity(0.3))),
                      hintText: "Почта",
                      hintStyle: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(color: Colors.black.withAlpha(150))),
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: textColor),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                              width: 0.7,
                              color: Colors.black.withOpacity(0.3))),
                      hintText: "Пароль",
                      hintStyle: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(color: Colors.black.withAlpha(150))),
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: textColor),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  var response = await http.post(
                      Uri.http('127.0.0.1:3500', 'api/auth/signin'),
                      body: {
                        'email': emailController.text,
                        'password': passwordController.text
                      });
                  if (response.statusCode == 200) {
                    print(response.body);
                    var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
                    if(user == null){ 
                      print('getting data');
                      await User.getData(jsonResponse['values']['id'].toString(), jsonResponse['values']['is_teacher'].toString()); 
                       print('user initialized');
                    }
                    print(user!.id);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MainPage(id: user!.id.toString(), isTeacher: user!.isTeacher.toString())),
                    );
                  }
                },
                child: Text(
                  "Войти",
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(color: Colors.white),
                ),
                style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0.0),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 53, 126, 251)),
                    fixedSize: MaterialStateProperty.all(const Size(300, 57)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide.none))),
              )
            ]),
      )),
    );
  }
}
