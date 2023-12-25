import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/data.dart';
import '../blocs/edit/edit_todo_bloc.dart';
import '../blocs/edit/edit_todo_event.dart';
import '../blocs/edit/edit_todo_state.dart';
import '../widgets/error_widget.dart';

class EditTodoScreen extends StatefulWidget {

  const EditTodoScreen({super.key});

  @override
  State<EditTodoScreen> createState() => _EditTodoScreenState();

}

class _EditTodoScreenState extends State<EditTodoScreen> {
  final formKey = GlobalKey<FormState>();
  String? selectedValue;
  List<String> selectionList = ["true", "false"];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Data todo = ModalRoute.of(context)!.settings.arguments as Data;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Todo", style: TextStyle(
          fontSize: 18,
          color: Colors.black87,
        ),),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
            child: Form(
              key: formKey,
              child: Column( crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(height: 10,),
                const Text('isComplete', style: TextStyle(fontSize: 14,
                  color: Colors.black87,), ),
                const SizedBox(height: 10,),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: const EdgeInsets.only(right: 10, left: 10),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.0),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.0),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.0),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 1, color: Colors.red),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  elevation: 1,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select';
                    } else {
                      return null;
                    }
                  },
                  isExpanded: true,
                  hint: const Text("Please select"),
                  iconSize: 45,
                  iconEnabledColor: Colors.black,
                  icon: const Icon(
                    Icons.arrow_drop_down_sharp,
                    size: 15,
                  ),
                  value: selectedValue,
                  items:
                  selectionList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                        value: value,
                        child: SizedBox( width: 200, child: Text( value,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black87,
                          ),
                        ),
                        ));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      debugPrint("chosen value: $value");
                      selectedValue = value;
                    });
                  },
                ),
              ],)

            ),
          ),
          SizedBox(
              width: 200,
              child:
          BlocListener<EditTodoBloc, EditTodoState>(
              listener: (context, state) {
                // do stuff here based on BlocA's state
                if(state.status.isLoading) {
                  const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                else if(state.status.isError){
                  TodoListErrorWidget(message: state.message);

                }
                else if(state.status.isSuccess){
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(
                    content: Text("Updated successfully.", style: TextStyle(fontSize: 18,
                      color: Colors.white,),),
                  ));
                  Navigator.pop(context, true);//true for isCompleteUpdated bool argument to list screen
                }

              },
              child: ElevatedButton(
                  onPressed: () async {
                    if (kDebugMode) {
                      print("argument todo: ${todo.toJson()}");
                    }
                    if (formKey.currentState!.validate()) {
                      context.read<EditTodoBloc>().add(UpdateButtonClickEvent(todoId: todo.todoId!, completed: todo.isComplete!));
                    }else{
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(
                        content: Text("Update todo successfully.", style: TextStyle(fontSize: 18,
                          color: Colors.white,),),
                      ));

                    }


                  },
                  child: const Text(
                    "Update",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  )
              ),
              )
          )
        ],
      ),
    );
  }
}
