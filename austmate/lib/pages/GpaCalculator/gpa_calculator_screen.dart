import 'package:flutter/material.dart';
import 'course.dart';
import 'course_card.dart';

class GPACalculatorScreen extends StatelessWidget {
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
                    'GPA Calculator',
                    style: TextStyle(
                      color: Color(0xFFE76C6C),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Spring 2025',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Your GPA',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '3.85',
                            style: TextStyle(
                              color: Color(0xFF6FCF97),
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 48),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Total Credits',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '16',
                            style: TextStyle(
                              color: Colors.black26,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: CourseCard(course: course),
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