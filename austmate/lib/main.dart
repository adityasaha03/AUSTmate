import 'package:austmate/pages/login_page.dart';
import 'package:flutter/material.dart';

import 'pages/home_page.dart';
import 'pages/library_page.dart';
import 'pages/profile_page.dart';
import 'pages/cg_calculator_page.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      //home: SimpleNavigation(),
      home: LoginPage(),
    ),
  );
}

class SimpleNavigation extends StatefulWidget {
  const SimpleNavigation({super.key});

  @override
  State<SimpleNavigation> createState() => _SimpleNavigationState();
}

class _SimpleNavigationState extends State<SimpleNavigation> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget currentPage;

    if (currentIndex == 0) {
      currentPage = const HomePage();
    } else if (currentIndex == 1) {
      currentPage = const LibraryPage();
    } else if (currentIndex == 2) {
      currentPage = const CgCalculatorPage();
    } else {
      currentPage = const ProfilePage();
    }

    return Scaffold(
      body: currentPage,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Library"),
          BottomNavigationBarItem(icon: Icon(Icons.calculate), label: "CGPA"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        backgroundColor: Color(0xFFEFEEF2),
        selectedItemColor: Color(0xFFFF6F61),
        unselectedItemColor: Color(0xFF7A818E),
      ),
    );
  }
}
