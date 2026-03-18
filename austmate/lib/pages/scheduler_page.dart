import 'package:austmate/services/calendar_service.dart';
import 'package:flutter/material.dart';

class SchedulerPage extends StatefulWidget {
  const SchedulerPage({super.key});

  @override
  State<SchedulerPage> createState() => _SchedulerPageState();
}

class _SchedulerPageState extends State<SchedulerPage> {
  String selectedSemester = "Year 1 Semester 1";
  String? selectedCourse;
  DateTime? repeatUntil;
  bool _saving = false;

  final List<String> semesterList = [
    "Year 1 Semester 1",
    "Year 1 Semester 2",
    "Year 2 Semester 1",
    "Year 2 Semester 2",
    "Year 3 Semester 1",
    "Year 3 Semester 2",
    "Year 4 Semester 1",
    "Year 4 Semester 2",
  ];

  // Course list per semester
  static const Map<String, List<String>> semesterCourses = {
  "Year 1 Semester 1": [
    "HUM1107", "HUM1108", "MATH1115", "PHY1115", "PHY1116",
    "CHEM1115", "CSE1101", "CSE1102", "CSE1108",
  ],
  "Year 1 Semester 2": [
    "MATH1219", "ME1211", "ME1214", "EEE1241", "EEE1242",
    "CSE1200", "CSE1203", "CSE1205", "CSE1206",
  ],
  "Year 2 Semester 1": [
    "HUM2109", "MATH2101", "EEE2141", "EEE2142", "CSE2100",
    "CSE2103", "CSE2104", "CSE2105", "CSE2106",
  ],
  "Year 2 Semester 2": [
    "MATH2203", "CSE2200", "CSE2201", "CSE2202", "CSE2207",
    "CSE2208", "CSE2211", "CSE2213", "CSE2214",
  ],
  "Year 3 Semester 1": [
    "HUM3115", "CSE3100", "CSE3101", "CSE3103", "CSE3104",
    "CSE3109", "CSE3110", "CSE3117", "CSE3118",
  ],
  "Year 3 Semester 2": [
    "HUM3207", "CSE3200", "CSE3201", "CSE3202", "CSE3207",
    "CSE3208", "CSE3213", "CSE3214", "CSE3223", "CSE3224",
  ],
  "Year 4 Semester 1": [
    "IPE4111", "CSE4100", "CSE4113", "CSE4114", "CSE4129", "CSE4130",
    "CSE4131", "CSE4132", "CSE4137", "CSE4138", "CSE4139", "CSE4140",
    "CSE4141", "CSE4142", "CSE4143", "CSE4144", "CSE4147", "CSE4148",
    "CSE4173", "CSE4174", "CSE4175", "CSE4176", "CSE4181", "CSE4182",
  ],
  "Year 4 Semester 2": [
    "CSE4203", "CSE4204", "CSE4250", "CSE4209", "CSE4210", "CSE4211",
    "CSE4212", "CSE4225", "CSE4226", "CSE4227", "CSE4228", "CSE4257",
    "CSE4258", "CSE4261", "CSE4262", "CSE4263", "CSE4264", "CSE4283",
    "CSE4284", "CSE4285", "CSE4286",
  ],
};

  List<String> get currentCourses =>
      semesterCourses[selectedSemester] ?? [];

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

  Future<void> _pickTime(
      BuildContext context, Function(TimeOfDay) onPicked) async {
    final picked = await showTimePicker(
        context: context, initialTime: TimeOfDay.now());
    if (picked != null) onPicked(picked);
  }

  Future<void> _pickRepeatUntil() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: "Repeat events until...",
    );
    if (picked != null) setState(() => repeatUntil = picked);
  }

  Widget _buildTimeRow(
    String label,
    TimeOfDay? from,
    TimeOfDay? to,
    Function(TimeOfDay) onFrom,
    Function(TimeOfDay) onTo,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _pickTime(context, onFrom),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 14, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(from?.format(context) ?? "From",
                      textAlign: TextAlign.center),
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Text("—"),
            const SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: () => _pickTime(context, onTo),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 14, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(to?.format(context) ?? "To",
                      textAlign: TextAlign.center),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _save() async {
    if (selectedCourse == null) {
      _snack("Please select a course.");
      return;
    }

    final selectedDays = weekdays.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();

    if (selectedDays.isEmpty) {
      _snack("Please select at least one weekday.");
      return;
    }

    if (repeatUntil == null) {
      _snack("Please set a repeat-until date.");
      return;
    }

    final startTimes = [oneFrom, twoFrom, threeFrom];
    final endTimes = [oneTo, twoTo, threeTo];

    for (int i = 0; i < selectedDays.length; i++) {
      final start = i < startTimes.length ? startTimes[i] : null;
      final end = i < endTimes.length ? endTimes[i] : null;
      if (start == null || end == null) {
        _snack("Please set times for Day ${i + 1}.");
        return;
      }
    }

    setState(() => _saving = true);

    try {
      await CalendarService.createEventsForSchedule(
        courseName: selectedCourse!,
        selectedDays: selectedDays,
        startTimes: startTimes,
        endTimes: endTimes,
        repeatUntil: repeatUntil!,
      );
      _snack("Schedule saved to Google Calendar ✅");
    } catch (e) {
      _snack("Failed: $e");
    } finally {
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final repeatLabel = repeatUntil == null
        ? "Select date..."
        : "${repeatUntil!.year}-${_pad(repeatUntil!.month)}-${_pad(repeatUntil!.day)}";

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
              borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // --- Semester ---
                  const Text("Semester",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedSemester,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: semesterList
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) {
                        setState(() {
                          selectedSemester = v;
                          selectedCourse = null; // reset course on semester change
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  // --- Course ---
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
                    items: currentCourses
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) => setState(() => selectedCourse = v),
                  ),

                  const SizedBox(height: 30),

                  // --- Weekdays ---
                  const Text("Weekdays",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  Row(
                    children: weekdays.keys.map((day) {
                      final isSelected = weekdays[day]!;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => weekdays[day] = !isSelected),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin:
                                const EdgeInsets.symmetric(horizontal: 4),
                            padding:
                                const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFE53935)
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(25),
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

                  const SizedBox(height: 30),

                  // --- Time slots ---
                  _buildTimeRow(
                    "Time (Day 1)",
                    oneFrom, oneTo,
                    (v) => setState(() => oneFrom = v),
                    (v) => setState(() => oneTo = v),
                  ),
                  _buildTimeRow(
                    "Time (Day 2)",
                    twoFrom, twoTo,
                    (v) => setState(() => twoFrom = v),
                    (v) => setState(() => twoTo = v),
                  ),
                  _buildTimeRow(
                    "Time (Day 3)",
                    threeFrom, threeTo,
                    (v) => setState(() => threeFrom = v),
                    (v) => setState(() => threeTo = v),
                  ),

                  // --- Repeat Until ---
                  const Text("Repeat Until",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: _pickRepeatUntil,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              size: 18, color: Color(0xFFE53935)),
                          const SizedBox(width: 10),
                          Text(
                            repeatLabel,
                            style: TextStyle(
                              color: repeatUntil == null
                                  ? Colors.grey
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // --- Save ---
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: _saving ? null : _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE53935),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 28, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 3,
                      ),
                      child: _saving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2))
                          : const Text("Save",
                              style:
                                  TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _pad(int n) => n.toString().padLeft(2, '0');
}