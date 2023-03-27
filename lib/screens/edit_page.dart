import 'package:flutter/material.dart';
import 'package:todo_app_restapi/services/todo_service.dart';
import 'package:todo_app_restapi/utils/snackbar_helper.dart';

class EditTodoPage extends StatefulWidget {
  final Map? todo;
  const EditTodoPage({super.key, this.todo});

  @override
  State<EditTodoPage> createState() => _EditTodoPageState();
}

class _EditTodoPageState extends State<EditTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Todo',
        ),
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
              onPressed: updateData,
              icon: const Icon(
                Icons.edit_note_outlined,
                color: Colors.white,
                size: 24.0,
              ),
              label: const Text('Update'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> updateData() async {
    final todo = widget.todo;

    if (todo == null) {
      showErrorMessage(context, message: 'Ups! Cannot call data.');
      return;
    }

    final id = todo['_id'];
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };

    final isSuccess = await TodoService.updateTodo(id, body);

    // Show success or fail message based on status
    if (isSuccess) {
      // ignore: use_build_context_synchronously
      showSuccessMessage(context, message: 'Succes update data');
    } else {
      // ignore: use_build_context_synchronously
      showErrorMessage(context, message: 'Ups! Something went wrong.');
    }
  }
}
