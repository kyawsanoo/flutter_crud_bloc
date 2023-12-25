import 'package:flutter_app_bloc/models/error_response.dart';
import 'package:flutter_app_bloc/repositories/todo_repository.dart';
import 'package:flutter_app_bloc/models/data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'edit_todo_event.dart';
import 'edit_todo_state.dart';

class EditTodoBloc extends Bloc<EditTodoEvent, EditTodoState> {

  final TodoRepository repository;

  EditTodoBloc({required this.repository}) : super(const EditTodoState()){

    on<UpdateButtonClickEvent>(_mapUpdateButtonClickedEventToState);

  }


  void _mapUpdateButtonClickedEventToState( UpdateButtonClickEvent event, Emitter<EditTodoState> emit) async{
    try {
      emit(state.copyWith(status: EditTodoStatus.loading));
      dynamic response = await repository.editTodo(event.todoId, event.completed);
      if(response is Data? ){
        final Data? todo = response;
        if(todo!=null){
          emit(state.copyWith(
            status: EditTodoStatus.success,
            newTodo: todo,
          ),);
        }else{
          emit(state.copyWith(status: EditTodoStatus.error));
        }

      }else if(response is TodoResponseError){
        final TodoResponseError editTodoResponseError = response;
        emit(state.copyWith(
          status: EditTodoStatus.error,
          message: editTodoResponseError.errorMessage,
        ),);
      }else if(response is TodoEmptyResponseError){
        emit(state.copyWith(
          status: EditTodoStatus.error,
          message: "response body is empty",
        ),);
      }

    } catch (ex) {
      emit(state.copyWith(status: EditTodoStatus.error, message: ex.toString()));
    }
  }

}