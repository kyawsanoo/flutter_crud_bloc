import 'package:flutter_app_bloc/blocs/delete/delete_todo_event.dart';
import 'package:flutter_app_bloc/blocs/delete/delete_todo_state.dart';
import 'package:flutter_app_bloc/models/error_response.dart';
import 'package:flutter_app_bloc/repositories/todo_repository.dart';
import 'package:flutter_app_bloc/models/data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteTodoBloc extends Bloc<DeleteTodoEvent, DeleteTodoState> {

  final TodoRepository repository;

  DeleteTodoBloc({required this.repository}) : super(const DeleteTodoState()){

    on<DeleteButtonClickEvent>(_mapDeleteButtonClickedEventToState);

  }


  void _mapDeleteButtonClickedEventToState( DeleteButtonClickEvent event, Emitter<DeleteTodoState> emit) async{
    try {
      emit(state.copyWith(status: DeleteTodoStatus.loading));
      dynamic response = await repository.deleteTodo(event.todoId);
      if(response is Data? ){
        final Data? todo = response;
        if(todo!=null){
          emit(state.copyWith(
            status: DeleteTodoStatus.success,
            newTodo: todo,
          ),);
        }else{
          emit(state.copyWith(status: DeleteTodoStatus.error));
        }

      }else if(response is TodoResponseError){
        final TodoResponseError editTodoResponseError = response;
        emit(state.copyWith(
          status: DeleteTodoStatus.error,
          message: editTodoResponseError.errorMessage,
        ),);
      }else if(response is TodoEmptyResponseError){
        emit(state.copyWith(
          status: DeleteTodoStatus.error,
          message: "response body is empty",
        ),);
      }

    } catch (ex) {
      emit(state.copyWith(status: DeleteTodoStatus.error, message: ex.toString()));
    }
  }

}