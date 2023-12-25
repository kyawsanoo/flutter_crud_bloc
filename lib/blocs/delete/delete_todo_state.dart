import 'package:equatable/equatable.dart';
import 'package:flutter_app_bloc/models/data.dart';

enum DeleteTodoStatus { initial, success, error, loading }

extension DeleteTodoStatusX on DeleteTodoStatus {
  bool get isInitial => this == DeleteTodoStatus.initial;
  bool get isSuccess => this == DeleteTodoStatus.success;
  bool get isError => this == DeleteTodoStatus.error;
  bool get isLoading => this == DeleteTodoStatus.loading;
}

class DeleteTodoState extends Equatable {

  final Data? todo;
  final DeleteTodoStatus status;
  final String? message;

  const DeleteTodoState({this.status = DeleteTodoStatus.initial, this.todo, this.message });

  @override
  List<Object?> get props => [status, todo, message];

  DeleteTodoState copyWith({
    Data? newTodo,
    DeleteTodoStatus? status,
    String? message
  }) {
    return DeleteTodoState(
      todo: todo ?? newTodo,
      status: status ?? this.status,
      message: message ?? this.message
    );
  }
}

