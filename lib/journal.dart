import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttermark/user_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:textfield_search/textfield_search.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import 'package:printing/printing.dart';
import 'main.dart';
import 'navigation_column.dart';

class JournalTab extends StatefulWidget {
  var user_id;
  var isteacher;
  JournalTab({Key? key, required this.user_id, required this.isteacher})
      : super(key: key);

  @override
  State<JournalTab> createState() => _JournalTabState();
}

var yearController;
late TextEditingController groupController;
late TextEditingController examController;
var selectedExamID;
var selectedGroupID;
var selectedYear;
List<String?> currAction = [];

class _JournalTabState extends State<JournalTab> {
  @override
  void dispose() {
    yearController.dispose();
    groupController.dispose();
    examController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (mounted) {
      yearController = TextEditingController();
      groupController = TextEditingController();
      examController = TextEditingController();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var currentWorkspace = teacherWorkspace();
    print(widget.isteacher);
    if (widget.isteacher == 'false') currentWorkspace = studentWorkspace();
    return Scaffold(
      body: currentWorkspace,
    );
  }

  Widget studentWorkspace() {
    return FutureBuilder<List<StudentMarkInfo>>(
      future: StudentMarkInfo.getMarks(widget.user_id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
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
                      itemCount: snapshot.data!.length + 1,
                      itemBuilder: ((context, index) {
                        if (index == 0) {
                          return Container(
                            color: const Color.fromARGB(255, 242, 245, 249),
                            height: 60,
                            child: Stack(children: [
                              Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Align(
                                    child: Text(
                                      "Экзамен",
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                    ),
                                    alignment: Alignment.centerLeft,
                                  )),
                              Padding(
                                  padding: const EdgeInsets.only(left: 550),
                                  child: Align(
                                      child: Text("Дата",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4),
                                      alignment: Alignment.centerLeft)),
                              Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Align(
                                    child: Text("Оценка",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4),
                                    alignment: Alignment.centerRight,
                                  ))
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
                        currAction = List.generate(
                            snapshot.data!.length, (_) => null,
                            growable: false);
                        return Container(
                          color: color,
                          height: 60,
                          child: Stack(children: [
                            Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Align(
                                  child: Text(snapshot.data![index - 1].label,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6),
                                  alignment: Alignment.centerLeft,
                                )),
                            Padding(
                                padding: const EdgeInsets.only(left: 550),
                                child: Align(
                                    child: Text(snapshot.data![index - 1].date,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6),
                                    alignment: Alignment.centerLeft)),
                            Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Align(
                                    child: Text(snapshot.data![index - 1].mark,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6),
                                    alignment: Alignment.centerRight)),
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
    );
  }

  Widget teacherWorkspace() {
    return FutureBuilder<List<MarkInfo>>(
      future: MarkInfo.getMarksForTeacher(
          widget.user_id, selectedGroupID, selectedExamID, yearController.text),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          bool isVisible = MarkInfo.marks.isNotEmpty;
          return Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Курс",
                            style: Theme.of(context).textTheme.headline4),
                        const SizedBox(height: 5),
                        TextFieldSearch(
                          label: "Курс",
                          initialList: const ["1", "2", "3", "4", "5"],
                          controller: yearController,
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
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text("Группа",
                            style: Theme.of(context).textTheme.headline4),
                        const SizedBox(height: 5),
                        TextFieldSearch(
                          label: "Группа",
                          controller: groupController,
                          getSelectedValue: (value) {
                            selectedGroupID = (value as Group).id;
                            groupController.text = (value as Group).label;
                          },
                          future: () {
                            return Group.getGroupList(
                                User.getUserNoFuture()!.id.toString(),
                                yearController.text);
                          },
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
                        )
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text("Дисциплина",
                            style: Theme.of(context).textTheme.headline4),
                        const SizedBox(height: 5),
                        TextFieldSearch(
                          label: "Дисциплина",
                          controller: examController,
                          future: () => Exam.getExamList(groupController.text),
                          getSelectedValue: (value) {
                            selectedExamID = ((value as Exam).id);
                          },
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
                        )
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
                          onPressed: () async {
                            setState(() {});
                          },
                          child: Text(
                            "Поиск",
                            style: Theme.of(context)
                                .textTheme
                                .headline4!
                                .copyWith(color: Colors.white),
                          ),
                          style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0.0),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color.fromARGB(255, 53, 126, 251)),
                              fixedSize: MaterialStateProperty.all(
                                  const Size(300, 57)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide.none))),
                        ),
                      )
                    ],
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
                      itemCount: snapshot.data!.length + 1,
                      itemBuilder: ((context, index) {
                        if (index == 0) {
                          return Container(
                            color: const Color.fromARGB(255, 242, 245, 249),
                            height: 60,
                            child: Stack(children: [
                              Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Align(
                                    child: Text(
                                      "Имя",
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                    ),
                                    alignment: Alignment.centerLeft,
                                  )),
                              Padding(
                                  padding: const EdgeInsets.only(left: 350),
                                  child: Align(
                                      child: Text("Номер зачетной книжки",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4),
                                      alignment: Alignment.centerLeft)),
                              Padding(
                                  padding: const EdgeInsets.only(left: 700),
                                  child: Align(
                                      child: Text("Группа",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4),
                                      alignment: Alignment.centerLeft)),
                              Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Align(
                                    child: Text("Оценка",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4),
                                    alignment: Alignment.centerRight,
                                  ))
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
                        currAction = List.generate(
                            snapshot.data!.length, (_) => null,
                            growable: false);
                        return Container(
                          color: color,
                          height: 60,
                          child: Stack(children: [
                            Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Align(
                                  child: Text(snapshot.data![index - 1].name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6),
                                  alignment: Alignment.centerLeft,
                                )),
                            Padding(
                                padding: const EdgeInsets.only(left: 350),
                                child: Align(
                                    child: Text(
                                        snapshot.data![index - 1].record_book,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6),
                                    alignment: Alignment.centerLeft)),
                            Padding(
                                padding: const EdgeInsets.only(left: 700),
                                child: Align(
                                    child: Text(snapshot.data![index - 1].group,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6),
                                    alignment: Alignment.centerLeft)),
                            Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: Align(
                                  child: (() {
                                    if (widget.isteacher == '0') {
                                      return Text(
                                          snapshot.data![index - 1].mark,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6);
                                    } else {
                                      const list = ["н/д", "2", "3", "4", "5"];
                                      currAction[index - 1] = list.firstWhere(
                                          (element) =>
                                              snapshot.data![index - 1].mark ==
                                              element);
                                      return DropdownButton<String>(
                                        icon: const SizedBox(width: 20),
                                        underline: const SizedBox.shrink(),
                                        value: currAction[index - 1],
                                        elevation: 1,
                                        style: const TextStyle(
                                            color: Colors.deepPurple),
                                        onChanged: (selected) async {
                                          Exam.setExamMark(
                                              snapshot.data![index - 1].id,
                                              selected);
                                          setState(() {});
                                        },
                                        itemHeight: 50,
                                        items: list
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value,
                                                style: const TextStyle(
                                                    fontSize: 30)),
                                          );
                                        }).toList(),
                                      );
                                    }
                                  }()),
                                  alignment: Alignment.centerRight,
                                ))
                          ]),
                        );
                      })),
                ),
              ),
              const SizedBox(height: 5),
              Visibility(
                visible: isVisible,
                child: FloatingActionButton.extended(
                    onPressed: () async {
                      Printing.layoutPdf(
                        onLayout: (PdfPageFormat format) {
                          return buildPdf(format);
                        },
                      );
                    },
                    label: const Text("Сохранить ведомость"),
                    icon: const Icon(Icons.print)),
              ),
              const SizedBox(height: 5),
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
    );
  }

  Future<Uint8List> buildPdf(PdfPageFormat format) async {
    print(MarkInfo.marks.length);
    print(MarkInfo.marks.first.name);
    List<List<String>> listOfmarks = [];
    listOfmarks.add(<String>['Имя', 'Зачетная книжка', 'Оценка', 'Подпись']);
    for(var e in MarkInfo.marks){
      listOfmarks.add(<String>[e.name, e.record_book, e.mark]);
    }
    print(listOfmarks.length);
    final pw.Document doc = pw.Document();
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    final font = await PdfGoogleFonts.robotoBold();
    final font2 = await PdfGoogleFonts.robotoLight();
    doc.addPage(
      pw.Page(
        pageFormat: format,
        build: (pw.Context context) {
          return pw.Column(
              children: [
                pw.Align(
                    child:
                        pw.Text("Зачетная ведомость №____________", style: pw.TextStyle(font: font)),
                    alignment: pw.Alignment.center),
                pw.Align(
                    child: pw.Text(
                        '"_____" ___________________ 20___г.',
                        style: pw.TextStyle(font: font2)),
                    alignment: pw.Alignment.center),
                pw.Text("Группа " + groupController.text,
                    style: pw.TextStyle(font: font2)),
                pw.Text("Предмет " + examController.text,
                    style: pw.TextStyle(font: font2)),
                pw.SizedBox(height: 20),
                pw.Align(
                    child: pw.Text("Преподаватель " + teacherName,
                        style: pw.TextStyle(font: font2)),
                    alignment: pw.Alignment.centerRight),
                pw.SizedBox(height: 20),
                pw.Table.fromTextArray(
                    context: context,
                    data: listOfmarks,
                    cellStyle: pw.TextStyle(font: font2),
                    headerStyle: pw.TextStyle(font: font),
                    ),
                pw.SizedBox(height: 20),
                pw.Text("Директор института / Декан факультета _________________ ",
                    style: pw.TextStyle(font: font2)),
              ]);
        },
      ),
    );

    // Build and return the final Pdf file data
    return await doc.save();
  }
}
