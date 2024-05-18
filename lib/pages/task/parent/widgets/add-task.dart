import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/addTask.dart';
import 'package:flutter_application_1/services/taskService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddTaskDialog extends StatefulWidget {
  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  int amount = 0;
  String deadlineType = 'days';
  String validationType = 'none';
  String? selectedChildUsername;
  List<String> childUsernames = [];

  final amountController = TextEditingController();
  final deadlineController = TextEditingController();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final List<TextEditingController> answerControllers = List.generate(4, (_) => TextEditingController());
  int? selectedAnswerIndex;
  int currentStep = 1;
  final TaskService taskService = TaskService(); // Initialize your TaskService

  @override
  void initState() {
    super.initState();
    _loadChildUsernames();
  }

  _loadChildUsernames() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String parentUsername = prefs.getString('username') ?? '';
  var taskService = TaskService();
  Map<String, List<String>> data = await taskService.getChildrenUsernames(parentUsername);
  setState(() {
    childUsernames = data['childUsernames'] ?? []; // Ensure this key matches with what's returned from the service
    if (childUsernames.isNotEmpty) {
      selectedChildUsername = childUsernames[0]; // Automatically select the first child if available
    }
  });
}


  void _increaseAmount() {
    setState(() {
      amount++;
      amountController.text = amount.toString();
    });
  }

  void _decreaseAmount() {
    setState(() {
      amount = amount > 0 ? amount - 1 : 0;
      amountController.text = amount.toString();
    });
  }

  Widget _buildDropdownChildSelector() {
  return Expanded(
    child: DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Select Child',
        labelStyle: TextStyle(color: Colors.blue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blue, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blue, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Color.fromARGB(255, 184, 183, 187), width: 2.5),
        ),
        fillColor: Colors.white,
        filled: true,
      ),
      isExpanded: true,
      value: selectedChildUsername,
      onChanged: (String? newValue) {
        setState(() {
          selectedChildUsername = newValue;
        });
      },
      items: childUsernames.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: TextStyle(color: Colors.blue)),
        );
      }).toList(),
      icon: Icon(Icons.arrow_drop_down_circle, color: Colors.blue),
      iconSize: 24,
      style: TextStyle(color: Colors.blue, fontSize: 16),
      dropdownColor: Colors.white,
    ),
  );
}



  Widget _buildValidationInput() {
    switch (validationType) {
      case 'qcm':
        return Column(
          children: List.generate(4, (index) => Row(
            children: [
              Expanded(
                child: TextField(
                  controller: answerControllers[index],
                  decoration: InputDecoration(labelText: 'Answer ${index + 1}'),
                ),
              ),
              Checkbox(
                value: selectedAnswerIndex == index,
                onChanged: (bool? value) {
                  setState(() {
                    if (value!) {
                      selectedAnswerIndex = index;
                    } else {
                      selectedAnswerIndex = null;
                    }
                  });
                },
              ),
            ],
          )),
        );
      case 'question':
        return TextField(
          controller: answerControllers[0], // Use the first answer controller for 'question' type
          decoration: InputDecoration(labelText: 'Answer'),
        );
      default:
        return SizedBox();
    }
  }

  void _onNextPressed() async {
    if (currentStep == 1) {
      setState(() {
        currentStep = 2;
      });
    } else {
      // Formatting the QCM answers if validation type is 'qcm'
      String qcmAnswersFormatted = '';
      if (validationType == 'qcm') {
        qcmAnswersFormatted = answerControllers
            .asMap()
            .entries
            .map((entry) => entry.key == selectedAnswerIndex ? "[${entry.value.text}]" : entry.value.text)
            .join('_');
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String username = prefs.getString('username') ?? 'parentTest';

      String childusername = selectedChildUsername ?? '';

      // Create the AddTask object
      final addTask = AddTask(
        childUsername: childusername, // Assuming this is not set in this dialog; adjust as necessary
        parentUsername: username, // Assuming this is not set in this dialog; adjust as necessary
        title: titleController.text,
        description: descriptionController.text,
        amount: amount,
        deadline: '${deadlineController.text} $deadlineType',
        validationType: validationType,
        qcmQuestion: validationType == 'qcm' ? 'QCM Question' : 'None', // Example placeholder for QCM
        qcmOptions: validationType == 'qcm' ? qcmAnswersFormatted : 'None',
        answer: validationType == 'question' ? answerControllers[0].text : 'None',
      );

      // Call the service to add the task
      final result = await taskService.addNewTask(addTask);

      // Show success/failure dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(result ? 'Success' : 'Failure'),
            content: Text(result ? 'Task added successfully.' : 'Failed to add task.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 5,
      backgroundColor: Colors.white,
      child: Container(
        padding: EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width * 0.9,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(currentStep == 1 ? 'Add Task' : 'Add Validation', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue)),
              SizedBox(height: 20),
              if (currentStep == 1) ...[
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: TextStyle(color: Colors.blue),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.yellow)),
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: TextStyle(color: Colors.blue),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.yellow)),
                  ),
                ),
                SizedBox(height: 15),
                Text("Select a Child"),
                Row(
                  children: [
                    _buildDropdownChildSelector(),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: amountController,
                        decoration: InputDecoration(
                          labelText: 'Amount',
                          labelStyle: TextStyle(color: Colors.blue),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.yellow)),
                        ),
                        keyboardType: TextInputType.numberWithOptions(decimal: false),
                      ),
                    ),
                    IconButton(onPressed: _increaseAmount, icon: Icon(Icons.add, color: Colors.blue)),
                    IconButton(onPressed: _decreaseAmount, icon: Icon(Icons.remove, color: Colors.blue)),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: deadlineController,
                        decoration: InputDecoration(
                          labelText: 'Deadline',
                          labelStyle: TextStyle(color: Colors.blue),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.yellow)),
                        ),
                        keyboardType: TextInputType.numberWithOptions(decimal: false),
                      ),
                    ),
                    SizedBox(width: 10),
                    DropdownButton<String>(
                      value: deadlineType,
                      onChanged: (String? newValue) {
                        setState(() {
                          deadlineType = newValue!;
                        });
                      },
                      items: <String>['days', 'weeks', 'months'].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text('Validation Type:', style: TextStyle(color: Colors.blue, fontSize: 16)),
                    ),
                    DropdownButton<String>(
                      value: validationType,
                      onChanged: (String? newValue) {
                        setState(() {
                          validationType = newValue!;
                        });
                      },
                      items: <String>['picture', 'question', 'qcm', 'none'].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ] else _buildValidationInput(),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                    child: Text('Cancel', style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    onPressed: _onNextPressed,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: Text(currentStep == 1 ? 'Next' : 'Submit', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}