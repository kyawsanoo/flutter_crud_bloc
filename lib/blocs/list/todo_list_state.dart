import 'package:equatable/equatable.dart';
import 'package:flutter_app_bloc/models/data.dart';

enum TodoListStatus { initial, success, error, loading }

extension TodoListStatusX on TodoListStatus {
  bool get isInitial => this == TodoListStatus.initial;
  bool get isSuccess => this == TodoListStatus.success;
  bool get isError => this == TodoListStatus.error;
  bool get isLoading => this == TodoListStatus.loading;
}

class TodoListState extends Equatable {

  final List<Data>? todoList;
  final TodoListStatus status;
  final String? message;

  const TodoListState({this.status = TodoListStatus.initial, this.todoList, this.message });

  @override
  List<Object?> get props => [status, todoList, message];

  TodoListState copyWith({
    List<Data>? todos,
    TodoListStatus? status,
    String? message
  }) {
    return TodoListState(
      todoList: todos ?? todoList,
      status: status ?? this.status,
      message: message ?? this.message
    );
  }
}

