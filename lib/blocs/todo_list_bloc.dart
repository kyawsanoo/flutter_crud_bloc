import 'package:flutter_app_bloc/models/error_response.dart';
import 'package:flutter_app_bloc/blocs/todo_list_event.dart';
import 'package:flutter_app_bloc/blocs/todo_list_state.dart';
import 'package:flutter_app_bloc/repositories/todo_repository.dart';
import 'package:flutter_app_bloc/models/data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoListBloc extends Bloc<TodoListEvent, TodoListState> {

  final TodoRepository repository;

  TodoListBloc({required this.repository}) : super(const TodoListState()){

    on<TodoListEvent>(_mapGetTodoListToState);

  }


  void _mapGetTodoListToState( TodoListEvent event, Emitter<TodoListState> emit) async{
    try {
      emit(state.copyWith(status: AllTodoListStatus.loading));
      dynamic response = await repository.getTodos();
      if(response is List<Data>? ){
        final List<Data>? todoList = response;
        if(todoList!=null){
          emit(state.copyWith(
            status: AllTodoListStatus.success,
            todos: todoList,
          ),);
        }else{
          emit(state.copyWith(status: AllTodoListStatus.error));
        }

      }else if(response is TodoListResponseError){
        final TodoListResponseError todoListResponseError = response;
        emit(state.copyWith(
          status: AllTodoListStatus.error,
          message: todoListResponseError.errorMessage,
        ),);
      }else if(response is TodoListEmptyResponseError){
        emit(state.copyWith(
          status: AllTodoListStatus.error,
          message: "response body is empty",
        ),);
      }

    } catch (ex) {
      emit(state.copyWith(status: AllTodoListStatus.error, message: ex.toString()));
    }
  }

}