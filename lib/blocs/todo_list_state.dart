import 'package:equatable/equatable.dart';
import 'package:flutter_app_bloc/models/data.dart';

enum AllTodoListStatus { initial, success, error, loading }

extension AllTodoListStatusX on AllTodoListStatus {
  bool get isInitial => this == AllTodoListStatus.initial;
  bool get isSuccess => this == AllTodoListStatus.success;
  bool get isError => this == AllTodoListStatus.error;
  bool get isLoading => this == AllTodoListStatus.loading;
}

class TodoListState extends Equatable {

  final List<Data>? todoList;
  final AllTodoListStatus status;
  final String? message;

  const TodoListState({this.status = AllTodoListStatus.initial, this.todoList, this.message });

  @override
  List<Object?> get props => [status, todoList, message];

  TodoListState copyWith({
    List<Data>? todos,
    AllTodoListStatus? status,
    String? message
  }) {
    return TodoListState(
      todoList: todos ?? todoList,
      status: status ?? this.status,
      message: message ?? this.message
    );
  }
}


/*
https://medium.com/flutter-community/flutter-bloc-for-beginners-839e22adb9f5
* */

