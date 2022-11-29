import 'package:flutter/material.dart';
import 'package:fluttermark/user_info.dart';

import 'main.dart';

class JournalTab extends StatefulWidget {
  const JournalTab({Key? key}) : super(key: key);

  @override
  State<JournalTab> createState() => _JournalTabState();
}

class _JournalTabState extends State<JournalTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<MarkInfo>>(
        future: MarkInfo.getMarksForTeacher('44', '2', '1', '4'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Курс",
                              style: Theme.of(context).textTheme.headline4),
                              SizedBox(height: 5),
                          TextField(
                            //controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                        width: 0.7,
                                        color: Colors.black.withOpacity(0.3))),
                                hintText: "Курс",
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(
                                        color: Colors.black.withAlpha(150))),
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(color: textColor),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text("Группа",
                              style: Theme.of(context).textTheme.headline4),
                          SizedBox(height: 5),
                          TextField(
                            //controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                        width: 0.7,
                                        color: Colors.black.withOpacity(0.3))),
                                hintText: "Группа",
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(
                                        color: Colors.black.withAlpha(150))),
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(color: textColor),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text("Дисциплина",
                              style: Theme.of(context).textTheme.headline4),
                              SizedBox(height: 5),
                          TextField(
                            //controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                        width: 0.7,
                                        color: Colors.black.withOpacity(0.3))),
                                hintText: "Дисциплина",
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(
                                        color: Colors.black.withAlpha(150))),
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(color: textColor),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text("Поиск",
                              style: Theme.of(context).textTheme.headline4),
                              SizedBox(height: 5),
                          TextField(
                            //controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                        width: 0.7,
                                        color: Colors.black.withOpacity(0.3))),
                                hintText: "Поиск",
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(
                                        color: Colors.black.withAlpha(150))),
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(color: textColor),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Flexible(
                  fit: FlexFit.tight,
                  child: Container(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          offset: const Offset(0, 0),
                          blurRadius: 2,
                          spreadRadius: 0)
                    ]),
                    child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: ((context, index) {
                          if(index==0){
                          return Container(
                            color: const Color.fromARGB(255, 242, 245, 249),
                            height: 60,
                            child: Stack(
                              children: [
                              Padding(padding: EdgeInsets.only(left: 10), child: Align(child: Text("Имя", style: Theme.of(context).textTheme.headline4,), alignment: Alignment.centerLeft,)),
                              Padding(padding: EdgeInsets.only(left: 350), child: Align(child: Text("Номер зачетной книжки", style: Theme.of(context).textTheme.headline4), alignment: Alignment.centerLeft)),
                              Padding(padding: EdgeInsets.only(left: 700), child: Align(child: Text("Группа", style: Theme.of(context).textTheme.headline4), alignment: Alignment.centerLeft)),
                              Padding(padding: EdgeInsets.only(right: 10), child: Align(child: Text("Оценка", style: Theme.of(context).textTheme.headline4), alignment: Alignment.centerRight,))
                            ]),
                          );
                          }
                          var color;
                          if (index % 2 == 0) {
                            color = const Color.fromARGB(255, 242, 245, 249);
                          } else {
                            color = Colors.white;
                          }
                          if (snapshot.data!.isEmpty) {
                            return const Center(
                                child: Text(
                                    "По заданным параметрам ничего не найдено"));
                          }
                          return Container(
                            color: color,
                            height: 60,
                            child: Stack(
                              children: [
                              Padding(padding: const EdgeInsets.only(left: 10), child: Align(child: Text(snapshot.data![index-1].name, style: Theme.of(context).textTheme.headline6), alignment: Alignment.centerLeft,)),
                              Padding(padding: const EdgeInsets.only(left: 350), child: Align(child: Text(snapshot.data![index-1].record_book, style: Theme.of(context).textTheme.headline6), alignment: Alignment.centerLeft)),
                              Padding(padding: const EdgeInsets.only(left: 700), child: Align(child: Text(snapshot.data![index-1].group, style: Theme.of(context).textTheme.headline6), alignment: Alignment.centerLeft)),
                              Padding(padding: const EdgeInsets.only(right: 20), child: Align(child: Text(snapshot.data![index-1].mark, style: Theme.of(context).textTheme.headline6), alignment: Alignment.centerRight,))
                            ]),
                          );
                        })),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            );
          }
          if (snapshot.hasError) {
            return Center(
                child: Column(
              children: [
                const Icon(Icons.error, color: Colors.red, size: 60),
                Text(snapshot.error.toString()),
              ],
            ));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
