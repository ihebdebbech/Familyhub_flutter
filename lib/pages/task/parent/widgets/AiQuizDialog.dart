import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/taskService.dart'; // Ensure this path is correct
import 'package:shared_preferences/shared_preferences.dart';

class AiQuizDialog extends StatefulWidget {
  @override
  _AiQuizDialogState createState() => _AiQuizDialogState();
}

class _AiQuizDialogState extends State<AiQuizDialog> {
  int amount = 2;
  int age = 6;
  List<String> childUsernames = [];
  List<String> selectedChildren = [];
  List<String> finalList = [];

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
      childUsernames = data['childUsernames'] ?? [];
      selectedChildren = data['activated'] ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return AlertDialog(
      title: Text('Set up daily generated questions!', style: theme.textTheme.headline6),
      content: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildCounterRow('Amount', Icons.attach_money, amount, (int newVal) => setState(() => amount = newVal), theme),
            _buildCounterRow('Age', Icons.cake, age, (int newVal) => setState(() => age = newVal), theme),
            const SizedBox(height: 20),
            ...childUsernames.map((username) => _buildCustomCheckboxListTile(username, theme, Icons.person_outline)).toList(),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text('Cancel', style: TextStyle(color: theme.colorScheme.error)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text('OK', style: TextStyle(color: theme.colorScheme.primary)),
          onPressed: () => _handleOkPressed(context),
        ),
      ],
    );
  }

  void _handleOkPressed(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String parentUsername = prefs.getString('username') ?? '';
    await TaskService().activateAi(finalList, parentUsername, age, amount);
    Navigator.of(context).pop();
    print("Final changes: $finalList");
  }

  Widget _buildCustomCheckboxListTile(String username, ThemeData theme, IconData icon) {
    bool isChecked = selectedChildren.contains(username);
    return InkWell(
      onTap: () {
        setState(() {
          if (selectedChildren.contains(username)) {
            selectedChildren.remove(username);
            finalList.add(username); 
          } else {
            selectedChildren.add(username);
            finalList.add(username); 
          }
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            Icon(icon, color: theme.colorScheme.primary),
            SizedBox(width: 10),
            Expanded(child: Text(username, style: TextStyle(fontSize: 16))),
            Checkbox(
              value: isChecked,
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    if (!selectedChildren.contains(username)) {
                      selectedChildren.add(username);
                      finalList.add(username);
                    }
                  } else {
                    if (selectedChildren.contains(username)) {
                      selectedChildren.remove(username);
                      finalList.add(username);
                    }
                  }
                });
              },
              activeColor: theme.colorScheme.primary,
              checkColor: theme.colorScheme.onPrimary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCounterRow(String label, IconData icon, int value, Function(int) onUpdate, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(icon, color: theme.colorScheme.primary),
        SizedBox(width: 10),
        Expanded(child: Text(label)),
        IconButton(
          icon: Icon(Icons.remove, color: Colors.redAccent),
          onPressed: () => setState(() => onUpdate(value > 0 ? value - 1 : value)),
        ),
        Text('$value', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        IconButton(
          icon: Icon(Icons.add, color: Colors.green),
          onPressed: () => setState(() => onUpdate(value + 1)),
        ),
      ],
    );
  }
}