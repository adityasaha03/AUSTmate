import 'package:flutter/material.dart';

class SchedulerPage extends StatefulWidget {
  const SchedulerPage({super.key});

  @override
  State<SchedulerPage> createState() => _SchedulerPageState();
}

class _SchedulerPageState extends State<SchedulerPage> {
  String? selectedCourse;

  Map<String, bool> weekdays = {
    "Sunday": false,
    "Monday": false,
    "Tuesday": false,
    "Wednesday": false,
    "Thursday": false,
  };

  TimeOfDay? oneFrom, oneTo;
  TimeOfDay? twoFrom, twoTo;
  TimeOfDay? threeFrom, threeTo;

  Future<void> pickTime(BuildContext context, Function(TimeOfDay) onPicked) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) onPicked(picked);
  }

  Widget buildTimeRow(String label, TimeOfDay? from, TimeOfDay? to,
      Function(TimeOfDay) onFrom, Function(TimeOfDay) onTo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded( 
              child: GestureDetector(
                onTap: () => pickTime(context, onFrom),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(from?.format(context) ?? "From",textAlign: TextAlign.center),
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Text("—"),
            const SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: () => pickTime(context, onTo),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(to?.format(context) ?? "To", textAlign: TextAlign.center),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text("Scheduler"),
      leading: const BackButton(),
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
    ),
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// Course Dropdown
                const Text("Course",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedCourse,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  hint: const Text("Select Course..."),
                  items: ["CSE2100", "CSE2103", "CSE2105"]
                      .map((course) => DropdownMenuItem(
                            value: course,
                            child: Text(course),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() => selectedCourse = value);
                  },
                ),

                const SizedBox(height: 35),

                /// Weekdays
                const Text("Weekdays",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                Row(
                  children: weekdays.keys.map((day) {
                    final bool isSelected = weekdays[day]!;

                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            weekdays[day] = !isSelected;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin:
                              const EdgeInsets.symmetric(horizontal: 4),
                          padding:
                              const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFE76C6C)
                                : Colors.grey.shade200,
                            borderRadius:
                                BorderRadius.circular(25),
                          ),
                          child: Center(
                            child: Text(
                              day.substring(0, 3),
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 40),

                /// Time Sections
                buildTimeRow(
                  "Time (Day 1)",
                  oneFrom,
                  oneTo,
                  (val) => setState(() => oneFrom = val),
                  (val) => setState(() => oneTo = val),
                ),

                buildTimeRow(
                  "Time (Day 2)",
                  twoFrom,
                  twoTo,
                  (val) => setState(() => twoFrom = val),
                  (val) => setState(() => twoTo = val),
                ),

                buildTimeRow(
                  "Time (Day 3)",
                  threeFrom,
                  threeTo,
                  (val) => setState(() => threeFrom = val),
                  (val) => setState(() => threeTo = val),
                ),

                const SizedBox(height: 20),

                /// ✅ Pill Button (Added Here)
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Add save logic
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFFE76C6C), // matches weekday color
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30), // pill shape
                      ),
                      elevation: 3,
                    ),
                    child: const Text(
                      "Save",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
}