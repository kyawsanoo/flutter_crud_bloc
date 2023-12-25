import 'package:flutter_app_bloc/service/todo_service.dart';

import '../models/data.dart';

class TodoRepository {

  const TodoRepository({
    required this.service,
  });

  final TodoService service;

  Future<dynamic> getTodos() async {
    return service.callAllTodoList();
  }

  Future<dynamic> createTodo(String todoName) async {
    return service.callCreateTodo(todoName);
  }

  Future<dynamic> editTodo(int todoId, bool completed) async {
    return service.callUpdateTodo(todoId, completed);
  }

  Future<dynamic> deleteTodo(int todoId) async {
    return service.callDeleteTodo(todoId);
  }

}
