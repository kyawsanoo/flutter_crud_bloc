import 'package:equatable/equatable.dart';

abstract class EditTodoEvent extends Equatable {
  const EditTodoEvent();
}

class UpdateButtonClickEvent extends EditTodoEvent {
  final int todoId;
  final bool completed;

  const UpdateButtonClickEvent({required this.todoId, required this.completed});

  @override
  List<Object> get props => [todoId, completed];
}