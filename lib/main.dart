import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _toDoList = [];
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  DateTime _dateTime;

  void _addToDo() {
    setState(() {
      Map<String, dynamic> newToDo = Map();
      newToDo["title"] = titleController.text;
      newToDo["desc"] = descController.text;
      newToDo["date"] = dateController.text;
      newToDo["ok"] = false;
      _toDoList.add(newToDo);
    });
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future<File> _saveData() async {
    String data = json.encode(_toDoList);
    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();

      return file.readAsString();
    } catch (e) {
      return "erro: " + e;
    }
  }

  _createAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              elevation: 15.0,
              title: Text("Name your task"),
              content: Form(
                  key: _formKey,
                  child: Container(
                      height: 250.0,
                      child: Center(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                            TextFormField(
                              controller: titleController,
                              decoration: const InputDecoration(
                                hintText: 'Type the title',
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Please, enter some text";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            TextFormField(
                              controller: descController,
                              decoration: const InputDecoration(
                                hintText: 'Type the description',
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Please, enter some text";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            TextFormField(
                              controller: dateController,
                              onTap: () {
                                showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime(2022))
                                    .then((date) {
                                  setState(() {
                                    _dateTime = date;
                                    dateController.text =
                                        date.toString().substring(0, 10);
                                  });
                                });
                              },
                              decoration: InputDecoration(
                                  hintText: 'Select the due date'),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Please, select the due date";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            Padding(
                                padding: EdgeInsets.only(top: 15.0),
                                child: RaisedButton(
                                    color: Colors.lightBlueAccent,
                                    onPressed: () {
                                      if (_formKey.currentState.validate()) {
                                        _addToDo();
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Text('Submit')))
                          ])))));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("To-Do List"),
        backgroundColor: Colors.lightBlueAccent,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: _toDoList.length,
        itemBuilder: (context, index) {
          return CheckboxListTile(
            title: Text(_toDoList[index]["title"]),
            value: _toDoList[index]["ok"],
            subtitle: Text(_toDoList[index]["desc"]),
            secondary: Column(children: <Widget>[
              Icon(_toDoList[index]["ok"] ? Icons.check : Icons.error),
              Text(_toDoList[index]["date"]),
            ]),
            onChanged: (bool value) {
              setState(() {
                _toDoList[index]["ok"] = value;
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _createAlertDialog(context);
        },
        label: Text('Add'),
        icon: Icon(Icons.add),
        backgroundColor: Colors.lightBlueAccent,
      ),
    );
  }
}
