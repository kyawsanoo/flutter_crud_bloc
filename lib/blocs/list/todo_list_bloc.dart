import 'package:flutter_app_bloc/blocs/list/todo_list_event.dart';
import 'package:flutter_app_bloc/blocs/list/todo_list_state.dart';
import 'package:flutter_app_bloc/models/error_response.dart';
import 'package:flutter_app_bloc/repositories/todo_repository.dart';
import 'package:flutter_app_bloc/models/data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoListBloc extends Bloc<TodoListEvent, TodoListState> {

  final TodoRepository repository;

  TodoListBloc({required this.repository}) : super(const TodoListState()){

    on<TodoListEvent>(_mapGetTodoListEventToState);

  }


  void _mapGetTodoListEventToState( TodoListEvent event, Emitter<TodoListState> emit) async{
    try {
      emit(state.copyWith(status: TodoListStatus.loading));
      dynamic response = await repository.getTodos();
      if(response is List<Data>? ){
        final List<Data>? todoList = response;
        if(todoList!=null){
          emit(state.copyWith(
            status: TodoListStatus.success,
            todos: todoList,
          ),);
        }else{
          emit(state.copyWith(status: TodoListStatus.error));
        }

      }else if(response is TodoResponseError){
        final TodoResponseError todoListResponseError = response;
        emit(state.copyWith(
          status: TodoListStatus.error,
          message: todoListResponseError.errorMessage,
        ),);
      }else if(response is TodoEmptyResponseError){
        emit(state.copyWith(
          status: TodoListStatus.error,
          message: "response body is empty",
        ),);
      }

    } catch (ex) {
      emit(state.copyWith(status: TodoListStatus.error, message: ex.toString()));
    }
  }

}