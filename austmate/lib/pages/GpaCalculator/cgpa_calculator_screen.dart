import 'package:flutter/material.dart';
import 'course.dart';
import 'course_card.dart';

class SemesterCGPACalculatorScreen extends StatefulWidget {
  const SemesterCGPACalculatorScreen({super.key});

  @override
  State<SemesterCGPACalculatorScreen> createState() => _SemesterCGPACalculatorScreenState();
}

class _SemesterCGPACalculatorScreenState extends State<SemesterCGPACalculatorScreen> {
  final List<Course> courses = [
    Course(
      code: 'CSE 2100',
      title: 'Software Development II',
      credits: 3,
      grade: 'A',
    ),
    Course(
      code: 'CSE 2103',
      title: 'Data Structures',
      credits: 3,
      grade: 'A',
    ),
    Course(
      code: 'CSE 2105',
      title: 'Digital Logic Design',
      credits: 3,
      grade: 'A',
    ),
    Course(
      code: 'HUM 2109',
      title: 'Society, Ethics and Technology',
      credits: 3,
      grade: 'A',
    ),
  ];

  double get totalCredits => courses.fold(0.0, (sum, item) => sum + item.credits);
  
  double get totalGradePoints {
    return courses.fold(0.0, (sum, item) => sum + (item.gradePoints * item.credits));
  }

  double get currentGPA => totalCredits > 0 ? totalGradePoints / totalCredits : 0.0;

  void _addCourse() {
    setState(() {
      courses.add(Course(
        code: 'NEW COURSE',
        title: 'Course Title',
        credits: 3.0,
        grade: 'A',
      ));
    });
  }

  void _deleteCourse(int index) {
    setState(() {
      courses.removeAt(index);
    });
  }

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
                    'Spring 2025',
                    style: TextStyle(
                      color: Color(0xFFE53935),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSummaryItem('Your GPA', currentGPA.toStringAsFixed(2)),
                      _buildSummaryItem('Total Credits', totalCredits.toStringAsFixed(2).replaceAll(RegExp(r'\.00$'), '')),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: courses.isEmpty
                  ? Center(
                      child: Text(
                        'No courses added yet',
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
                            course: course,
                            onDeleted: () => _deleteCourse(index),
                            onGradeChanged: (newGrade) => _updateGrade(index, newGrade),
                            onCodeChanged: (newCode) => _updateCode(index, newCode),
                            onTitleChanged: (newTitle) => _updateTitle(index, newTitle),
                            onCreditsChanged: (newCredits) => _updateCredits(index, newCredits),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCourse,
        backgroundColor: const Color(0xFFE53935),
        child: const Icon(Icons.add, color: Colors.white),
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