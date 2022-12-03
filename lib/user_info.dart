import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttermark/login_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
User? user;

class User {
  var _id;
  get id => _id;
  set setId(var id) => _id = id;

  var _name;
  get name => _name;
  var _isTeacher;
  get isTeacher => _isTeacher;
  var _recordBook;
  var _groupId;
  var _userDataId;

  List<dynamic> data = [];

  User.student(var id, var name, var isTeacher, var recordBook, var groupId, var userDataId) {
    _id = id;
    _name = name;
    _isTeacher = isTeacher;
    _recordBook = recordBook;
    _groupId = groupId;
    _userDataId = userDataId;
  }
  User();
  User.teacher(var id, var name, var isTeacher, var userDataId) {
    _id = id;
    _isTeacher = isTeacher;
    _userDataId = userDataId;
    _name = name;
  }
  static User? getUserNoFuture(){
    if (user == null) getUser();
    return user;
  }
  static Future<User?> getUser() async{
    return user;
  }

  static logout(BuildContext context){
    user = null;
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(pageBuilder: (BuildContext context, Animation animation,
          Animation secondaryAnimation) {
        return LoginPage();
      }, transitionsBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      }),
      (Route route) => false);
  }

  static Future<void> getData(var id, var isTeacher) async {
    await fetchUserData(id, isTeacher);
    print(user!._id);
  }

  static Future<void> fetchUserData(var thisid, var thisisTeacher) async {
    user = null;
    var response = await http.post(Uri.http('127.0.0.1:3500', '/api/getuser/'),
        body: {'id': thisid, 'isteacher': thisisTeacher});
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      var _response = jsonResponse.values.last[0] as Map<String, dynamic>;
      bool isTeacher = false;
      if (thisisTeacher == '1') isTeacher = true;
      if(!isTeacher){
        user = User.student(_response['id'], _response['full_name'], isTeacher, _response['record_book'], _response['group'], _response['user_data']);
      }
      else {
        user = User.teacher(_response['id'], _response['full_name'], isTeacher, _response['user_data']);
      }
    } else {
      print("fetch user data error:");
      print(response.body);
    }

  }
}

class StudentMarkInfo {
  var _date;
  get date => _date;
  var _label;
  get label => _label;
  var _mark;
  get mark => _mark;

  StudentMarkInfo(var date, var label, var mark) {
    _date = date;
    _label = label;
    _mark = mark;
  }

  static Future<List<StudentMarkInfo>> getMarks(var id) async {
    List<StudentMarkInfo> outputList = [];
    var response = await http.post(Uri.http('127.0.0.1:3500', '/api/getmarks/'),
        body: {'id': id});
        //print(response.body);
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      var _response = jsonResponse.values.last as List<dynamic>;
      for (var item in _response) {
        
        var temp = item as Map<String, dynamic>;
        print(temp['date'].runtimeType);
        var currentMarkInfo = StudentMarkInfo(temp['date'], temp['label'], temp['mark']);
        //print(currentMarkInfo._date);
        outputList.add(currentMarkInfo);
      }
    }
    for(StudentMarkInfo a in outputList){
      print(a._label);
    }
    return outputList;
  }
}

class MarkInfo {
  var _id;
  get id => _id;
  var _group_name;
  get group => _group_name;
  var _mark;
  get mark => _mark;
  var _name;
  get name => _name;
  var _record_book;
  get record_book => _record_book;

  MarkInfo(var id, var groupName, var mark, var name, var recordBook) {
    _id = id;
    _group_name = groupName;
    _mark = mark;
    _name = name;
    _record_book = recordBook;
  }
  static List<MarkInfo> marks = [];
  static Future<List<MarkInfo>> getMarksForTeacher(
      var teacher, var group, var exam, var year) async {
    group = group.toString();
    exam = exam.toString();
    teacher = teacher.toString();
    year = year.toString();
    if (teacher == null || group == null || exam == null || year == null)
      return [];
    List<MarkInfo> outputList = [];
    var response = await http.post(Uri.http('127.0.0.1:3500', '/api/students/'),
        body: {'teacher': teacher, 'group': group, 'exam': exam, 'year': year});
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      var _response = jsonResponse.values.last as List<dynamic>;
      for (var item in _response) {
        var temp = item as Map<String, dynamic>;
        var currentMarkInfo = MarkInfo(temp['id'], temp['name'], temp['mark'],
            temp['full_name'], temp['record_book']);
        outputList.add(currentMarkInfo);
      }
    }
    marks = outputList;
    return outputList;
  }
}

class Group {
  var id;
  get _id => id;
  var label;
  get _label => label;

  Group({this.id, this.label});

  static Future<List<Group>> getGroupList(var teacher, var year) async {
    print("teacher ID is " + teacher);
    List<Group> output = [];
    var response = await http.post(Uri.http('127.0.0.1:3500', '/api/groups/'),
        body: {'teacher': teacher, 'year': year});
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      var _response = jsonResponse.values.last as List<dynamic>;
      for (var item in _response) {
        var temp = item as Map<String, dynamic>;
        output.add(Group(id: temp['id'], label: temp['name']));
      }
    }
    return output;
  }
}

class Exam {
  var id;
  get _id => id;
  var label;
  get _label => label;

  Exam({this.label, this.id});

  static Future<List<Exam>> getExamList(var group) async {
    List<Exam> output = [];
    var response = await http.post(Uri.http('127.0.0.1:3500', '/api/exams/'),
        body: {'group': group});
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      var _response = jsonResponse.values.last as List<dynamic>;
      for (var item in _response) {
        var temp = item as Map<String, dynamic>;
        output.add(Exam(id: temp['id'], label: temp['label']));
      }
    }
    return output;
  }

  static void setExamMark(var id, var mark) async {
    id = id.toString();
    mark = mark.toString();
    var response = await http.post(Uri.http('127.0.0.1:3500', '/api/setmark/'),
        body: {'id': id, 'mark' : mark});
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('succsess');
      }
    }
    else {
      if (kDebugMode) {
        print("error " + response.body);
      }
    }
  }
}
