import 'package:austmate/services/calendar_service.dart';
import 'package:flutter/material.dart';

class SchedulerPage extends StatefulWidget {
  const SchedulerPage({super.key});

  @override
  State<SchedulerPage> createState() => _SchedulerPageState();
}

class _SchedulerPageState extends State<SchedulerPage> {
  String? selectedCourse;
  DateTime? repeatUntil;
  bool _saving = false;

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

    // Each selected day maps to its own time slot
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
                  // Course
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
                        .map((c) =>
                            DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) => setState(() => selectedCourse = v),
                  ),

                  const SizedBox(height: 30),

                  // Weekdays
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
                                  ? const Color(0xFFE76C6C)
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

                  // Time slots
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

                  // Repeat Until
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
                              size: 18, color: Color(0xFFE76C6C)),
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

                  // Save button
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: _saving ? null : _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE76C6C),
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