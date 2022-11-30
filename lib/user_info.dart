import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class User {
  var _id;
  var _name;
  get name => _name;
  var _isTeacher;
  var _recordBook;
  var _groupId;
  var _userDataId;
  List<dynamic> data = [];
  User() {
    _id = 0;
  }

  Future<User> getData(var id, var isTeacher, User user) async {
    if (user._id == 0) await fetchUserData(id, isTeacher, user);
    print(user._name);
    return user;
  }

  Future<User> fetchUserData(var thisid, var thisisTeacher, User user) async {
    var response = await http.post(Uri.http('127.0.0.1:3500', '/api/getuser/'),
        body: {'id': thisid, 'isteacher': thisisTeacher});
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      var _response = jsonResponse.values.last as Map<String, dynamic>;
      user._id = _response['id'];
      user._name = _response['full_name'];
      if (thisisTeacher == '1') user._isTeacher = true;
      user._recordBook = _response['record_book'];
      user._groupId = _response['group'];
      user._userDataId = _response['user_data'];
    } else {
      user._id = 0;
      user._name = "unidentified";
    }
    return user;
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
        print(response.body);
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
    return outputList;
  }
}

class Group {
  var id;
  var label;

  Group({this.id, this.label});

  static Future<List<Group>> getGroupList(var teacher, var year) async {
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
        print("Success");
      }
    }
    else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }
}
