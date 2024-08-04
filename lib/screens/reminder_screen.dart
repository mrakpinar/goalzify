import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:goalzify/services/notification_service.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  final TextEditingController _titleController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  final NotificationService _notificationService = NotificationService();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _addReminder() async {
    if (_titleController.text.isNotEmpty) {
      DateTime reminderDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      DocumentReference docRef = await _firestore.collection('reminders').add({
        'title': _titleController.text,
        'timestamp': Timestamp.fromDate(reminderDateTime),
        'completed': false,
      });

      // Schedule notification
      await _notificationService.scheduleNotification(
        id: docRef.id.hashCode,
        title: 'Reminder',
        body: _titleController.text,
        scheduledDate: reminderDateTime,
      );

      _titleController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reminder"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Add New Reminder',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Text(
                        'Select Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _selectTime(context),
                    child:
                        Text('Select Time: ${_selectedTime.format(context)}'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addReminder,
              child: const Text('Add Reminder'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('reminders').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No reminders added yet!"));
                  }

                  var reminders = snapshot.data!.docs;
                  return ListView(
                    children: reminders.map((doc) {
                      var data = doc.data() as Map<String, dynamic>;
                      DateTime reminderTime =
                          (data['timestamp'] as Timestamp).toDate();
                      return ListTile(
                        title: Text(data['title']),
                        subtitle: Text(DateFormat('yyyy-MM-dd HH:mm')
                            .format(reminderTime)),
                        trailing: Checkbox(
                          value: data['completed'],
                          onChanged: (bool? value) async {
                            await _firestore
                                .collection('reminders')
                                .doc(doc.id)
                                .update({
                              'completed': value,
                            });
                          },
                        ),
                        onLongPress: () async {
                          await _firestore
                              .collection('reminders')
                              .doc(doc.id)
                              .delete();
                          await _notificationService
                              .cancelNotification(doc.id.hashCode);
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
