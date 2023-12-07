import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'custom_navigation.dart';
import 'notifications_service.dart';
import '../data/localDB/reminders.dart';
import '../models/reminder_model.dart';

final Color backgroundColor = Colors.black;
final Color purpleColor = Color(0xFF5E17EB);
final Color textColor = Colors.white;

class RemindersPage extends StatefulWidget {
  @override
  _RemindersPageState createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  List<Reminder> reminders = [];
  String searchQuery = '';
  final ReminderDatabase _reminderDatabase = ReminderDatabase();

  @override
  void initState() {
    super.initState();
    NotificationService.initializeNotification();
    _loadRemindersFromDatabase();
  }

  Future<void> _loadRemindersFromDatabase() async {
    final List<Reminder> loadedReminders = await _reminderDatabase.readAllReminders();
    setState(() {
      reminders = loadedReminders;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Row(
            children: <Widget>[
              SizedBox(width: 8.0),
              Text(
                "Reminders",
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
          _buildSearchBar(),
          Expanded(
            child: _buildReminderList(context, urgentOnly: false),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddReminderDialog(context),
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: purpleColor,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 3,
        onTap: (index) {},
      ),
    );
  }

  void _showAddReminderDialog(BuildContext context) {
    String title = '';
    String description = '';
    bool isUrgent = false;
    DateTime dueDate = DateTime.now();

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
            // Combine pickedDate and pickedTime to form a complete DateTime
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
                    'Due Date: ${DateFormat('yyyy-MM-dd – kk:mm').format(dueDate)}',
                  ),
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
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Done', style: TextStyle(color: purpleColor)),
              onPressed: () async {
                final newReminder = Reminder(
                  title: title,
                  description: description,
                  isUrgent: isUrgent ? 1 : 0,
                  endDate: dueDate,
                );
                await _reminderDatabase.createReminder(newReminder);
                _loadRemindersFromDatabase();
                Navigator.of(context).pop();

                final timeDifference =
                dueDate.subtract(Duration(days: 1)).difference(DateTime.now());
                final secondsBeforeDueDate = timeDifference.inSeconds;

                NotificationService.showNotification(
                  title: 'Reminder',
                  body: 'Your reminder is DUE tomorrow!: $title',
                  payload: {'navigate': 'true'},
                  scheduled: true,
                  interval: secondsBeforeDueDate,
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('You have set a new reminder'),
                    backgroundColor: purpleColor,
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

  void _showReminderDetails(BuildContext context, Reminder reminder) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(reminder.title!),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Description: ${reminder.description!}'),
                Text(
                  'Due Date: ${DateFormat('yyyy-MM-dd – kk:mm').format(reminder.endDate!)}',
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
              child: Text('Completed', style: TextStyle(color: purpleColor)),
              onPressed: () async {
                await _reminderDatabase.updateGoal(reminder.copyWith(isCompleted: 1));
                _loadRemindersFromDatabase();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Reminder marked as completed!'),
                    backgroundColor: purpleColor,
                    duration: Duration(seconds: 3),
                    action: SnackBarAction(
                      label: 'UNDO',
                      textColor: textColor,
                      onPressed: () async {
                        await _reminderDatabase.updateGoal(reminder.copyWith(isCompleted: 0));
                        _loadRemindersFromDatabase();
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

  Widget _buildReminderList(BuildContext context, {required bool urgentOnly}) {
    //final filteredReminders = reminders
    //     .where((reminder) =>
    // (urgentOnly ? reminder.isUrgent : true) &&
    //     (reminder.title!.toLowerCase().contains(searchQuery.toLowerCase()) ||
    //         reminder.description!.toLowerCase().contains(searchQuery.toLowerCase())))
    //     .toList();

    final filteredReminders = reminders
        .where((reminder) =>
    (reminder.title?.toLowerCase() ?? '').contains(searchQuery.toLowerCase()) ||
        (reminder.description?.toLowerCase() ?? '').contains(searchQuery.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: filteredReminders.length,
      itemBuilder: (context, index) {
        final reminder = filteredReminders[index];

        return Dismissible(
          key: Key(reminder.id!.toString()), // Key should be a String
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Icon(Icons.delete, color: Colors.white),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) async {
            await _deleteReminder(reminder.id!);
          },
          child: Card(
            color: Colors.grey[850],
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: ListTile(
              leading: Icon(
                reminder.isCompleted == 1
                    ? Icons.check_circle
                    : (reminder.isUrgent != null ? Icons.warning : Icons.task_alt),
                color: reminder.isCompleted == 1
                    ? Colors.green
                    : (reminder.isUrgent != null ? Colors.red : Colors.grey),
              ),
              title: Text(
                reminder.title!,
                style: TextStyle(color: textColor),
              ),
              subtitle: Text(
                'Due on ${DateFormat('yyyy-MM-dd – kk:mm').format(reminder.endDate!)}',
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

  Future<void> _deleteReminder(int id) async {
    await _reminderDatabase.deleteReminder(id);
    _loadRemindersFromDatabase();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reminder deleted successfully'),
        backgroundColor: purpleColor,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search Reminders',
          fillColor: Colors.white,
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
}
