/// Displays the user's budget goals.
/// This page  allows the user to view, add, and delete goals, as well as marking them as completed.
/// The user has to manually keep track of the budget goals, and mark them complete when they have completed their goals

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/localDB/goals.dart';
import '../models/goal_model.dart';
import 'custom_navigation.dart';

final Color backgroundColor = Colors.black;
final Color purpleColor = Color(0xFF5E17EB);
final Color textColor = Colors.white;

class GoalsPage extends StatefulWidget {
  @override
  _GoalsPageState createState() => _GoalsPageState();
}

/// Manages the list of goals, and handles database interactions to load and update goals.
class _GoalsPageState extends State<GoalsPage> {
  GoalDatabase _goalDatabase = GoalDatabase();
  List<Goal> goalsList = [];

  @override
  void initState() {
    super.initState();
    _loadGoals();
  }

  /// Loads goals from the database and updates the UI.
  void _loadGoals() async {
    List<Goal> goals = await _goalDatabase.readAllGoals();
    setState(() {
      goalsList = goals;
    });
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
                SizedBox(width: 8.0),
                Text(
                  "Budget Goals",
                  style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
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
                    //make sure each goal has a unique ID
                    key: Key(goal.id.toString()),
                    onDismissed: (direction) {
                      // Show a confirmation dialog before deleting the goal
                      _showDeleteConfirmationDialog(context, goal, index);
                    },
                    background: Container(
                      color: Colors.red,
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
                      description:
                      goal.description ?? "Default Goal Description",
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
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: purpleColor,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 1, // Set the current index according to the GoalsPage
        onTap: (index) {},
      ),
    );
  }

  /// Method to create a pop up window to add a new goal.
  /// The window contains form fields for the goal's title, description, amount, and deadline.
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
                      deadlineController.text =
                          DateFormat.yMMMd().format(deadline);
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
                // we will set the goal to '!isComplete'
                Goal newGoal = Goal(
                  name: titleController.text,
                  description: descriptionController.text,
                  amount: double.tryParse(amountController.text) ?? 0.0,
                  endDate: DateFormat.yMMMd().parse(deadlineController.text),
                  isCompleted: 0,
                );

                // Add the new goal to the database
                int? result = await _goalDatabase.createGoal(newGoal);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Budget goal added successfully'),
                    backgroundColor: purpleColor,
                    duration: Duration(seconds: 2),
                  ),
                );
                if (result != null) {
                  // Goal added successfully, reload goals
                  _loadGoals();
                } else {
                  // Show a snackbar message if the goal cannot be saved
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Could not save your budgeting goal'),
                      backgroundColor: purpleColor,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
                // Close the window/dialog
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /// Method to toggle the completion status of a goal.
  /// Updates the goal's 'isCompleted' status in the database and refreshes the goal list.
  void _toggleGoalCompletion(int index, bool isCompleted) async {
    Goal goal = goalsList[index];
    goal.isCompleted = isCompleted ? 1 : 0;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Budget goal marked as completed!'),
        backgroundColor: purpleColor,
        duration: Duration(seconds: 5),
      ),
    );
    await _goalDatabase.updateGoal(goal);
    _loadGoals();
  }

  /// Method to show a confirmation dialog before deleting a goal.
  /// Once if confirmed, it calls [_deleteGoal] to remove the goal from the database.
  void _showDeleteConfirmationDialog(
      BuildContext context, Goal goal, int index) {
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
                _deleteGoal(index); // User confirmed deletion, delete the goal
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  /// Method to delete a goal from the database and update the UI.
  void _deleteGoal(int index) async {
    Goal goal = goalsList[index];
    await _goalDatabase.deleteGoal(goal.id!);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Budget goal deleted successfully'),
        backgroundColor: purpleColor,
        duration: Duration(seconds: 2),
      ),
    );
    _loadGoals();
  }
}

/// A card widget that represents a single goal.
/// Displays the goal's title, description, progress, and allows the user to mark it as complete.
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

/// The state for [GoalCard].
/// Manages the display of the goal's progress and interaction with the goal card.
class _GoalCardState extends State<GoalCard> {
  late bool isCompleted;

  @override
  void initState() {
    super.initState();
    isCompleted = widget.isCompleted;
  }

  /// This method calculates the progress towards the goal as a percentage.
  ///
  /// The progress is calculated based on the [goalAmount] and the amount saved so far.
  // Progress bar and percentage UI and functionality was developed with the assistance of ChatGPT - openAI
  double _calculateProgress(double? goalAmount) {
    double savedAmount = isCompleted ? goalAmount ?? 0.0 : 0.0;
    if (goalAmount != null && goalAmount > 0) {
      return savedAmount / goalAmount;
    }
    return 0.0;
  }

  /// Build method for pop up dialog that shows up when a goal card is clicked on
  /// The window shows the title, description, goal amount, and the due date of the goal.
  /// This window shows the progress bar that visualizes how close the user is to achieving the goal.
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[800],
      shape: RoundedRectangleBorder(
        side: BorderSide(
            color: isCompleted ? Colors.green : Colors.transparent, width: 2.0),
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
          //show details of the budgeting goal
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
                      Text(
                          'Amount: ${widget.goalAmount != null ? '\$${widget.goalAmount!.toStringAsFixed(2)}' : 'No amount set'}'),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey[300],
                          valueColor:
                          AlwaysStoppedAnimation<Color>(purpleColor),
                        ),
                      ),
                      Text('Progress: ${progress * 100}% of the goal'),
                      Text(
                          'Due: ${widget.endDate != null ? DateFormat.yMMMd().format(widget.endDate!) : 'No deadline'}')
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
                    child:
                    Text('Complete', style: TextStyle(color: purpleColor)),
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
