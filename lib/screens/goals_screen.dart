import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  _GoalsScreenState createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  final TextEditingController _goalController = TextEditingController();
  final TextEditingController _goalTitleController = TextEditingController();
  final List<Map<String, dynamic>> _goals = [];

  final String userId = FirebaseAuth.instance.currentUser!.uid;

  void _addGoal() async {
    if (_goalController.text.isNotEmpty &&
        _goalTitleController.text.isNotEmpty) {
      setState(() {});

      String goal = _goalController.text;
      String title = _goalTitleController.text;

      // Add goal to Firestore with initial status of not completed
      DocumentReference docRef =
          await FirebaseFirestore.instance.collection('goals').add({
        'goal': goal,
        'title': title,
        'completed': false,
        'timestamp': FieldValue.serverTimestamp(),
        'userId': userId,
      });

      setState(() {
        _goals.add({
          'id': docRef.id,
          'goal': goal,
          'title': title,
          'completed': false
        });
        showSnackbar("Goal added!");
        _goalController.clear();
        _goalTitleController.clear();
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

      if (_goals[index]['completed'] == true) {
        showSnackbar("Goal completed!");
        _showGoalCompletedDialog();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadGoals();
  }

  void _loadGoals() async {
    // Load goals from Firestore
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('goals')
        .where('userId', isEqualTo: userId)
        .get();

    setState(() {
      for (var doc in snapshot.docs) {
        _goals.add({
          'id': doc.id,
          'goal': doc['goal'],
          'title': doc['title'],
          'completed': doc['completed'],
        });
      }
    });
  }

  // Method to show snackbar
  void showSnackbar(String snackText) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(snackText),
      ),
    );
  }

  void _showAddGoalDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Goal'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _goalTitleController,
                decoration: const InputDecoration(hintText: 'Enter goal title'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _goalController,
                decoration:
                    const InputDecoration(hintText: 'Enter goal content'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addGoal();
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showGoalCompletedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent, // Dialog arka planını şeffaf yap
          child: Stack(
            children: [
              // Arka planda havai fişek animasyonu
              Positioned.fill(
                child: Lottie.asset('assets/fireworks.json', fit: BoxFit.fill),
              ),
              // Modal içeriği
              Center(
                child: AlertDialog(
                  title: Text("Goal Completed!"),
                  backgroundColor:
                      Colors.white, // Modal içeriğinin arka plan rengi
                  content: SizedBox(
                    height: 150,
                    child: Center(
                      child: Text("Congratulations on completing the goal!"),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
          "Goals",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold), // AppBar başlık stilini ayarla
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
              Icons.track_changes_sharp,
              color: Colors.white,
              size: 35,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _goals.length,
                itemBuilder: (context, index) {
                  var goal = _goals[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    color: goal['completed']
                        ? Colors.green.shade300
                        : Colors.white,
                    child: ListTile(
                      title: Text(
                        goal['title'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: goal['completed']
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: goal['completed']
                              ? Colors.grey.shade600
                              : Colors.black87,
                        ),
                      ),
                      subtitle: Text(
                        goal['goal'],
                        style: TextStyle(
                          decoration: goal['completed']
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: goal['completed']
                              ? Colors.grey.shade600
                              : Colors.black87,
                        ),
                      ),
                      leading: Checkbox(
                        value: goal['completed'],
                        onChanged: (bool? value) {
                          _toggleGoalStatus(goal['id'], goal['completed']);
                        },
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('goals')
                              .doc(goal['id'])
                              .delete();

                          showSnackbar("Goal Deleted!");

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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey[700],
        onPressed: _showAddGoalDialog,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
