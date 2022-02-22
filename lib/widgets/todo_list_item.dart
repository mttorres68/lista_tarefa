import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:lista_tarefa/modelos/todos.dart';

class TodoListItem extends StatelessWidget {
  const TodoListItem({ 
    Key? key, 
    required this.todo,
    required this.onDelete,
  }) : super(key: key);

  final Todo todo;
  final Function(Todo) onDelete;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Slidable(        
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xff6F4678), 
            borderRadius: BorderRadius.circular(12)
          ),
          //margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(8),     
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children:[
              Text(
                DateFormat('dd/MM/yyyy - HH:mm').format(todo.dateTime),
                //todo.dateTime.toString(),
                style:const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400
                ),
              ),
              Text(
                todo.title,
                style:const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.amber
                ),
              ),
            ],
          ),  
        ),
        endActionPane: 
        ActionPane(
            extentRatio: 0.15,
            motion: const StretchMotion(),
            children: [      
              SlidableAction(
                onPressed: (context) {
                  onDelete(todo);
                },
                flex: 2,
                backgroundColor: Color(0xFFFE4A49),
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Deletar',             
            ),
          ],
        )
      ),
    );
  }

  

}