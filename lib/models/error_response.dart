class TodoListResponseError implements Exception {
  final String errorMessage;
  TodoListResponseError(this.errorMessage);
}

class TodoListEmptyResponseError implements Exception {}
