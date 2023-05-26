
import 'package:flutter/material.dart';
import 'package:flutter_list/pages/todo_list_page.dart';

void main(){
  runApp(myAppList());
}

class myAppList extends StatelessWidget {
  const myAppList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TodolistPage(),
    );
  }
}




