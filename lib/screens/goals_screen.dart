import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goalzify/styles.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  _GoalsScreenState createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  final TextEditingController _goalController = TextEditingController();
  final List<Map<String, dynamic>> _goals = [];
  bool _isLoading = false;

  void _addGoal() async {
    if (_goalController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      String goal = _goalController.text;

      // Add goal to Firestore with initial status of not completed
      DocumentReference docRef =
          await FirebaseFirestore.instance.collection('goals').add({
        'goal': goal,
        'completed': false,
        'timestamp': FieldValue.serverTimestamp(),
      });

      setState(() {
        _goals.add({'id': docRef.id, 'goal': goal, 'completed': false});
        _goalController.clear();
        _isLoading = false;
      });
    }
  }

  void _toggleGoalStatus(String id, bool currentStatus) async {
    // Update the completed status of the goal in Firestore
    await FirebaseFirestore.instance.collection('goals').doc(id).update({
      'completed': !currentStatus,
    });

    setState(() {
      // Update the local list of goals
      int index = _goals.indexWhere((goal) => goal['id'] == id);
      _goals[index]['completed'] = !currentStatus;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadGoals();
  }

  void _loadGoals() async {
    // Load goals from Firestore
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('goals').get();

    setState(() {
      _goals.clear();
      for (var doc in snapshot.docs) {
        _goals.add({
          'id': doc.id,
          'goal': doc['goal'],
          'completed': doc['completed'],
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Goals",
          style: AppStyles.screenTitleTextStyle,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _goalController,
              decoration: InputDecoration(
                hintText: "Enter your goal",
                hintStyle: AppStyles.inputHintTextStyle,
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 20.0),
                suffixIcon: _isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.amber),
                        ),
                      )
                    : IconButton(
                        icon: const Icon(
                          Icons.add,
                          size: 30,
                        ),
                        onPressed: _addGoal,
                      ),
              ),
              style: AppStyles.inputTextStyle,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _goals.isEmpty
                  ? const Center(
                      child: Text(
                        "No goals added yet!",
                        style: AppStyles.goalTextStyle,
                      ),
                    )
                  : ListView.builder(
                      itemCount: _goals.length,
                      itemBuilder: (context, index) {
                        bool isCompleted = _goals[index]['completed'];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 10.0),
                          color: isCompleted
                              ? Colors.green.shade300
                              : Colors.white,
                          child: ListTile(
                            title: Text(
                              _goals[index]['goal'],
                              style: AppStyles.goalTextStyle.copyWith(
                                decoration: isCompleted
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                color: isCompleted
                                    ? Colors.grey.shade600
                                    : Colors.black87,
                              ),
                            ),
                            leading: Checkbox(
                              value: isCompleted,
                              onChanged: (bool? value) {
                                _toggleGoalStatus(
                                    _goals[index]['id'], isCompleted);
                              },
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.redAccent),
                              onPressed: () async {
                                // Remove goal from Firestore
                                await FirebaseFirestore.instance
                                    .collection('goals')
                                    .doc(_goals[index]['id'])
                                    .delete();

                                setState(() {
                                  _goals.removeAt(index);
                                });
                              },
                            ),
                          ),
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
