import 'package:flutter_app_bloc/service/todo_service.dart';

import '../models/data.dart';

class TodoRepository {

  const TodoRepository({
    required this.service,
  });

  final TodoService service;

  Future<dynamic> getTodos() async {
    return service.getAllTodoList();
  }


}
