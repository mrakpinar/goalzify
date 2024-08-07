import 'package:flutter/material.dart';

class MyCard extends StatelessWidget {
  final String goal;
  final bool isCompleted;
  final ValueChanged<bool?> onStatusChanged;
  final VoidCallback onDelete;

  const MyCard({
    Key? key,
    required this.goal,
    required this.isCompleted,
    required this.onStatusChanged,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      color: isCompleted ? Colors.green.shade100 : Colors.grey.shade300,
      child: ListTile(
        title: Text(
          goal,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: isCompleted ? Colors.grey.shade500 : Colors.grey.shade700,
            decoration: isCompleted ? TextDecoration.none : TextDecoration.none,
          ),
        ),
        leading: Checkbox(
          value: isCompleted,
          onChanged: onStatusChanged,
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete,
              color: isCompleted ? Colors.black : Colors.redAccent),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
