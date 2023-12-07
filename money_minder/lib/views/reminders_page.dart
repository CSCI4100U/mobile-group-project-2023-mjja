///File: reminders_page.dart
/// Description: Defines the RemindersPage widget to manage and display reminder
/// and send notifications.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'custom_navigation.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'notifications_service.dart';

//Colour scheme of UI design
final Color backgroundColor = Colors.black;
final Color purpleColor = Color(0xFF5E17EB);
final Color textColor = Colors.white;

///A StatefulWidget that represents the reminders page of the app.
/// Displays a list of reminders with options to add, delete, and view details of reminders.
class RemindersPage extends StatefulWidget {
  @override
  _RemindersPageState createState() => _RemindersPageState();
}

/// The State for RemindersPage.
/// Handles the UI and logic for managing reminders.
class _RemindersPageState extends State<RemindersPage> {
  List<Reminder> reminders = [];
  String searchQuery = '';

  ///Initialize notifications
  @override
  void initState() {
    super.initState();
    NotificationService.initializeNotification(); // Initialize notifications
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: _buildReminderList(context, urgentOnly: false),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddReminderDialog(context),
        child: Icon(Icons.add),
        backgroundColor: purpleColor,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 3,
        onTap: (index) {},
      ),
    );
  }

  ///Function called to delete reminders
  void _deleteReminder(int index) {
    setState(() {
      reminders.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reminder deleted successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  ///Search specific reminders based on words in description
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search Reminders',
          fillColor: Colors.white24,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          prefixIcon: Icon(Icons.search),
        ),
        onChanged: (query) {
          setState(() {
            searchQuery = query;
          });
        },
      ),
    );
  }

  ///Method that creates a Widget that display a list of of reminders
  Widget _buildReminderList(BuildContext context, {required bool urgentOnly}) {
    final filteredReminders = reminders
        .where((reminder) =>
            (urgentOnly ? reminder.isUrgent : true) &&
            (reminder.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
                reminder.description
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase())))
        .toList();

    return ListView.builder(
      itemCount: filteredReminders.length,
      itemBuilder: (context, index) {
        final reminder = filteredReminders[index];

        //provides the ability to delete a reminders card upon swiping
        return Dismissible(
          key: Key(reminder.title),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Icon(Icons.delete, color: Colors.white),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            _deleteReminder(index);
          },

          //display reminders list as a card design with the reminder name and due date
          // UI design for card assisted by chatGPT - OpenAI
          child: Card(
            // Using Card for better UI
            color: Colors.grey[850],
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: ListTile(
              leading: Icon(
                reminder.completed
                    ? Icons.check_circle
                    : (reminder.isUrgent ? Icons.warning : Icons.task_alt),
                color: reminder.completed
                    ? Colors.green
                    : (reminder.isUrgent ? Colors.red : Colors.grey),
              ),
              title: Text(
                reminder.title,
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                'Due on ${DateFormat('yyyy-MM-dd – kk:mm').format(reminder.dueDate)}',
                style: TextStyle(color: Colors.grey[400]),
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
              onTap: () => _showReminderDetails(context, reminder),
            ),
          ),
        );
      },
    );
  }

  ///pop up window that will display all the details and prompt completion option
  void _showReminderDetails(BuildContext context, Reminder reminder) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(reminder.title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Description: ${reminder.description}'),
                Text(
                    'Due Date: ${DateFormat('yyyy-MM-dd – kk:mm').format(reminder.dueDate)}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel', style: TextStyle(color: purpleColor)),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              // complete button to be pressed by user
              child: Text('Completed', style: TextStyle(color: purpleColor)),
              onPressed: () {
                setState(() {
                  reminder.completed = true;
                });
                Navigator.of(context).pop(); // Close the dialog

                // Show the SnackBar after marking a reminder as completed
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Reminder marked as completed!'),
                    backgroundColor: purpleColor,
                    duration: Duration(seconds: 3),
                    action: SnackBarAction(
                      label: 'UNDO',
                      textColor: Colors.white,
                      onPressed: () {
                        setState(() {
                          reminder.completed = false;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  ///method to add information of reminder: title, description, urgency and due date
  ///will appear as a pop up window
  void _showAddReminderDialog(BuildContext context) {
    String title = '';
    String description = '';
    bool isUrgent = false;
    DateTime dueDate = DateTime.now();

    // Function to call DatePicker and TimePicker
    //Date and time picking functionality assisted by ChatGPT - OpenAI
    Future<void> _selectDateTime(BuildContext context) async {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: dueDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101),
      );
      if (pickedDate != null) {
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(dueDate),
        );
        if (pickedTime != null) {
          setState(() {
            dueDate = DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
              pickedTime.hour,
              pickedTime.minute,
            );
          });
        }
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Reminder'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(hintText: 'Title'),
                  onChanged: (value) {
                    title = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(hintText: 'Description'),
                  onChanged: (value) {
                    description = value;
                  },
                ),
                SwitchListTile(
                  title: const Text('Urgent'),
                  value: isUrgent,
                  onChanged: (bool value) {
                    isUrgent = value;
                  },
                ),
                ListTile(
                  title: Text(
                      'Due Date: ${DateFormat('yyyy-MM-dd – kk:mm').format(dueDate)}'),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () {
                    _selectDateTime(context).then((_) {});
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel', style: TextStyle(color: purpleColor)),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Done', style: TextStyle(color: purpleColor)),
              onPressed: () {
                setState(() {
                  var newReminder = Reminder(
                    title: title,
                    description: description,
                    isUrgent: isUrgent,
                    dueDate: dueDate,
                  );
                  reminders.add(newReminder);
                  // Calculate time difference between current time and 1 day before the due date
                  final timeDifference = dueDate
                      .subtract(Duration(days: 1))
                      .difference(DateTime.now());
                  final secondsBeforeDueDate = timeDifference.inSeconds;

                  //Schedule the notification 1 day before the due date
                  NotificationService.showNotification(
                    title: 'Reminder',
                    body: 'Your reminder is DUE tomorrow!: $title',
                    payload: {'navigate': 'true'},
                    scheduled: true,
                    interval: secondsBeforeDueDate,
                  );
                });
                Navigator.of(context).pop(); // Close the dialog

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('You have set a new reminder'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

/// A class representing a reminder.
/// Contains the title, description, urgency flag, completion status, and due date of the reminder.
class Reminder {
  String title;
  String description;
  bool isUrgent;
  bool completed;
  DateTime dueDate;

  Reminder({
    required this.title,
    required this.description,
    required this.isUrgent,
    this.completed = false,
    required this.dueDate,
  });
}
