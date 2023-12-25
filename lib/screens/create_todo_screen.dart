import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/create/create_todo_bloc.dart';
import '../blocs/create/create_todo_event.dart';
import '../blocs/create/create_todo_state.dart';
import '../widgets/error_widget.dart';


class CreateTodoScreen extends StatefulWidget {

  const CreateTodoScreen({super.key});

  @override
  State<CreateTodoScreen> createState() => _CreateTodoScreenState();

}

class _CreateTodoScreenState extends State<CreateTodoScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
          appBar: AppBar(
            title: Text("Create New", style: const TextStyle(
              fontSize: 18,
              color: Colors.black87,
            ),),
          ),
          body: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20.0, vertical: 30),
              child:
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Enter todo name',
                      ),
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Can\'t be empty';
                        }
                        if (text.length < 4) {
                          return 'Too short';
                        }
                        return null;
                      },
                      onChanged: (text) => setState(() => _name = text),
                    ),
                    const SizedBox(height: 20,),
                    SizedBox(width: 200,
                      child:
                      BlocListener<CreateTodoBloc, CreateTodoState>(
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
                                content: Text("Create new todo successfully.", style: TextStyle(fontSize: 18,
                                  color: Colors.white,),),
                              ));
                              Navigator.pop(context, true);//true for isCompleteUpdated bool argument to list screen
                            }

                          },
                          child:
                          ElevatedButton(
                            onPressed: _submit,
                            child: Text(
                              'Create',
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyMedium,
                            ),
                          ),
                      )
                    )
                    ],
                ),
              )

          )

      );

  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      context.read<CreateTodoBloc>().add(CreateButtonClickEvent(todoName: _name));
    }else{
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(
        content: Text("Enter todo name.", style: TextStyle(fontSize: 18,
          color: Colors.white,),),
      ));

    }
  }


}
