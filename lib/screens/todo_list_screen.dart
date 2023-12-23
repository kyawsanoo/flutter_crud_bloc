import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_bloc/blocs/todo_list_bloc.dart';
import 'package:flutter_app_bloc/widgets/error_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/todo_list_state.dart';

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

                          },
                          child: const Icon(Icons.add),
                        ),
                );
      });
  }

  Future<void> _pullRefresh() async {

  }
}
