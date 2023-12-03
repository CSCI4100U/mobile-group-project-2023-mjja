import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;
import 'custom_navigation.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'notifications_service.dart';


final Color backgroundColor = Colors.black;
final Color purpleColor = Color(0xFF5E17EB); // Replace with your exact color code
final Color textColor = Colors.white;

class RemindersPage extends StatefulWidget {
  @override
  _RemindersPageState createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  List<Reminder> reminders = [];
  String searchQuery = '';

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
            child: _buildReminderList(context, urgentOnly: true),

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
        onTap: (index) {
          // Handle bottom navigation bar item taps
        },
      ),
    );
  }

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

  Widget _buildReminderList(BuildContext context, {required bool urgentOnly}) {
    final filteredReminders = reminders
        .where((reminder) => (urgentOnly ? reminder.isUrgent : true) &&
        (reminder.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
            reminder.description.toLowerCase().contains(searchQuery.toLowerCase())))
        .toList();

    return ListView.builder(

      itemCount: filteredReminders.length,
      itemBuilder: (context, index) {
        final reminder = filteredReminders[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: Colors.grey[850], // You can choose any shade of grey.
            borderRadius: BorderRadius.circular(10.0), // Rounded corners
          ),
          child: ListTile(
            leading: Icon(
              reminder.completed ? Icons.check_circle : (reminder.isUrgent ? Icons.warning : Icons.task_alt),
              color: reminder.completed ? Colors.green : (reminder.isUrgent ? Colors.red : Colors.grey),
            ),
            title: Text(
              reminder.title,
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              'Due on ${DateFormat('yyyy-MM-dd – kk:mm').format(reminder.dueDate)}',
              style: TextStyle(color: Colors.grey[400]), // Lighter grey for subtitle
            ),
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
            onTap: () => _showReminderDetails(context, reminder),
          ),
        );
      },
    );
  }

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
                Text('Due Date: ${DateFormat('yyyy-MM-dd – kk:mm').format(reminder.dueDate)}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Completed'),
              onPressed: () {
                setState(() {
                  reminder.completed = true;
                });
                Navigator.of(context).pop(); // Close the dialog

                // Show the SnackBar after marking a reminder as completed
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Reminder marked as completed'),
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

  void _showAddReminderDialog(BuildContext context) {
    String title = '';
    String description = '';
    bool isUrgent = false;
    DateTime dueDate = DateTime.now();

    // Function to call DatePicker and TimePicker
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
                  title: Text('Due Date: ${DateFormat('yyyy-MM-dd – kk:mm').format(dueDate)}'),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () {
                    _selectDateTime(context).then((_) {
                      // Update the UI
                    });
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
      TextButton(
      child: Text('Cancel'),
    onPressed: () {
    Navigator.of(context).pop(); // Close the dialog
    },
    ),
    TextButton(
    child: Text('Done'),
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
    final timeDifference = dueDate.subtract(Duration(days: 1)).difference(DateTime.now());
    final secondsBeforeDueDate = timeDifference.inSeconds;

    // Schedule the notification 1 day before the due date
    NotificationService.showNotification(
      title: 'Reminder',
      body: 'Your reminder is due tomorrow: $title',
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