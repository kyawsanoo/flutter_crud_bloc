import 'package:flutter/material.dart';

class TodoListErrorWidget extends StatefulWidget {
  final String? message;
  const TodoListErrorWidget({Key? key, this.message})
      : super(key: key);

  @override
  State<TodoListErrorWidget> createState() => _TodoListErrorWidget();
}

class _TodoListErrorWidget extends State<TodoListErrorWidget> {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('${widget.message}'),
    );
  }
}
