class TodoResponseError implements Exception {
  final String errorMessage;
  TodoResponseError(this.errorMessage);
}

class TodoEmptyResponseError implements Exception {}
