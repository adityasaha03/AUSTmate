import 'package:austmate/pages/GpaCalculator/cgpa_calculator_screen.dart';
import 'package:austmate/pages/HomeScreen/home_screen.dart';
import 'package:austmate/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:austmate/pages/library_page.dart';
import 'package:austmate/pages/Profile/profile_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ckwhsciuixnrormdvtzz.supabase.co',
    anonKey: 'sb_publishable_fWbnazxZAqAZjDXkoKS0jQ_Rf2s_l7R',
  );

  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: SplashScreen()),
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
      currentPage = const HomeScreen();
    } else if (currentIndex == 1) {
      currentPage = const LibraryPage();
    } else if (currentIndex == 2) {
      currentPage = SemesterCGPACalculatorScreen();
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
