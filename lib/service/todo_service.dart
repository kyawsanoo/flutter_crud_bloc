import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_app_bloc/models/error_response.dart';
import 'package:flutter_app_bloc/models/todolist_api_response.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../models/data.dart';

class TodoService {
  TodoService({
    http.Client? httpClient,
    this.baseUrl = 'https://dummyjson.com',
  }) : _httpClient = httpClient ?? http.Client();

  final String baseUrl;
  final Client _httpClient;

  Uri getUrl({
    required String url,
    Map<String, String>? extraParameters,
  }) {
    /*final queryParameters = <String, String>{
      'key': dotenv.get('GAMES_API_KEY')
    };
    if (extraParameters != null) {
      queryParameters.addAll(extraParameters);
    }

    return Uri.parse('$baseUrl/$url').replace(
      queryParameters: queryParameters,
    );*/
    if (kDebugMode) {
      print('api url: $baseUrl/$url');
    }
    return Uri.parse('$baseUrl/$url');
  }

  Future<dynamic> callAllTodoList() async {
    try {
      var response = await http.get(getUrl(url: 'todos'));
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final responseBody = json.decode(response.body);
          TodoListApiResponse todoListApiResponse = TodoListApiResponse
              .fromJson(
              responseBody);
          if (kDebugMode) {
            print("responseBody: $responseBody");
            print("TodoListApiResponse: ${todoListApiResponse.toJson()}");
          }
          return todoListApiResponse.data;
        } else {
          if (kDebugMode) {
            print('TodoList Api Error Occurred: error code: ${response
                .statusCode}');
          }
          return TodoEmptyResponseError();
        }
      }else{
        return TodoResponseError("status code: ${response.statusCode}");
      }
    }catch(ex){
      if (kDebugMode) {
        print('TodoList api Exception Occurred: $ex');
      }
      return TodoResponseError("exception: ${ex.toString()}");
    }
  }

  Future<dynamic> callCreateTodo(String todoName) async {
    if (kDebugMode) {
      print('CreateTodo Api Call Starting ');
    }
    if (kDebugMode) {
      print('CreateTodo Api Call Starting todoName: $todoName');
    }
    dynamic body = jsonEncode({
      "todo": todoName,
      "completed":false,
      "userId":1
    });
    dynamic header = {"Content-Type": "application/json"};
    if (kDebugMode) {
      print('CreateTodo Api Request Body $body');
    }
    try {
      var response = await http.post(getUrl(url: 'todos/add'), body: body, headers: header);
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final responseBody = json.decode(response.body);
          Data editTodo = Data
              .fromJson(
              responseBody);
          if (kDebugMode) {
            print("responseBody: $responseBody");
            print("CreateTodoApiResponse: ${editTodo.toJson()}");
          }
          return editTodo;
        } else {
          if (kDebugMode) {
            print('CreateTodo Api Error Occurred: error code: ${response
                .statusCode}');
          }
          return TodoEmptyResponseError();
        }
      }else{
        return TodoResponseError("CreateTodo Api Response status code: ${response.statusCode}");
      }
    }catch(ex){
      if (kDebugMode) {
        print('CreateTodo api Exception Occurred: $ex');
      }
      return TodoResponseError("exception: ${ex.toString()}");
    }
  }

  Future<dynamic> callUpdateTodo(int todoId, bool completed) async {
    if (kDebugMode) {
      print('UpdateTodo Api Call Starting todoId: $todoId completed: $completed');
    }
    dynamic body = jsonEncode({
      "completed": completed,
    });
    dynamic header = {"Content-Type": "application/json"};
    if (kDebugMode) {
      print('UpdateTodo Api Request Body $body');
    }
    try {
      var response = await http.put(getUrl(url: 'todos/$todoId'), body: body, headers: header);
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final responseBody = json.decode(response.body);
          Data editTodo = Data
              .fromJson(
              responseBody);
          if (kDebugMode) {
            print("responseBody: $responseBody");
            print("EditTodoApiResponse: ${editTodo.toJson()}");
          }
          return editTodo;
        } else {
          if (kDebugMode) {
            print('EditTodo Api Error Occurred: error code: ${response
                .statusCode}');
          }
          return TodoEmptyResponseError();
        }
      }else{
        return TodoResponseError("status code: ${response.statusCode}");
      }
    }catch(ex){
      if (kDebugMode) {
        print('EditTodo api Exception Occurred: $ex');
      }
      return TodoResponseError("exception: ${ex.toString()}");
    }
  }


  Future<dynamic> callDeleteTodo(int todoId) async {
    if (kDebugMode) {
      print('Delete Todo Api Call Starting todoId: $todoId');
    }
    dynamic header = {"Content-Type": "application/json"};
    try {
      var response = await http.delete(getUrl(url: 'todos/$todoId'), headers: header);
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final responseBody = json.decode(response.body);
          Data deleteTodo = Data
              .fromJson(
              responseBody);
          if (kDebugMode) {
            print("Delete Todo responseBody: $responseBody");
            print("DeleteTodoApiResponse: ${deleteTodo.toJson()}");
          }
          return deleteTodo;
        } else {
          if (kDebugMode) {
            print('Delete Todo Api Error Occurred: error code: ${response
                .statusCode}');
          }
          return TodoEmptyResponseError();
        }
      }else{
        return TodoResponseError("delete todo api response status code: ${response.statusCode}");
      }
    }catch(ex){
      if (kDebugMode) {
        print('EditTodo api Exception Occurred: $ex');
      }
      return TodoResponseError("exception: ${ex.toString()}");
    }
  }

}