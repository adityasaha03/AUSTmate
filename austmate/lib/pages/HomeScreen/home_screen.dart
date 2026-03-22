import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import 'schedule_box.dart';
import 'task_item.dart';
import 'task_model.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _taskNameController = TextEditingController();
  DateTime? _selectedDate;

  final List<Task> _tasks = [
    Task(name: "SD PRESENTATION", dueDate: DateTime.now()),
    Task(name: "DLD Report", dueDate: DateTime.now().add(const Duration(days: 1))),
    Task(name: "DS Lab Mid", dueDate: DateTime.now().add(const Duration(days: 3))),
  ];

  String _getRemainingDaysString(DateTime dueDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(dueDate.year, dueDate.month, dueDate.day);

    final difference = due.difference(today);
    final days = difference.inDays;

    if (days == 0) {
      return "today";
    } else if (days == 1) {
      return "1 day";
    } else if (days > 1) {
      return "$days days";
    } else {
      return "Past Due";
    }
  }

  Future<void> _showAddTaskDialog() async {
    _taskNameController.clear(); 
    _selectedDate = null; 

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Add New Task"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: _taskNameController,
                    decoration: const InputDecoration(
                      labelText: "Task Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedDate == null
                              ? "Select Date"
                              : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                          style: TextStyle(
                              color: _selectedDate == null ? Colors.grey : Colors.black),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate ?? DateTime.now(),
                            firstDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
                            lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
                          );
                          if (picked != null) {
                            setDialogState(() { 
                              _selectedDate = picked;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: const Text("Save"),
                  onPressed: () {
                    if (_taskNameController.text.isNotEmpty && _selectedDate != null) {
                      setState(() { 
                        _tasks.add(Task(
                          name: _taskNameController.text,
                          dueDate: _selectedDate!,
                        ));
                        _tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate)); 
                      });
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please enter task name and select a date.")),
                      );
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView( 
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    "Today",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: ScheduleBox(),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GestureDetector(
                    onTap: _showAddTaskDialog, 
                    child: Row(
                      children: [
                        const Icon(Icons.add, color: Color(0xFFE53935)),
                        const SizedBox(width: 8),
                        Text(
                          "Add task",
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.7),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                ..._tasks.map((task) {
                  final String remainingDays = _getRemainingDaysString(task.dueDate);
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: TaskItem(
                          title: task.name, 
                          badge: remainingDays,
                          badgeColor: const Color(0xFFE53935),
                          bold: remainingDays == "today",
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}