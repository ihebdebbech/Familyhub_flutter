import 'dart:convert';
import 'package:flutter_application_1/models/addTask.dart';
import 'package:http/http.dart' as http;
import '../models/task.dart';

class TaskService {
  // Base URL for the tasks endpoint
// Base URL for the tasks endpoint
  final String baseUrl = 'https://backend-secure-payment-for-kids.onrender.com/task';

  Future<List<Task>> getAllTasks(String parentUsername) async {
    final url = Uri.parse('$baseUrl/allTasks')
        .replace(queryParameters: {'parentUsername': parentUsername});
    print('Request URL: $url'); // Print URL for debugging
    return await _fetchTasks(url);
  }

  Future<List<Task>> getOngoingTasks(String parentUsername) async {
    final url = Uri.parse('$baseUrl/ongoing')
        .replace(queryParameters: {'parentUsername': parentUsername});
    return await _fetchTasks(url);
  }

  Future<List<Task>> getFinishedTasks(String parentUsername) async {
    final url = Uri.parse('$baseUrl/finished')
        .replace(queryParameters: {'parentUsername': parentUsername});
    return await _fetchTasks(url);
  }

  Future<bool> addNewTask(AddTask addTaskData) async {
    final url = Uri.parse('$baseUrl/add');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(addTaskData.toJson()),
      );

      if (response.statusCode == 201) {
        // Assuming a successful creation returns status code 201
        return true;
      } else {
        print('Failed to add task: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error adding task: $e');
      return false;
    }
  }

  // Private helper method to reduce code duplication
  Future<List<Task>> _fetchTasks(Uri url) async {
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> tasksJson = json.decode(response.body);
        List<Task> tasks =
            tasksJson.map((json) => Task.fromJson(json)).toList();
        return tasks;
      } else {
        print('Failed to load tasks: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching tasks: $e');
      return [];
    }
  }

  Future<bool> updateTask(Task task) async {
    final url = Uri.parse('$baseUrl/update/${task.id}');
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(task.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to update task: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error updating task: $e');
      return false;
    }
  }

  Future<bool> deleteTask(String taskId) async {
    final url = Uri.parse('$baseUrl/delete/$taskId');
    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('Task deleted successfully');
        return true;
      } else {
        print('Failed to delete task: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error deleting task: $e');
      return false;
    }
  }

  Future<Map<String, List<String>>> getChildrenUsernames(
      String parentUsername) async {
    final url = Uri.parse('$baseUrl/getKids');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'parentUsername': parentUsername}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey('childUsernames') &&
            data.containsKey('activated')) {
          List<String> childUsernames =
              List<String>.from(data['childUsernames']);
          List<String> activated = List<String>.from(data['activated']);
          return {'childUsernames': childUsernames, 'activated': activated};
        } else {
          throw FormatException('Invalid response format');
        }
      } else {
        throw Exception(
            'Failed to get children usernames: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching children usernames: $e');
      throw Exception('Failed to fetch children usernames: $e');
    }
  }

  Future<bool> activateAi(List<String> childUsernames, String parentUsername,
      int age, int amount) async {
    final url = Uri.parse('$baseUrl/activateAi');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'childUsernames': childUsernames,
          'parentUsername': parentUsername,
          'age': age,
          'amount': amount
        }),
      );

      if (response.statusCode == 200) {
        print(
            'AI Activation Response: ${response.body}'); // Optionally log the response or handle it as needed
        return true;
      } else {
        print('Failed to activate/deactivate AI: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error when trying to activate/deactivate AI: $e');
      return false;
    }
  }
}
