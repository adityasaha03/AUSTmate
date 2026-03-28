import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('About'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),

            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFD2042D),
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 12),
                ],
              ),
              child: const Icon(
                Icons.school_rounded,
                size: 56,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'AUSTmate',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFFD2042D),
              ),
            ),

            const SizedBox(height: 6),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFD2042D).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Version 1.0.0',
                style: TextStyle(fontSize: 13, color: Color(0xFFD2042D)),
              ),
            ),

            const SizedBox(height: 28),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About the App',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'AUSTmate is a student companion app designed exclusively for students of Ahsanullah University of Science & Technology (AUST).\n\n'
                    'The app helps students manage their academic life more efficiently by providing:\n'
                    '• A personalized class routine planner\n'
                    '• A class schedule viewer for the home screen\n'
                    '• A university library & resource hub\n'
                    '• A CGPA & GPA calculator\n'
                    '• A task & deadline tracker\n\n'
                    'AUSTmate was built with simplicity and student productivity in mind — making campus life a little easier, one feature at a time.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Developed By',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _developerTile(
                    name: 'Md. Mushfiqur Rahman Mahin',
                    icon: Icons.person_rounded,
                  ),
                  const Divider(height: 24),
                  _developerTile(
                    name: 'Aditya Saha',
                    icon: Icons.person_rounded,
                  ),
                  const Divider(height: 24),
                  _developerTile(
                    name: 'Sadia Islam Irina',
                    icon: Icons.person_rounded,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFD2042D).withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFD2042D).withValues(alpha: 0.3),
                ),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.location_city_rounded,
                    color: Color(0xFFD2042D),
                    size: 32,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Ahsanullah University of\nScience & Technology',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFD2042D),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Tejgaon, Dhaka, Bangladesh',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              '© 2026 AUSTmate. All rights reserved.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  static Widget _developerTile({required String name, required IconData icon}) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: const Color(0xFFD2042D).withValues(alpha: 0.15),
          child: Icon(icon, color: const Color(0xFFD2042D), size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            name,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
