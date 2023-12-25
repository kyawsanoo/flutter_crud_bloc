import 'package:equatable/equatable.dart';
import 'package:flutter_app_bloc/models/data.dart';

enum CreateTodoStatus { initial, success, error, loading }

extension CreateTodoStatusX on CreateTodoStatus {
  bool get isInitial => this == CreateTodoStatus.initial;
  bool get isSuccess => this == CreateTodoStatus.success;
  bool get isError => this == CreateTodoStatus.error;
  bool get isLoading => this == CreateTodoStatus.loading;
}

class CreateTodoState extends Equatable {

  final Data? todo;
  final CreateTodoStatus status;
  final String? message;

  const CreateTodoState({this.status = CreateTodoStatus.initial, this.todo, this.message });

  @override
  List<Object?> get props => [status, todo, message];

  CreateTodoState copyWith({
    Data? newTodo,
    CreateTodoStatus? status,
    String? message
  }) {
    return CreateTodoState(
      todo: newTodo ?? todo,
      status: status ?? this.status,
      message: message ?? this.message
    );
  }
}

