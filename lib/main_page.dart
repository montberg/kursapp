import 'package:flutter/material.dart';
import 'package:fluttermark/journal.dart';
import 'package:fluttermark/user_info.dart';

import 'navigation_column.dart';

class MainPage extends StatefulWidget {
  var id;
  var isTeacher;

  MainPage({ Key? key, required this.id, required this.isTeacher}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState(){
    super.initState();
  }
  final curr = ValueNotifier(0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          NavigationColumn(curr, id: widget.id, isTeacher: widget.isTeacher),
          SizedBox(width: 10),
          ValueListenableBuilder(valueListenable: curr, builder: (context, value, child){
            return _selectedPageBuilder(int.parse(value.toString()));
          }),
          SizedBox(width: 10),
        ]
      ),
    );
  }
  _selectedPageBuilder(int page) {
    switch (page) {
      case 0:
        return Expanded(child: JournalTab(user_id: widget.id.toString(), isteacher: widget.isTeacher.toString(),));
      case 1:
        return Text("1");
      case 2:
        return Text("2");
    }
  }
}