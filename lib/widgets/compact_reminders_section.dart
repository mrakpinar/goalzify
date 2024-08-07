import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goalzify/styles.dart';
import 'package:intl/intl.dart';

class CompactRemindersSection extends StatelessWidget {
  const CompactRemindersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('reminders').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No reminders available.'));
        }

        var reminders = snapshot.data!.docs;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: reminders.map((doc) {
            var data = doc.data() as Map<String, dynamic>;
            DateTime reminderTime = (data['timestamp'] as Timestamp).toDate();
            bool isCompleted = data['completed'];
            return Card(
              margin:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 35.0),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              color: isCompleted ? Colors.green.shade100 : Colors.grey.shade400,
              child: ListTile(
                contentPadding: const EdgeInsets.all(5.0),
                leading: isCompleted
                    ? Icon(
                        Icons.check_circle,
                        color: Colors.green.shade600,
                        size: 20,
                      )
                    : Icon(
                        Icons.radio_button_unchecked,
                        color: Colors.grey.shade600,
                        size: 20,
                      ),
                title: Text(
                  data['title'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isCompleted ? Colors.grey.shade600 : Colors.white,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                subtitle: Text(
                  DateFormat('yyyy-MM-dd HH:mm').format(reminderTime),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
                onTap: () => _showReminderModal(context, doc.id, data),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  void _showReminderModal(
      BuildContext context, String docId, Map<String, dynamic> data) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors
          .transparent, // Ensures bottom sheet's background is transparent
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, // Use min to only take the required space
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Reminder Details',
                    style: AppStyles.homeScreenSectionTitle),
                const SizedBox(height: 15),
                Text('Title:', style: Theme.of(context).textTheme.bodyMedium),
                Text('${data['title']}',
                    style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 10),
                Text('Date:', style: Theme.of(context).textTheme.bodySmall),
                Text(
                  DateFormat('yyyy-MM-dd')
                      .format((data['timestamp'] as Timestamp).toDate()),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 10),
                Text('Time:', style: Theme.of(context).textTheme.bodySmall),
                Text(
                  DateFormat('HH:mm')
                      .format((data['timestamp'] as Timestamp).toDate()),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Checkbox(
                            value: data['completed'],
                            onChanged: (bool? value) {
                              _markAsCompleted(context, docId, value ?? false);
                            },
                          ),
                          Text(
                            data['completed'] ? 'Completed' : 'Mark as Done',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade400,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      onPressed: () => _editReminder(context, docId),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.edit_outlined,
                            size: 20,
                            color: Colors.white,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Edit',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade400,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      onPressed: () => _deleteReminder(context, docId),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.delete_outline_sharp,
                            size: 20,
                            color: Colors.white,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Delete',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _markAsCompleted(
      BuildContext context, String docId, bool completed) async {
    await FirebaseFirestore.instance
        .collection('reminders')
        .doc(docId)
        .update({'completed': completed});
    Navigator.pop(context); // Close the modal
  }

  void _editReminder(BuildContext context, String docId) {
    Navigator.pop(context); // Close the modal
    // Navigate to an edit screen or show a dialog to edit reminder
  }

  Future<void> _deleteReminder(BuildContext context, String docId) async {
    await FirebaseFirestore.instance
        .collection('reminders')
        .doc(docId)
        .delete();
    Navigator.pop(context); // Close the modal
    // Optionally, cancel notification here if needed
  }
}
