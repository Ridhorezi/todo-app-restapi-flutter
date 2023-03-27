// ignore: unused_import
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_app_restapi/screens/add_page.dart';
// ignore: unused_import
import 'package:http/http.dart' as http;
import 'package:todo_app_restapi/screens/edit_page.dart';
import 'package:todo_app_restapi/services/todo_service.dart';
import 'package:todo_app_restapi/utils/snackbar_helper.dart';
import 'package:todo_app_restapi/widgets/todo_card.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isLoading = true;
  List items = [];

  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: Visibility(
        visible: isLoading,
        // ignore: sort_child_properties_last
        child: const Center(
          child: CircularProgressIndicator(),
        ),
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
              child: Text(
                'No todo items !',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            child: ListView.builder(
              itemCount: items.length,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final item = items[index] as Map;
                // ignore: unused_local_variable
                final id = item['_id'] as String;
                return TodoCard(
                  index: index,
                  item: item,
                  deleteById: deleteById,
                  navigateEdit: navigateToEditPage,
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToAddPage,
        // ignore: sort_child_properties_last
        child: const Icon(Icons.add),
        backgroundColor: Colors.blueGrey,
      ),
    );
  }

  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(
      builder: (context) => const AddTodoPage(),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> navigateToEditPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => EditTodoPage(todo: item),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> deleteById(String id) async {
    final isSuccess = await TodoService.deleteById(id);

    if (isSuccess) {
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
      // ignore: use_build_context_synchronously
      showSuccessMessage(context, message: 'Successfully deleted data');
    } else {
      // ignore: use_build_context_synchronously
      showErrorMessage(context, message: 'Ups! Something went wrong.');
    }
  }

  Future<void> fetchTodo() async {
    final response = await TodoService.readTodos();

    if (response != null) {
      setState(() {
        items = response;
      });
      // ignore: use_build_context_synchronously
      // showSuccessMessage(context, message: 'Success fetch data');
    } else {
      // ignore: use_build_context_synchronously
      showErrorMessage(context, message: 'Ups! Something went wrong.');
    }
    setState(() {
      isLoading = false;
    });
  }
}
