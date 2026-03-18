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
    "HUM 1107", "HUM 1108", "MATH 1115", "PHY 1115", "PHY 1116",
    "CHEM 1115", "CSE 1101", "CSE 1102", "CSE 1108",
  ],
  "Year 1 Semester 2": [
    "MATH 1219", "ME 1211", "ME 1214", "EEE 1241", "EEE 1242",
    "CSE 1200", "CSE 1203", "CSE 1205", "CSE 1206",
  ],
  "Year 2 Semester 1": [
  "HUM 2109", "MATH 2101", "EEE 2141", "EEE 2142", "CSE 2100",
  "CSE 2103", "CSE 2104", "CSE 2105", "CSE 2106",
  ],
  "Year 2 Semester 2": [
    "MATH 2203", "CSE 2200", "CSE 2201", "CSE 2202", "CSE 2207",
    "CSE 2208", "CSE 2211", "CSE 2213", "CSE 2214",
  ],
  "Year 3 Semester 1": [
    "HUM 3115", "CSE 3100", "CSE 3101", "CSE 3103", "CSE 3104",
    "CSE 3109", "CSE 3110", "CSE 3117", "CSE 3118",
  ],
  "Year 3 Semester 2": [
    "HUM 3207", "CSE 3200", "CSE 3201", "CSE 3202", "CSE 3207",
    "CSE 3208", "CSE 3213", "CSE 3214", "CSE 3223", "CSE 3224",
  ],
  "Year 4 Semester 1": [
    "IPE 4111", "CSE 4100", "CSE 4113", "CSE 4114", "CSE 4129", "CSE 4130",
    "CSE 4131", "CSE 4132", "CSE 4137", "CSE 4138", "CSE 4139", "CSE 4140",
    "CSE 4141", "CSE 4142", "CSE 4143", "CSE 4144", "CSE 4147", "CSE 4148",
    "CSE 4173", "CSE 4174", "CSE 4175", "CSE 4176", "CSE 4181", "CSE 4182",
  ],
  "Year 4 Semester 2": [
    "CSE 4203", "CSE 4204", "CSE 4250", "CSE 4209", "CSE 4210", "CSE 4211",
    "CSE 4212", "CSE 4225", "CSE 4226", "CSE 4227", "CSE 4228", "CSE 4257",
    "CSE 4258", "CSE 4261", "CSE 4262", "CSE 4263", "CSE 4264", "CSE 4283",
    "CSE 4284", "CSE 4285", "CSE 4286",
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