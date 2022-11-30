import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttermark/main.dart';
import 'package:fluttermark/user_info.dart';

class NavigationColumn extends StatefulWidget {
  final ValueNotifier current;
  var id;
  var isTeacher;
  NavigationColumn(this.current,
      {Key? key, required this.id, required this.isTeacher})
      : super(key: key);

  @override
  State<NavigationColumn> createState() => _NavigationColumnState();
}

class _NavigationColumnState extends State<NavigationColumn> {
  
  @override
  Widget build(BuildContext context) {
    print(widget.id);
    return Container(
      color: const Color.fromARGB(255, 242, 245, 249),
      child: SizedBox(
        width: 300,
        child: Stack(children: [
          const Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Align(alignment: Alignment.topCenter, child: flutterMark()),
          ),
          const SizedBox(height: 50),
          Align(
            alignment: Alignment.center,
            child: NavigationButtonsGroup(widget.current),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: Align(
                alignment: Alignment.bottomCenter,
                child: UserInfoGroup(id: widget.id.toString(), isTeacher: widget.isTeacher.toString())),
          ),
        ]),
      ),
    );
  }
}

class UserInfoGroup extends StatefulWidget {
  var id;
  var isTeacher;
  UserInfoGroup({Key? key, required this.id, required this.isTeacher}) : super(key: key);

  @override
  State<UserInfoGroup> createState() => _UserInfoGroupState();
}


class _UserInfoGroupState extends State<UserInfoGroup> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
        future: User.getUser(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.account_circle_outlined, size: 34,),
                  const SizedBox(width: 10),
                  Text(snapshot.data!.name, style: Theme.of(context).textTheme.headline4,),
                  const SizedBox(width: 10),
                  FloatingActionButton(child: const Icon(Icons.logout_rounded, size: 34, color: textColor,), elevation: 0.0, focusElevation: 0.0, hoverElevation: 0.0, disabledElevation: 0.0, highlightElevation: 0.0, onPressed: ()=>User.logout(context), backgroundColor: Colors.transparent),
                  ]);
          } else {
            return Row(
              children: [
                const Icon(Icons.error_outline_rounded, color: Colors.red),
                const SizedBox(width: 5),
                Text(snapshot.error.toString()),
              ],
            );
          }
        }));
  }
}

class NavigationButtonsGroup extends StatefulWidget {
  final ValueNotifier current;
  const NavigationButtonsGroup(this.current, {Key? key}) : super(key: key);

  @override
  State<NavigationButtonsGroup> createState() => _NavigationButtonsGroupState();
}

class _NavigationButtonsGroupState extends State<NavigationButtonsGroup> {
  List<bool> activeList = [true, false, false];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildButton(
            context, Icons.menu_book_outlined, "Журнал", activeList[0], 0),
        const SizedBox(height: 20),
        buildButton(context, Icons.query_stats, "Статистика", activeList[1], 1),
        const SizedBox(height: 20),
        buildButton(
            context, Icons.settings_outlined, "Настройки", activeList[2], 2),
      ],
    );
  }

  GestureDetector buildButton(BuildContext context, IconData icon, String text,
      bool isActive, int index) {
    var iconColor = const Color(0xFF357DFB);
    var textColor = const Color(0xFF303030);
    var containerColor = Colors.white;
    List<BoxShadow>? shadow = [
      BoxShadow(
          color: Colors.black.withOpacity(0.5),
          offset: const Offset(0, 0),
          blurRadius: 5,
          spreadRadius: 0)
    ];
    if (!isActive) {
      iconColor = const Color(0xFF909090);
      textColor = const Color(0xFF909090);
      containerColor = Colors.transparent;
      shadow = [];
    }
    return GestureDetector(
      onTap: () {
        if (!activeList[index]) {
          setState(() {
            activeList = List.filled(activeList.length, false);
            activeList[index] = true;
          });
          widget.current.value = index;
        }
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: containerColor,
            boxShadow: shadow),
        width: 270,
        height: 63,
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const SizedBox(width: 20),
          Icon(
            icon,
            color: iconColor,
            size: 31,
          ),
          const SizedBox(width: 20),
          Text(text,
              style: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(color: textColor))
        ]),
      ),
    );
  }
}

class flutterMark extends StatelessWidget {
  const flutterMark({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const FlutterLogo(size: 55),
          Text("FlutterMark",
              style: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(fontSize: 35, fontWeight: FontWeight.w700))
        ]);
  }
}
