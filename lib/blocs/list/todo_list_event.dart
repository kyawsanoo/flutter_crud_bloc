import 'package:equatable/equatable.dart';

abstract class TodoListEvent extends Equatable {
  const TodoListEvent();
}

class FetchTodoList extends TodoListEvent {
  const FetchTodoList();

  @override
  List<Object> get props => [];
}
