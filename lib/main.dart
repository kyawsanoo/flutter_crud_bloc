import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_bloc/blocs/todo_list_bloc.dart';
import 'package:flutter_app_bloc/repositories/todo_repository.dart';
import 'package:flutter_app_bloc/screens/todo_list_screen.dart';
import 'package:flutter_app_bloc/service/todo_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/todo_list_event.dart';


void main() {
  Bloc.observer = AppBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
        create: (context) => TodoRepository(service: TodoService()),
        child: MultiBlocProvider(
          providers: [
            BlocProvider<TodoListBloc>(
              create: (context) => TodoListBloc(
                repository: context.read<TodoRepository>(),
              )..add(const FetchTodoList()),
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            routes: {
              '/': (context) => const TodoListScreen(),
            },
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),

          ),
        ));
  }
}

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (bloc is Cubit) {
      if (kDebugMode) {
        print(change);
      }
    }
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    if (kDebugMode) {
      print(transition);
    }
  }
}

