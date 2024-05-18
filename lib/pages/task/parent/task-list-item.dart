import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/task.dart';
import 'package:flutter_application_1/pages/task/parent/task-details.dart';

class TaskListItem extends StatelessWidget {
  final Task task;

  TaskListItem({required this.task});

  @override
  Widget build(BuildContext context) {
    final daysLeft = task.deadline.difference(DateTime.now()).inDays;
    String deadlineText = '';

    // If task is not completed, calculate deadline text.
    if (!task.status) {
      if (daysLeft < 0) {
        deadlineText = "Deadline has passed";
      } else if (daysLeft == 0) {
        deadlineText = "Deadline is today";
      } else {
        deadlineText = '$daysLeft days left';
      }
    } // No else part needed as we don't want to show any deadline text for completed tasks.

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TaskDetails(task: task),
          ),
        );
      },
      child: Card(
        elevation: 4,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.yellowAccent, width: 2),
        ),
        child: ListTile(
          leading: task.status
              ? Icon(Icons.check_circle_outline, color: Colors.blue)
              : Icon(Icons.cancel, color: Colors.red),
          title: Text(
            task.title,
            style: TextStyle(color: Colors.blue),
          ),
          trailing: Text(
            deadlineText,
            style: TextStyle(color: daysLeft < 0 ? Colors.grey : Colors.red, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}