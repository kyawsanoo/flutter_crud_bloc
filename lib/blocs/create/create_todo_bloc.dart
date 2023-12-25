import 'package:flutter_app_bloc/models/error_response.dart';
import 'package:flutter_app_bloc/repositories/todo_repository.dart';
import 'package:flutter_app_bloc/models/data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'create_todo_event.dart';
import 'create_todo_state.dart';


class CreateTodoBloc extends Bloc<CreateButtonClickEvent, CreateTodoState> {

  final TodoRepository repository;

  CreateTodoBloc({required this.repository}) : super(const CreateTodoState()){

    on<CreateButtonClickEvent>(_mapCreateTodoEventToState);

  }


  void _mapCreateTodoEventToState( CreateButtonClickEvent event, Emitter<CreateTodoState> emit) async{
    try {
      emit(state.copyWith(status: CreateTodoStatus.loading));
      dynamic response = await repository.createTodo(event.todoName);
      if(response is Data? ){
        final Data? todo = response;
        if(todo!=null){
          emit(state.copyWith(
            status: CreateTodoStatus.success,
            newTodo: todo,
          ),);
        }else{
          emit(state.copyWith(status: CreateTodoStatus.error));
        }

      }else if(response is TodoResponseError){
        final TodoResponseError editTodoResponseError = response;
        emit(state.copyWith(
          status: CreateTodoStatus.error,
          message: editTodoResponseError.errorMessage,
        ),);
      }else if(response is TodoEmptyResponseError){
        emit(state.copyWith(
          status: CreateTodoStatus.error,
          message: "response body is empty",
        ),);
      }

    } catch (ex) {
      emit(state.copyWith(status: CreateTodoStatus.error, message: ex.toString()));
    }
  }

}