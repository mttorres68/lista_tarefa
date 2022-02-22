import 'package:flutter/material.dart';
import 'package:lista_tarefa/modelos/todos.dart';
import 'package:lista_tarefa/repositorio/todo_repositorio.dart';
import 'package:lista_tarefa/widgets/todo_list_item.dart';

class ListePage extends StatefulWidget {
  ListePage({ Key? key }) : super(key: key);

  @override
  State<ListePage> createState() => _ListePageState();
}

class _ListePageState extends State<ListePage> {
  final TextEditingController todoController = TextEditingController();
  final TodoRepositorio todoRepositorio = TodoRepositorio();

  List<Todo> todos = [];
  Todo? deletedTodo;
  int? deletedTodoPos;
  
  String? errorText;

  @override
  void initState(){
    super.initState();
    
    todoRepositorio.getTodoList().then((value){
      setState(() {
        todos = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(      
      child: Scaffold(
        appBar: AppBar(
          
          backgroundColor: const Color(0xff663b51),
        ),
        backgroundColor: const Color(0xff5c3e62),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(            
                  children: [      
                    Expanded(          
                      child: TextField(
                        controller: todoController,
                        decoration: InputDecoration(                    
                          border: const OutlineInputBorder(),
                          //icon: Icon(Icons.text_fields),
                          labelText: 'Adicione uma tarefa',
                          hintText: 'Estudar flutter', 
                          errorText: errorText,                       
                          labelStyle:const TextStyle(                            
                            color: Colors.amber
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(  
                      onPressed: () {
                        String text = todoController.text;
                        if(text.isEmpty){
                          setState(() {
                            errorText = 'O titulo não pode ser vazio!';
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
                        todoRepositorio.saveTodoList(todos); //salvar modificações feitas 
                      },
                      
                      style: ElevatedButton.styleFrom(   
                        primary: Colors.transparent,
                        onPrimary: const Color(0xffFFF31B),
                        padding: const EdgeInsets.all(10),
                        //shape: StadiumBorder(), botão redondo
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)
                        )
                      ),
                      child:                   
                      const Icon(                      
                        Icons.post_add_rounded,
                        size: 45,
                        color: Colors.amber,
                      )
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for(Todo todo in todos)
                        TodoListItem(
                          todo: todo,
                          onDelete: onDelete,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: Colors.purple,
                          borderRadius: BorderRadius.circular(10),                          
                        ),
                        child: Text(                          
                          'Você possui ${todos.length} tarefas pendente',
                          style:const  TextStyle(
                            color: Color(0xffFFF31B),                            
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8,),
                    ElevatedButton(
                      onPressed: confirDeleted,
                      style: ElevatedButton.styleFrom(
                        onSurface: Colors.red,
                        elevation: 2,                                 
                        primary: Colors.transparent,
                        onPrimary: const Color(0xffFFF31B),
                        padding: const EdgeInsets.all(13)
                      ),
                      //onPressed:() {},
                      child: const Text(
                        'Limpar Tudo',
                        style: TextStyle(
                          color: Colors.amber,
                        ),
                      ) ,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void onDelete(Todo todo){
    deletedTodo = todo;
    deletedTodoPos = todos.indexOf(todo);

    setState(() {
      todos.remove(todo);
    });
    todoRepositorio.saveTodoList(todos);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
        Text(
          'Tarefa ${todo.title} foi removida com sucesso',
          style: const TextStyle(
            color: Color(0xffFFF31B),
            fontSize: 12
          ),
        ),
        backgroundColor: Colors.transparent,
        action: SnackBarAction(
          label: 'Desfazer',
          textColor: Colors.amber,
          onPressed: () {
            setState(() {
              todos.insert(deletedTodoPos!, deletedTodo!);
            });
            todoRepositorio.saveTodoList(todos);
          },          
        ),
        duration: const Duration(seconds: 2),                
      ),
    );
  }

  void confirDeleted(){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Limpar Tudo?'),
        content: Text('Você tem certeza que deseja apagar todas as tarefas?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              primary: const Color(0xff5c3e62)
            ), 
            child: const Text(
              'Cancelar'

            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              deletedTudo();
            }, 
            style: TextButton.styleFrom(
              primary: Colors.red
            ), 
            child: const Text(
              'Confirmar'
            )
          ),
        ],
      ),
    );
  }

  void deletedTudo() {
    setState(() {
      todos.clear();
    });
    todoRepositorio.saveTodoList(todos);
    
  }

}