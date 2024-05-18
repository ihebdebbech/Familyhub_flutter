import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/task.dart';
import 'package:flutter_application_1/pages/task/parent/widgets/finished-task.dart';
import 'package:flutter_application_1/pages/task/parent/widgets/ongoing-task.dart';

class TaskDetails extends StatelessWidget {
  final Task task;

  TaskDetails({required this.task});

  @override
  Widget build(BuildContext context) {
    final bool isFinished = task.status;

    return Scaffold(
      appBar: AppBar(
        title: Text(task.title),
        backgroundColor:
            const Color.fromARGB(255, 231, 231, 160), // Example color
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isFinished
                ? FinishedTaskWidget(task: task)
                : OngoingTaskWidget(task: task),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}