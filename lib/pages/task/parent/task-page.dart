import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/task.dart';
import 'package:flutter_application_1/pages/task/parent/task-list-item.dart';
import 'package:flutter_application_1/pages/task/parent/widgets/AiQuizDialog.dart';
import 'package:flutter_application_1/pages/task/parent/widgets/add-task.dart';
import 'package:flutter_application_1/services/taskService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TasksPage extends StatefulWidget {
  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final TaskService taskService = TaskService();

  String selectedFilter = 'all'; // To track which filter is currently selected

  late Future<List<Task>> futureTasks = Future.value([]);

@override
void initState() {
  super.initState();
  // Asynchronously get the username and then load tasks
  Future.delayed(Duration.zero, () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Get the stored username with a default fallback value if not found
    String username = prefs.getString('username') ?? 'parentTest';
    // Now you can use the username to load tasks accordingly
    try {
      futureTasks = taskService.getAllTasks(username); // Use the actual username
      // If you need to update the UI based on the loaded tasks, call setState
      setState(() {});
    } catch (error) {
      // Handle the error gracefully
      print('Error loading tasks: $error');
      // Set futureTasks to an empty list to prevent null errors in the FutureBuilder
      futureTasks = Future.value([]);
      // Update the UI
      setState(() {});
    }
  });
}


  Future<void> filterTasks(String filter) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') ?? 'parentTest';
    setState(() {
      selectedFilter = filter;
      futureTasks = filter == 'all'
          ? taskService.getAllTasks(username)
          : filter == 'ongoing'
              ? taskService.getOngoingTasks(username)
              : taskService.getFinishedTasks(username);
    });
  }

  bool isActivated = false;

  void toggleButton() {
  if (isActivated) {
    setState(() {
      isActivated = !isActivated;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Deactivated'),
          duration: Duration(seconds: 2),
        ),
      );
    });
  } else {
    showDialog(
      context: context,
      builder: (BuildContext context) => AiQuizDialog(),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Tasks', style: TextStyle(fontSize: 20)), // Ensures "Tasks" is appropriately styled
            Spacer(), // This pushes everything to the sides
            Text('Quiz with AI', style: TextStyle(fontSize: 14)), // Smaller text on the far right
          ],
        ),
        actions: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: isActivated ? Colors.blue : Colors.white,
              shape: BoxShape.circle,
            ),
            margin: EdgeInsets.only(right: 12),
            child: IconButton(
              iconSize: 40,
              icon: Icon(
                isActivated ? Icons.toggle_on : Icons.toggle_off,
                color: isActivated ? Colors.white : Colors.blue,
              ),
              onPressed: toggleButton,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilterButton(
                  text: 'All',
                  isActive: selectedFilter == 'all',
                  onPressed: () => filterTasks('all'),
                ),
                SizedBox(width: 10),
                FilterButton(
                  text: 'Ongoing',
                  isActive: selectedFilter == 'ongoing',
                  onPressed: () => filterTasks('ongoing'),
                ),
                SizedBox(width: 10),
                FilterButton(
                  text: 'Completed',
                  isActive: selectedFilter == 'completed',
                  onPressed: () => filterTasks('completed'),
                ),
                SizedBox(width: 10),
                // New button for adding tasks
                FilterButton(
                  text: '+',
                  isActive: false, // This button does not represent a filter state
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AddTaskDialog();
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Task>>(
              future: futureTasks,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return TaskListItem(task: snapshot.data![index]);
                    },
                  );
                } else {
                  return Center(child: Text('No tasks found'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}


class FilterButton extends StatelessWidget {
  final String text;
  final bool isActive;
  final VoidCallback onPressed;

  const FilterButton({
    required this.text,
    required this.isActive,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(color: isActive ? Colors.white : Colors.blue),
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.blue,
        backgroundColor: isActive ? Colors.yellow : Colors.white, // Text color
        side: BorderSide(
            color: isActive ? Colors.blue : Colors.yellow,
            width: 2), // Border color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}