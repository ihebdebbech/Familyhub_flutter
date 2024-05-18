import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/task.dart';
import 'package:flutter_application_1/services/taskService.dart';

class OngoingTaskWidget extends StatefulWidget {
  final Task task;

  OngoingTaskWidget({required this.task});

  @override
  _OngoingTaskWidgetState createState() => _OngoingTaskWidgetState();
}

class _OngoingTaskWidgetState extends State<OngoingTaskWidget> {
  bool _isEditing = false;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _amountController;
  final TaskService _taskService = TaskService();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description);
    _amountController = TextEditingController(text: widget.task.amount.toString());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _showDeleteConfirmationDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this task?'),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text('Delete'),
            onPressed: () async {
              // Call the service to delete the task
              final bool success = await _taskService.deleteTask(widget.task.id);
              print('Delete Task Success: $success');
              if (success) {
                Navigator.of(context).pop();
              } else {
                // Show error message
                // You can show a snackbar or dialog here
                print('Failed to delete task');
              }
            },
          ),
        ],
      );
    },
  );
}


  void _updateTask() async {
    // Prepare the updated task data
    Task updatedTask = Task(
      id: widget.task.id,
      childUsername: widget.task.childUsername,
      parentUsername: widget.task.parentUsername,
      title: _titleController.text,
      description: _descriptionController.text,
      amount: int.parse(_amountController.text),
      deadline: widget.task.deadline,
      status: widget.task.status,
      validationType: widget.task.validationType,
      qcmQuestion: widget.task.qcmQuestion,
      qcmOptions: widget.task.qcmOptions,
      answer: widget.task.answer,
    );

    // Call the service to update the task
    final bool success = await _taskService.updateTask(updatedTask);
    if (success) {
      _toggleEditing(); // Exit editing mode after successful update
    } else {
      // Show error message
      // You can show a snackbar or dialog here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: Icon(Icons.hourglass_empty, color: Colors.orange),
          title: _isEditing
              ? TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'Title',
                  ),
                )
              : Text(widget.task.title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          subtitle: Text('Ongoing', style: TextStyle(color: Colors.orange)),
        ),
        _isEditing
            ? TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                maxLines: null,
              )
            : widget.task.description.isNotEmpty
                ? Text('Description: ${widget.task.description}', style: TextStyle(fontSize: 18))
                : SizedBox(),
        _isEditing
            ? TextField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Amount (\$)',
                ),
                keyboardType: TextInputType.number,
              )
            : widget.task.amount != null
                ? Text('Amount: ${widget.task.amount.toString()}', style: TextStyle(fontSize: 18))
                : SizedBox(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text('Deadline: ${widget.task.deadline}',
              style: TextStyle(fontSize: 18, color: Colors.red)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (_isEditing)
              ElevatedButton(
                onPressed: _updateTask,
                child: Text('Confirm'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              ),
            ElevatedButton(
              onPressed: _isEditing ? null : _toggleEditing,
              child: Text(_isEditing ? 'Cancel' : 'Edit Task'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            ),
            SizedBox(width: 8),
            ElevatedButton(
              onPressed: _showDeleteConfirmationDialog,
              child: Text('Delete'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ],
    );
  }
}