import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoutinePage extends StatefulWidget {
  const RoutinePage({super.key});

  @override
  State<RoutinePage> createState() => _RoutinePageState();
}

class _RoutinePageState extends State<RoutinePage> {
  late SharedPreferences _prefs;
  Map<String, String> routineData = {};
  bool isLoading = true;

  final List<String> days = ['SUN', 'MON', 'TUE', 'WED', 'THU'];
  final List<String> timeSlots = [
    '08:00 AM-\n08:50 AM',
    '08:50 AM-\n09:40 AM',
    '09:40 AM-\n10:30 AM',
    '10:30 AM-\n11:20 AM',
    '11:20 AM-\n12:10 PM',
    '12:10 PM-\n01:00 PM',
    '01:00 PM-\n01:50 PM',
    '01:50 PM-\n02:40 PM',
    '02:40 PM-\n03:30 PM',
    '03:30 PM-\n04:20 PM',
    '04:20 PM-\n05:10 PM',
    '05:10 PM-\n06:00 PM',
  ];

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      for (String day in days) {
        for (String time in timeSlots) {
          final key = '${day}_$time';
          routineData[key] = _prefs.getString(key) ?? '';
        }
      }
      isLoading = false;
    });
  }

  Future<void> _showEditDialog(String day, String time) async {
    final key = '${day}_$time';
    final controller = TextEditingController(text: routineData[key]);

    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Edit $day'),
          content: TextField(
            controller: controller,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'e.g. CSE 2104\n7B06\n(Islam, Ansary)',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE76C6C),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  routineData[key] = controller.text;
                });
                _prefs.setString(key, controller.text);
                Navigator.pop(ctx);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCell(String text, {bool isHeader = false, double width = 110}) {
    return Container(
      width: width,
      height: isHeader ? 55 : 75,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        color: isHeader ? Colors.grey.shade200 : Colors.white,
      ),
      padding: const EdgeInsets.all(4),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          fontSize: isHeader ? 11 : 10,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('My Routine'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: const Text(
                    'Tap any cell to edit',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: Column(
                          children: [
                            // Header Row
                            Row(
                              children: [
                                _buildCell(
                                  'Time/Day',
                                  isHeader: true,
                                  width: 75,
                                ),
                                ...timeSlots.map(
                                  (time) => _buildCell(time, isHeader: true),
                                ),
                              ],
                            ),
                            // Data Rows
                            ...days.map((day) {
                              return Row(
                                children: [
                                  _buildCell(day, isHeader: true, width: 75),
                                  ...timeSlots.map((time) {
                                    final key = '${day}_$time';
                                    return InkWell(
                                      onTap: () => _showEditDialog(day, time),
                                      child: _buildCell(
                                        routineData[key] ?? '',
                                        isHeader: false,
                                      ),
                                    );
                                  }),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
