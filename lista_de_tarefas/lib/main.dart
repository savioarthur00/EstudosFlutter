// @dart=2.9
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';


void main() async {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _controllerTodo = TextEditingController();

  List _toDoList = [];

  Map<String,dynamic> _lastRemoved;
  int _lastRemovedPos;


  Future<Null> _refresh() async{
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _toDoList.sort((a, b){
        if(a["ok"] && !b["ok"]) return 1;
        else if(!a["ok"] && b["ok"]) return -1;
        else return 0;
      });

      _saveData();
    });

    return null;
  }

  @override
  void initState() {
    super.initState();

    _readData().then((data) {
      setState(() {
        _toDoList = json.decode(data);
      });
    });
  }

  void _addTodo() {
    setState(() {
      Map<String, dynamic> newToDo = Map();
      newToDo["title"] = _controllerTodo.text;
      _controllerTodo.text = "";
      newToDo["ok"] = false;
      _toDoList.add(newToDo);
      _saveData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(" Lista de tarefas "),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
              padding: EdgeInsets.fromLTRB(17, 1, 7, 1),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _controllerTodo,
                      decoration: InputDecoration(
                          labelText: "Nova tarefa",
                          labelStyle: TextStyle(
                              fontSize: 12, color: Colors.blueAccent)),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _addTodo,
                    child: Text("ADD",
                        selectionColor: Colors.blueAccent,
                        style: TextStyle(color: Colors.white, fontSize: 12)),
                  )
                ],
              )),
          Expanded(
              child: RefreshIndicator(
                  onRefresh: _refresh,
                   child: ListView.builder(
                          padding: EdgeInsets.only(top: 10),
                          itemCount: _toDoList.length,
                          itemBuilder: buildItem,)
          )),
        ],
      ),
    );
  }



  Widget buildItem (BuildContext context,int index) {
    return Dismissible(

      key: Key(DateTime.now().microsecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(-0.9, 0),
          child: Icon(Icons.delete, color: Colors.white,),
        )
      ),
        direction: DismissDirection.startToEnd,
        child: CheckboxListTile(
          title: Text(_toDoList[index]["title"]),
          value: _toDoList[index]["ok"],
          secondary: CircleAvatar(
            child:
            Icon(_toDoList[index]["ok"] ? Icons.check : Icons.error),
          ),
          onChanged: (c) {
            setState(() {
              _toDoList[index]["ok"] = c;
              _saveData();
            });
          },
        ),
      onDismissed: (direction){

        setState(() {
          _lastRemoved= Map.from(_toDoList[index]);
          _lastRemovedPos = index;
          _toDoList.removeAt(index);
          _saveData();

          final snack = SnackBar(
              content: Text("Tarefa \"${_lastRemoved["title"]}\" foi removida "),
            action: SnackBarAction(label: "Desfazer",
                onPressed: (){
              setState(() {
                _toDoList.insert(_lastRemovedPos,_lastRemoved);
                _saveData();
              });
                }),
              duration: Duration(seconds: 3),
          );
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(snack);

        });
      },
    );
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future<File> _saveData() async {
    String data = json.encode(_toDoList);
    final file = await _getFile();
    print("SALVOOOOOOOU");
    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      print("NÃO SALVOOOU");
      print(e);
      return null;
    }
  }


}
