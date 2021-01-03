import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.black,
      primaryColor: Colors.amberAccent,
    ),
    debugShowCheckedModeBanner: false,
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _toDoController = TextEditingController();
  List _toDoList = [];
  Map<String, dynamic> _lastRemoved;
  int _lastRemovedIndex;

  @override
  void initState() {
    super.initState();
    _getData().then((data) {
      setState(() {
        _toDoList = json.decode(data); // Converts from json to String
      });
    });
  }

  void _addToDo() {
    setState(() {
      Map<String, dynamic> newToDo = Map();
      newToDo["title"] = _toDoController.text;
      _toDoController.text = "";
      newToDo["ok"] = false;
      _toDoList.add(newToDo);
      _saveData();
    });
  }

  Future<Null> _refresh() async{  //Update list
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _toDoList.sort((a, b){
        if(a["ok"] && !b["ok"]) return 1;
        else if (!a["ok"] && b["ok"]) return -1;
        else return 0;
      });
      _saveData();
    });
    return null;
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future<File> _saveData() async {
    String data = json.encode(_toDoList); // Convert list to json
    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _getData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "To Do List",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.amberAccent,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 5, 10),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                        controller: _toDoController,
                        decoration: InputDecoration(
                          labelText: "New activity",
                          labelStyle: TextStyle(color: Colors.black),
                        ),
                        style: TextStyle(color: Colors.black, fontSize: 20.0))),
                RaisedButton(
                  color: Colors.amberAccent,
                  child: Row(
                    children: <Widget>[
                      Text(
                        "Add",
                        style: TextStyle(color: Colors.black),
                      ),
                      Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                    ],
                  ),
                  onPressed: _addToDo,
                )
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(onRefresh: _refresh,
            child: ListView.builder(
              itemCount: _toDoList.length,
              itemBuilder: builtItem,
            ),
            )
          )
        ],
      ),
    );
  }

  Widget builtItem(context, index) {
    return Dismissible(
      //Makes item deletable
      key: Key(DateTime.now().microsecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Row(children: [
            Icon(Icons.delete, color: Colors.white),
            Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                "Removing...",
                style: TextStyle(color: Colors.white),
              ),
            )
          ]),
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
        checkColor: Colors.black,
        activeColor: Colors.amber,
        contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        title: Text(_toDoList[index]["title"],
            style: TextStyle(
                fontSize: 25.0,
                decoration: _toDoList[index]["ok"]
                    ? TextDecoration.lineThrough
                    : TextDecoration.none)),
        value: _toDoList[index]["ok"],
        onChanged: (c) {
          setState(() {
            _toDoList[index]["ok"] = c;
            _saveData();
          });
        },
      ),
      onDismissed: (direction) {
        setState(() {
          _lastRemoved = Map.from(_toDoList[index]);
          _lastRemovedIndex = index;
          _toDoList.removeAt(index);
          _saveData();

          final snack = SnackBar(
            content: Text("\"${_lastRemoved["title"]}\" was removed!"),
            action: SnackBarAction(
              label: "Undo",
              onPressed: () {
                setState(() {
                  _toDoList.insert(_lastRemovedIndex, _lastRemoved);
                  _saveData();
                });
              },
            ),
            duration: Duration(seconds: 2),
          );
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(snack);
        });
      },
    );
  }
}
