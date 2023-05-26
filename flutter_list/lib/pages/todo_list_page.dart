import 'package:flutter/material.dart';
import 'package:flutter_list/models/todo.dart';
import 'package:flutter_list/repositories/todo_repository.dart';

import '../widgets/todo_list_item.dart';


class TodolistPage extends StatefulWidget {
    TodolistPage({Key? key}) : super(key: key);

  @override
  State<TodolistPage> createState() => _TodolistPageState();
}

class _TodolistPageState extends State<TodolistPage> {


  final TextEditingController todoController = TextEditingController();
  final TodoRepository todoRepository =  TodoRepository();

  List<Todo> todos = [];

  Todo? deleteTodo;
  int? deleteTodoPos;
  String? errorText;



  @override
  void initState() {
    super.initState();

    todoRepository.getTodoList().then((value) {

      setState(() {
        todos=value;
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                     Expanded(
                       child: TextField(
                         controller: todoController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Adicione uma tarefa',
                          hintText: 'Ex. Estudar Flutter',
                          errorText: errorText,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xff00d7f3),
                              width: 3,

                            )
                          ),
                            labelStyle: TextStyle(
                              color: Color(0xff00d7f3),
                            )



                        ),
                    ),
                     ),
                    SizedBox(width: 8),
                    ElevatedButton(
                        onPressed: () {
                          String text = todoController.text;

                          if(text.isEmpty){
                            setState(() {

                            errorText='O campo não pode ficar vazio';
                            });
                            return;

                          }

                          setState(() {
                            Todo newTodo = Todo(
                              title: text,
                              dateTime: DateTime.now(),

                            );
                            todos.add(newTodo);
                            errorText = null;
                          });
                          todoController.clear();
                          todoRepository.saveTodoList(todos);

                        },
                        style: ElevatedButton.styleFrom(
                          //fixedSize: Size(10,10),
                          backgroundColor: Color(0xff00d7f3),
                          padding: EdgeInsets.all(14),

                        ),
                        child: Icon( Icons.add, size: 30,),
                        //Text('+', style: TextStyle(fontSize: 30),)



                    )

                  ],
                ),
                SizedBox(height: 40),

                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for(Todo todo in todos )
                        TodoListItem(
                          todo: todo,
                          onDelete: onDelete,

                        ),
                    ],


                  ),
                ),




                SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                        child:Text('Voce possui ${todos.length} tarefas pendentes')
                    ),

                    SizedBox(width: 8),

                    ElevatedButton(
                        onPressed: showDeleteTodosConfimationDialog,
                        style: ElevatedButton.styleFrom(
                       backgroundColor: Color(0xff00d7f3),
                        padding: EdgeInsets.all(14)
                        ),
                        child: Text('limpar tudo')),

                  ],
                )
              ],
            ),
          ),

        )

      ),
    );
  }

  void onDelete(Todo todo){
    deleteTodo = todo;
    deleteTodoPos = todos.indexOf(todo);

    setState(() {
      todos.remove(todo);
    });
    todoRepository.saveTodoList(todos);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tarefa: ${todo.title} foi removida! ',style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
            action: SnackBarAction(
              label: 'Desfazer',
              textColor: const Color(0xff00d7f3),
              onPressed: (){
                setState(() {
                  todos.insert(deleteTodoPos!, deleteTodo!);
                });

                todoRepository.saveTodoList(todos);

              },
            ),
            duration: const Duration(seconds: 5),
        )

    );

  }

  void showDeleteTodosConfimationDialog(){
    showDialog(context: context, builder: (context)=> AlertDialog(
      title: Text('Limpar todas as tarefas? '),
      content: Text('Você tem certeza disso?'),
      actions: [
        TextButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
            child: Text('Cancelar')

        ),

        TextButton(
            onPressed: (){
              deleteAllTodos();

            },
            style: TextButton.styleFrom(primary: Colors.red),
            child: Text('Limpar tudo')

        )

      ],


    ),
    );



  }
  void deleteAllTodos(){
    setState(() {
      todos.clear();
    });
    todoRepository.saveTodoList(todos);

  }
  

}
