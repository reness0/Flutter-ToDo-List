import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'dart:convert';

class ManipulatingData {
  static List toDoList = [];
  static Map<String, dynamic> lastRemoved;
  static int lastRemovedPosition;

  static Future<File> getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  static Future<File> saveData() async {
    String data = json.encode(toDoList);
    final file = await getFile();
    return file.writeAsString(data);
  }

  static Future<String> readData() async {
    try {
      final file = await getFile();

      return file.readAsString();
    } catch (e) {
      return "erro: " + e;
    }
  }

  static void addToDo(String title, String desc, String date) {
    Map<String, dynamic> newToDo = Map();
    newToDo["title"] = title;
    newToDo["desc"] = desc;
    newToDo["date"] = date;
    newToDo["ok"] = false;
    toDoList.add(newToDo);
    saveData();
  }

  static void removingData(index) {
    lastRemoved = Map.from(toDoList[index]);
    lastRemovedPosition = index;
    toDoList.removeAt(index);
    saveData();
  }

  static Future<Null> refresh() async {
    await Future.delayed(Duration(seconds: 1));

    toDoList.sort((a, b) {
      if (a["ok"] && !b["ok"]) {
        return 1;
      } else if (!a["ok"] && b["ok"]) {
        return -1;
      }
      return 0;
    });
    saveData();
  }
}
