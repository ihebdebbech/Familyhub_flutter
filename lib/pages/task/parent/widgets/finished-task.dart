import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/task.dart';

class FinishedTaskWidget extends StatelessWidget {
  final Task task;

  FinishedTaskWidget({required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 30),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    task.title,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Completed',
              style: TextStyle(fontSize: 16, color: Colors.green),
            ),
            Divider(color: Colors.grey[300]),
            SizedBox(height: 8),
            Text(
              'Description: ${task.description}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Amount: ${task.amount.toString()}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Deadline: ${task.deadline}',
              style: TextStyle(fontSize: 18, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}