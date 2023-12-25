import 'package:equatable/equatable.dart';
import 'package:flutter_app_bloc/models/data.dart';

enum EditTodoStatus { initial, success, error, loading }

extension EditTodoStatusX on EditTodoStatus {
  bool get isInitial => this == EditTodoStatus.initial;
  bool get isSuccess => this == EditTodoStatus.success;
  bool get isError => this == EditTodoStatus.error;
  bool get isLoading => this == EditTodoStatus.loading;
}

class EditTodoState extends Equatable {

  final Data? todo;
  final EditTodoStatus status;
  final String? message;

  const EditTodoState({this.status = EditTodoStatus.initial, this.todo, this.message });

  @override
  List<Object?> get props => [status, todo, message];

  EditTodoState copyWith({
    Data? newTodo,
    EditTodoStatus? status,
    String? message
  }) {
    return EditTodoState(
      todo: newTodo ?? todo,
      status: status ?? this.status,
      message: message ?? this.message
    );
  }
}

