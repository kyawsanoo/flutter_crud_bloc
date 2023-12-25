import 'package:equatable/equatable.dart';

abstract class DeleteTodoEvent extends Equatable {
  const DeleteTodoEvent();
}

class DeleteButtonClickEvent extends DeleteTodoEvent {
  final int todoId;

  const DeleteButtonClickEvent({required this.todoId});

  @override
  List<Object> get props => [todoId];
}