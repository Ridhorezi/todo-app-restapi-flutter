import 'package:flutter/material.dart';
import 'package:todo_app_restapi/services/todo_service.dart';
import 'package:todo_app_restapi/utils/snackbar_helper.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Todo'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: 'Title'),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(hintText: 'Description'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 100,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: submitData,
              icon: const Icon(
                Icons.add_outlined,
                color: Colors.white,
                size: 24.0,
              ),
              label: const Text('Add'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> submitData() async {
    // Get the data from form
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };

    final isSuccess = await TodoService.createTodo(body);

    // Show success or fail message based on status
    if (isSuccess) {
      titleController.text = '';
      descriptionController.text = '';
      // ignore: use_build_context_synchronously
      showSuccessMessage(context, message: 'Success create todo');
    } else {
      // ignore: use_build_context_synchronously
      showErrorMessage(context, message: 'Ups! Something went wrong.');
    }
  }
}
