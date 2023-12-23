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

    return Uri.parse('$baseUrl/$url');
  }

  Future<dynamic> getAllTodoList() async {
    try {
      var response = await http.get(getUrl(url: 'todos'));
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final responseBody = json.decode(response.body);
          TodoListApiResponse todoListApiResponse = TodoListApiResponse
              .fromJson(
              responseBody);
          if (kDebugMode) {
            print("response: $response");
            print("TodoListApiResponse: ${todoListApiResponse.toJson()}");
          }
          return todoListApiResponse.data;
        } else {
          if (kDebugMode) {
            print('TodoList Api Error Occurred: error code: ${response
                .statusCode}');
          }
          return TodoListEmptyResponseError();
        }
      }else{
        return TodoListResponseError("status code: ${response.statusCode}");
      }
    }catch(ex){
      if (kDebugMode) {
        print('TodoList api Exception Occurred: $ex');
      }
      return TodoListResponseError("exception: ${ex.toString()}");
    }
  }

/*Future<Data> getDataById(String id) async {
    var response = await http.get("$baseUrl/Datas/$id?$apiKey");
    var jsonData = json.decode(response.body);
    Data Data = Data.fromJson(jsonData);
    return Data;
  }

  Future<bool> createData(Data Data) async {
    var response = await http.post(
      "$baseUrl/Datas?$apiKey",
      headers: {"Content-Type": "application/json"},
      body: json.encode(
        Data.toJson(),
      ),
    );
    return response.statusCode == 200;
  }

  Future<bool> updateData(Data Data) async {
    var response = await http.put(
      "$baseUrl/Datas/${Data.id}?$apiKey",
      headers: {"Content-Type": "application/json"},
      body: json.encode(Data.toJson()),
    );
    return response.statusCode == 200;
  }

  Future<bool> deleteData(String id) async {
    var response = await http.delete("$baseUrl/Datas/$id?$apiKey");
    return response.statusCode == 200;
  }*/
}