import 'package:flutter/material.dart';
import 'course.dart';
import 'course_card.dart';
import 'course_data.dart';

class SemesterCGPACalculatorScreen extends StatefulWidget {
  const SemesterCGPACalculatorScreen({super.key});

  @override
  State<SemesterCGPACalculatorScreen> createState() =>
      _SemesterCGPACalculatorScreenState();
}

class _SemesterCGPACalculatorScreenState
    extends State<SemesterCGPACalculatorScreen> {
  String selectedSemester = "Year 1 Semester 1";
  late List<Course> courses;

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

  @override
  void initState() {
    super.initState();
    _loadSemesterCourses();
  }

  void _loadSemesterCourses() {
    courses = CourseData.semesterCourses[selectedSemester]!
        .map(
          (c) => Course(
            code: c.code,
            title: c.title,
            credits: c.credits,
            grade: c.grade,
          ),
        )
        .toList();
  }

  double get totalCredits =>
      courses.fold(0.0, (sum, item) => sum + item.credits);

  double get totalGradePoints {
    return courses.fold(
      0.0,
      (sum, item) => sum + (item.gradePoints * item.credits),
    );
  }

  double get currentGPA =>
      totalCredits > 0 ? totalGradePoints / totalCredits : 0.0;

  void _updateGrade(int index, String newGrade) {
    setState(() {
      courses[index].grade = newGrade;
    });
  }

  void _updateCode(int index, String newCode) {
    setState(() {
      courses[index].code = newCode;
    });
  }

  void _updateTitle(int index, String newTitle) {
    setState(() {
      courses[index].title = newTitle;
    });
  }

  void _updateCredits(int index, double newCredits) {
    setState(() {
      courses[index].credits = newCredits;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Quick GPA Calculator",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Select Semester",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey),
                      color: Colors.white,
                    ),
                    child: DropdownButton<String>(
                      value: selectedSemester,
                      isExpanded: true,
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Color(0xFFD2042D),
                      ),
                      underline: const SizedBox(),
                      items: semesterList.map((semester) {
                        return DropdownMenuItem(
                          value: semester,
                          child: Text(
                            semester,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedSemester = value;
                            _loadSemesterCourses();
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSummaryItem(
                        'Your GPA',
                        currentGPA.toStringAsFixed(2),
                      ),
                      _buildSummaryItem(
                        'Total Credits',
                        totalCredits
                            .toStringAsFixed(2)
                            .replaceAll(RegExp(r'\.00$'), ''),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: courses.isEmpty
                  ? Center(
                      child: Text(
                        'No courses found',
                        style: TextStyle(color: Colors.grey[400], fontSize: 18),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: courses.length,
                      itemBuilder: (context, index) {
                        final course = courses[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: CourseCard(
                            key: ValueKey('${selectedSemester}_${course.code}'),
                            course: course,
                            onDeleted: () {}, // Not used anymore
                            onGradeChanged: (newGrade) =>
                                _updateGrade(index, newGrade),
                            onCodeChanged: (newCode) =>
                                _updateCode(index, newCode),
                            onTitleChanged: (newTitle) =>
                                _updateTitle(index, newTitle),
                            onCreditsChanged: (newCredits) =>
                                _updateCredits(index, newCredits),
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

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
