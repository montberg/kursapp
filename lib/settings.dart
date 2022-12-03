import 'package:flutter/material.dart';

import 'main.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 8,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 300,
                child: TextField(
                  //controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                              width: 0.7, color: Colors.black.withOpacity(0.3))),
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
              SizedBox(height: 10),
              SizedBox(
                width: 300,
                child: TextField(
                  //controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                              width: 0.7, color: Colors.black.withOpacity(0.3))),
                      hintText: "Повторите пароль",
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
                height: 56,
                child: ElevatedButton(
                  onPressed: () async {},
                  child: Text(
                    "Сменить пароль",
                    style: Theme.of(context)
                        .textTheme
                        .headline4!
                        .copyWith(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
