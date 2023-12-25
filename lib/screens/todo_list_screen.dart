import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_bloc/blocs/delete/delete_todo_event.dart';
import 'package:flutter_app_bloc/blocs/delete/delete_todo_state.dart';
import 'package:flutter_app_bloc/screens/create_todo_screen.dart';
import 'package:flutter_app_bloc/screens/edit_todo_screen.dart';
import 'package:flutter_app_bloc/widgets/error_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/delete/delete_todo_bloc.dart';
import '../blocs/list/todo_list_bloc.dart';
import '../blocs/list/todo_list_event.dart';
import '../blocs/list/todo_list_state.dart';
import '../models/data.dart';


class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print('initState');
    }
  }

  @override
  Widget build(BuildContext context) {
    return
      BlocBuilder<TodoListBloc, TodoListState>(
          builder: (context, state){
                return Scaffold(
                        appBar: AppBar(
                          title: const Text(
                            'Todo App',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        body: Container(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child:
                            state.status.isLoading?
                                Center(
                              child: Container(
                                child: const CircularProgressIndicator(),
                              ),
                            )
                                :
                            state.status.isError?
                            TodoListErrorWidget(message: state.message,):
                            state.todoList != null &&
                                state.todoList!.isNotEmpty
                                ? RefreshIndicator(
                                onRefresh: _pullRefresh,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: state.todoList!.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                        child: Column(
                                          children: [
                                            ListTile(
                                              title: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    "Name: ${state.todoList![index]
                                                        .todoName!}",
                                                    textDirection: TextDirection.ltr,
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                    "isComplete: ${state.todoList![index]
                                                        .isComplete == null
                                                        ? "not known"
                                                        : state.todoList![index]
                                                        .isComplete!}",
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              ),
                                              onTap: () {},
                                            ),
                                            ListTile(
                                                title: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    ButtonTheme(
                                                        minWidth: 100.0,
                                                        height: 50.0,
                                                        child: OutlinedButton(
                                                          style: OutlinedButton.styleFrom(
                                                            foregroundColor: Colors.black,
                                                            side: const BorderSide(
                                                              color: Colors.black45,
                                                            ),
                                                          ),
                                                          onPressed: () async {
                                                            await  Navigator.push(context, MaterialPageRoute(
                                                              builder: (context) => const EditTodoScreen(),
                                                              settings: RouteSettings(
                                                                arguments: state.todoList![index],
                                                              ),
                                                            )
                                                            ).then((isCompleteUpdated){
                                                              if (kDebugMode) {
                                                                print('isCompleteUpdated: $isCompleteUpdated');
                                                              }
                                                              if(isCompleteUpdated!=null && isCompleteUpdated){
                                                                //refresh the page
                                                                _pullRefresh();
                                                              }
                                                            });

                                                          },
                                                          child: const Text(
                                                            "Edit",
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              color: Colors.black87,
                                                            ),
                                                          ),
                                                        )),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    ButtonTheme(
                                                        minWidth: 100.0,
                                                        //height: 50.0,
                                                        child: OutlinedButton(
                                                          style: OutlinedButton.styleFrom(
                                                            foregroundColor: Colors.black,
                                                            side: const BorderSide(
                                                              color: Colors.black45,
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            _dialogBuilder(context, state.todoList![index]);
                                                          },
                                                          child: const Text(
                                                            "Delete",
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              color: Colors.black87,
                                                            ),
                                                          ),
                                                        )),
                                                  ],
                                                ))
                                          ],
                                        ));
                                  },
                                ))
                                : const Center(
                                child: Text("Todo list is empty and create new"))),
                        floatingActionButton: FloatingActionButton(
                          onPressed: () async {
                            await  Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const CreateTodoScreen(),
                            )
                            ).then((isCompleteCreated){
                              if (kDebugMode) {
                                print('isCompleteCreated: $isCompleteCreated');
                              }
                              if(isCompleteCreated!=null && isCompleteCreated){
                                //refresh the page
                                _pullRefresh();
                              }
                            });

                          },
                          child: const Icon(Icons.add),
                        ),
                );
      });
  }

  Future<void> _pullRefresh() async {
    if (kDebugMode) {
      print('refreshing start');
    }
    context.read<TodoListBloc>().add(const FetchTodoList());
  }

  Future<void> _dialogBuilder(BuildContext context, Data todo) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return
          ScaffoldMessenger(child: Builder(builder: (context){
            return Scaffold(
                backgroundColor: Colors.transparent,
                body: AlertDialog(
                  title: const Text('Confirm to delete'),
                  content: const Text(
                      'Are you sure to delete?'

                  ),
                  actions: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(
                        textStyle: Theme.of(context).textTheme.labelLarge,
                      ),
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    BlocListener<DeleteTodoBloc, DeleteTodoState>(
                        listener: (context, state) async {
                          if(state.status.isError){
                            String errMessage = state.message!;
                            if (kDebugMode) {
                              print("Deleting todo Failed $errMessage");
                            }
                            Navigator.of(context).pop();
                          }
                          if(state.status.isSuccess){
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Updated successfully.", style: TextStyle(fontSize: 18,
                                color: Colors.white,),),
                            ));
                            await Future.delayed(const Duration(seconds: 1)).then((value) =>
                                Navigator.of(context).pop()
                            ).then((_){

                            });
                          }

                        },
                        child:
                          BlocBuilder<TodoListBloc, TodoListState>(
                          builder: (context, state){
                                  return
                                      state.status.isLoading?
                                      const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(),)
                                          :
                                            TextButton(
                                                    style: TextButton.styleFrom(
                                                    textStyle: Theme
                                                        .of(context)
                                                        .textTheme
                                                        .labelLarge,
                                                    ),
                                                    child: const Text('Ok'),
                                                    onPressed: () async {
                                                    if (kDebugMode) {
                                                    print("argument todo: ${todo.toJson()}");
                                                    }
                                                    context.read<DeleteTodoBloc>().add(DeleteButtonClickEvent(todoId: todo.todoId!));

                                                    }

                                                );
                          }),


                    )],
                ));

          }));
      },
    );
  }

}
