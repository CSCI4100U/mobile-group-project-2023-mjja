import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../data/localDB/goals.dart';
import '../models/goal_model.dart';
import 'custom_navigation.dart';
import 'transactions_page.dart';

final Color backgroundColor = Colors.black;
final Color purpleColor = Color(0xFF5E17EB);
final Color textColor = Colors.white;

class GoalsPage extends StatefulWidget {
  @override
  _GoalsPageState createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  GoalDatabase _goalDatabase = GoalDatabase();
  List<Goal> goalsList = [];

  @override
  void initState() {
    super.initState();
    _loadGoals();
  }

  void _loadGoals() async {
    List<Goal> goals = await _goalDatabase.readAllGoals();
    setState(() {
      goalsList = goals;
    });
  }

  void _addNewGoal() {
    // Define controllers for text fields
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController amountController = TextEditingController();
    TextEditingController deadlineController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Goal'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  controller: titleController,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'Goal Title',
                  ),
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                  ),
                ),
                TextFormField(
                  controller: amountController,
                  decoration: InputDecoration(
                    labelText: 'Amount (\$)',
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                TextFormField(
                  controller: deadlineController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Deadline',
                    prefixIcon: Icon(Icons.calendar_today),
                    labelStyle: TextStyle(color: Colors.black),
                    hintStyle: TextStyle(color: Colors.black),
                  ),
                  onTap: () async {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    DateTime? deadline = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );
                    if (deadline != null) {
                      deadlineController.text = DateFormat.yMMMd().format(deadline);
                    }
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel', style: TextStyle(color: purpleColor)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save', style: TextStyle(color: purpleColor)),
              onPressed: () async {
                // Create a new Goal object with the entered details
                Goal newGoal = Goal(
                  name: titleController.text,
                  description: descriptionController.text,
                  amount: double.tryParse(amountController.text) ?? 0.0,
                  endDate: DateFormat.yMMMd().parse(deadlineController.text),
                  isCompleted: 0, // Assuming the default is not completed
                );

                // Add the new goal to the database
                int? result = await _goalDatabase.createGoal(newGoal);
                if (result != null) {
                  // Goal added successfully, reload goals
                  _loadGoals();
                } else {
                  // Handle error, e.g., show a snackbar or log the error
                  print('Failed to add new goal.');
                }
                // Close the dialog
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  void _toggleGoalCompletion(int index, bool isCompleted) async {
    Goal goal = goalsList[index];
    goal.isCompleted = isCompleted ? 1 : 0;
    await _goalDatabase.updateGoal(goal);
    _loadGoals();
  }

  // Add this method to show a confirmation dialog
  void _showDeleteConfirmationDialog(BuildContext context, Goal goal, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Goal'),
          content: Text('Are you sure you want to delete this goal?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                // User confirmed deletion, delete the goal
                _deleteGoal(index);
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

// Add this method to handle goal deletion
  void _deleteGoal(int index) async {
    Goal goal = goalsList[index];
    await _goalDatabase.deleteGoal(goal.id!);
    _loadGoals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.grey), // Adjust color accordingly
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => TransactionsPage()),
                  );

                },
              ),
              SizedBox(width: 8.0),
              Text(
                "        Budget Goals",
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold, color: purpleColor), // Adjust styling as needed
              ),
            ],
          ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: goalsList.length,
                itemBuilder: (context, index) {
                  var goal = goalsList[index];
                  return Dismissible(
                    key: Key(goal.id.toString()), // Assuming each goal has a unique ID
                    onDismissed: (direction) {
                      // Show a confirmation dialog before deleting the goal
                      _showDeleteConfirmationDialog(context, goal, index);
                    },
                    background: Container(
                      color: Colors.red, // Background color when swiping
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 36.0,
                      ),
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 20.0),
                    ),
                    child: GoalCard(
                    name: goal.name ?? "Default Goal Name",
                    description: goal.description ?? "Default Goal Description",
                    endDate: goal.endDate,
                    goalAmount: goal.amount,
                    isCompleted: goal.isCompleted == 1,
                    onCompletionChanged: (bool newVal) {
                      _toggleGoalCompletion(index, newVal);
                    },
                  )
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addNewGoal();
        },
        tooltip: 'Add Goal',
        child: Icon(Icons.add),
        backgroundColor: purpleColor,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 1, // Set the current index according to the GoalsPage
        onTap: (index) {
          // Handle bottom navigation bar item taps
        },
      ),
    );
  }
}

class GoalCard extends StatefulWidget {
  final String name;
  final String description;
  final DateTime? endDate;
  final double? goalAmount;
  final bool isCompleted;
  final Function(bool) onCompletionChanged;

  const GoalCard({
    Key? key,
    required this.name,
    this.description = '',
    this.endDate,
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
    double savedAmount = isCompleted ? goalAmount ?? 0.0 : 0.0;
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
          widget.name,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
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
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(widget.name),
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
                          valueColor: AlwaysStoppedAnimation<Color>(purpleColor),
                        ),
                      ),
                      Text('Progress: ${progress * 100}% of the goal'),
                      Text('Due: ${widget.endDate != null ? DateFormat.yMMMd().format(widget.endDate!) : 'No deadline'}')
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('Close', style: TextStyle(color: purpleColor)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text('Complete', style: TextStyle(color: purpleColor)),
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
