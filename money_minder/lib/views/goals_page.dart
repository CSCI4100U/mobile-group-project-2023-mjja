// ## Acknowledgments
// The code in this project was developed with the assistance of ChatGPT, an AI language model created by OpenAI.

// DONE: make UI for progress bar for the goal
//TO DO: goals should be completed based on goal completion/when the progress bar hits 100%
//       "Complete" button has been implemented for now 
//       _calculateProgress method has a mock amount for saved money ($50).
//       Find a way for the goals to know which expense/savings to keep track of in the progress bar

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl to format dates
import 'package:percent_indicator/percent_indicator.dart';

class GoalsPage extends StatefulWidget {
  @override
  _GoalsPageState createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  List<Map<String, dynamic>> goalsList = [];

  void _addNewGoal() {
    String goalTitle = '';
    String goalDescription = '';
    DateTime? deadline;
    double? goalAmount;

    // Define controllers for text fields
    TextEditingController amountController = TextEditingController();
    TextEditingController deadlineController = TextEditingController();

    //add a new goal
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Goal'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'Goal Title',
                  ),
                  onChanged: (value) {
                    goalTitle = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Description',
                  ),
                  onChanged: (value) {
                    goalDescription = value;
                  },
                ),
                TextFormField(
                  controller: amountController,
                  decoration: InputDecoration(
                    labelText: 'Amount (\$)',
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onChanged: (value) {
                    goalAmount = double.tryParse(value);
                  },
                ),
                TextFormField(
                  controller: deadlineController,
                  decoration: InputDecoration(
                    labelText: 'Deadline',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () async {
                    FocusScope.of(context).requestFocus(new FocusNode()); // to prevent opening default keyboard
                    deadline = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );
                    if (deadline != null) {
                      deadlineController.text = DateFormat.yMMMd().format(deadline!);
                    }
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel', style: TextStyle(color: Colors.purple)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save', style: TextStyle(color: Colors.purple)),
              onPressed: () {
                setState(() {
                  goalsList.add({
                    'title': goalTitle,
                    'description': goalDescription,
                    'deadline': deadline,
                    'goalAmount': goalAmount,
                    'isCompleted': false,
                  });
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _toggleGoalCompletion(int index, bool isCompleted) {
    if (!goalsList[index]['isCompleted'] && isCompleted) {
      // Show snack bar when the task is marked as completed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Task ${goalsList[index]['title']} is complete!'),
          duration: Duration(seconds: 3),
        ),
      );
    }

    setState(() {
      goalsList[index]['isCompleted'] = isCompleted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Financial Goals'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: ListView.builder(
        itemCount: goalsList.length,
        itemBuilder: (context, index) {
          var goal = goalsList[index];
          return GoalCard(
            title: goal['title'],
            description: goal['description'],
            deadline: goal['deadline'],
            goalAmount: goal['goalAmount'],
            isCompleted: goal['isCompleted'],
            onCompletionChanged: (bool newVal) {
              _toggleGoalCompletion(index, newVal);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewGoal,
        tooltip: 'Add Goal',
        child: Icon(Icons.add),
        backgroundColor: Colors.purple,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class GoalCard extends StatefulWidget {
  final String title;
  final String description;
  final DateTime? deadline;
  final double? goalAmount;
  final bool isCompleted;
  final Function(bool) onCompletionChanged;

  const GoalCard({
    Key? key,
    required this.title,
    this.description = '',
    this.deadline,
    this.goalAmount,
    required this.isCompleted,
    required this.onCompletionChanged,
  }) : super(key: key);

  @override
  _GoalCardState createState() => _GoalCardState();
}

class _GoalCardState extends State<GoalCard> {
  late bool isCompleted;

  @override
  void initState() {
    super.initState();
    isCompleted = widget.isCompleted;
  }

  double _calculateProgress(double? goalAmount) {
    // Mocking saved amount as $50
    double savedAmount = 50.0;
    if (goalAmount != null && goalAmount > 0) {
      return savedAmount / goalAmount;
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[800],
      shape: RoundedRectangleBorder(
        side: BorderSide(color: isCompleted ? Colors.green : Colors.transparent, width: 2.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        title: Text(
          widget.title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18, // Slightly larger text
          ),
        ),
        subtitle: isCompleted
            ? Text(
          'Completed',
          style: TextStyle(color: Colors.green),
        )
            : null,
        onTap: () {
          double progress = _calculateProgress(widget.goalAmount);
          // Show dialog with details on tap
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(widget.title),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text('Description: ${widget.description}'),
                      Text('Amount: ${widget.goalAmount != null ? '\$${widget.goalAmount!.toStringAsFixed(2)}' : 'No amount set'}'),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
                        ),
                      ),
                      Text('Progress: ${progress * 100}% of the goal'),
                      Text('Due: ${widget.deadline != null ? DateFormat.yMMMd().format(widget.deadline!) : 'No deadline'}')
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('Close', style: TextStyle(color: Colors.purple)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text('Complete', style: TextStyle(color: Colors.purple)),
                    onPressed: () {
                      if (!isCompleted) {
                        setState(() {
                          isCompleted = true;
                        });
                        widget.onCompletionChanged(true);
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        trailing: Icon(Icons.chevron_right, color: Colors.white70),
      ),
    );
  }
}
