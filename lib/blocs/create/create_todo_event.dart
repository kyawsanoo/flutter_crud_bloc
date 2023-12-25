import 'package:equatable/equatable.dart';

abstract class CreateTodoEvent extends Equatable {
  const CreateTodoEvent();
}

class CreateButtonClickEvent extends CreateTodoEvent {
  final String todoName;
  const CreateButtonClickEvent({required this.todoName});

  @override
  List<Object> get props => [todoName];
}