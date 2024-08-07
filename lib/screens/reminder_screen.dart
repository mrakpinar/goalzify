// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goalzify/styles.dart';
import 'package:intl/intl.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  bool _isLoading = false;

  // Variables to store the selected date and time
  DateTime selectedDate = DateTime.now();
  TimeOfDay? selectedTime;

  // Method to add a reminder to Firestore
  Future<void> _addReminder(
      String title, String content, DateTime dateTime) async {
    setState(() {
      _isLoading = true;
    });

    // Check if title and content are not empty
    if (title.isNotEmpty && content.isNotEmpty) {
      // You can add your notification scheduling logic here

      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Please fill in all fields and select a time before saving.')),
      );
    }
  }

  // Method to show snackbar
  void showSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Reminder deleted!"),
      ),
    );
  }

  // Method to show a dialog for adding a new reminder
  void _showAddReminderDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController titleController = TextEditingController();
        final TextEditingController contentController = TextEditingController();

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Reminder Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: contentController,
                      decoration: const InputDecoration(
                        labelText: 'Reminder Content',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blueGrey[700],
                            ),
                            onPressed: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2101),
                              );
                              if (picked != null && picked != selectedDate) {
                                setState(() {
                                  selectedDate = picked;
                                });
                              }
                            },
                            child: Text(
                              'Select Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blueGrey[700],
                            ),
                            onPressed: () async {
                              final TimeOfDay? picked = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                                builder: (BuildContext context, Widget? child) {
                                  return MediaQuery(
                                    data: MediaQuery.of(context).copyWith(
                                      alwaysUse24HourFormat: true,
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (picked != null) {
                                final now = TimeOfDay.now();
                                if (picked.hour < now.hour ||
                                    (picked.hour == now.hour &&
                                        picked.minute <= now.minute)) {
                                  // Show a SnackBar if a past time is selected
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Please select a future time.')),
                                  );
                                  return;
                                }
                                setState(() {
                                  selectedTime = picked;
                                });
                              }
                            },
                            child: Text(
                              'Select Time: ${selectedTime != null ? selectedTime!.format(context) : 'Not selected'}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (selectedTime != null) {
                          DateTime reminderDateTime = DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            selectedTime!.hour,
                            selectedTime!.minute,
                          );
                          _addReminder(titleController.text,
                              contentController.text, reminderDateTime);
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please select a time.')),
                          );
                        }
                      },
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : const Text('Add Reminder'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        title: Text(
          "Reminders",
          style: AppStyles.screenTitleTextStyle,
        ),
        backgroundColor: Colors.blueGrey[700],
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_sharp,
            color: Colors.white,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 25.0),
            child: Icon(
              Icons.alarm_add,
              color: Colors.white,
              size: 35,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('reminders')
              .where('userId', isEqualTo: userId)
              .snapshots(),
          builder: (context, snapshot) {
            // Show a loading indicator while waiting for data
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // Show an error message if there's an error
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            // Show a message if there are no reminders
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No reminders added yet!"));
            }

            // Display the list of reminders
            var reminders = snapshot.data!.docs;
            return ListView(
              children: reminders.map((doc) {
                var data = doc.data() as Map<String, dynamic>;
                DateTime reminderTime =
                    (data['timestamp'] as Timestamp).toDate();
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: data['completed']
                        ? Colors.green.shade300
                        : Colors.white,
                    child: ListTile(
                      title: Text(
                        data['title'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: data['completed']
                                ? TextDecoration.lineThrough
                                : null),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['content'],
                            style: TextStyle(
                                decoration: data['completed']
                                    ? TextDecoration.lineThrough
                                    : null),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            DateFormat('yyyy-MM-dd HH:mm').format(reminderTime),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      leading: Checkbox(
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
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () async {
                          await _firestore
                              .collection('reminders')
                              .doc(doc.id)
                              .delete();
                          // Handle notification cancellation if applicable
                          showSnackbar();
                        },
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddReminderDialog,
        backgroundColor: Colors.blueGrey[700],
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
