import 'package:austmate/main.dart';
import 'package:austmate/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;
  late Animation<double> fadeAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeIn));

    controller.forward();

    checkLogin();
  }

  Future<void> checkLogin() async {
    await Future.delayed(const Duration(seconds: 3));

    final session = Supabase.instance.client.auth.currentSession;

    Widget nextPage;

    if (session != null) {
      nextPage = const SimpleNavigation();
    } else {
      nextPage = const LoginPage();
    }

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => nextPage,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          Tween<double> fadeTween = Tween(begin: 0.0, end: 1.0);

          Tween<Offset> slideTween = Tween(
            begin: const Offset(0.0, 0.25),
            end: Offset.zero,
          );

          return FadeTransition(
            opacity: animation.drive(fadeTween),
            child: SlideTransition(
              position: animation.drive(slideTween),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            ScaleTransition(
              scale: scaleAnimation,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFE53935),
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
            ),

            const SizedBox(height: 20),

            FadeTransition(
              opacity: fadeAnimation,
              child: const Text(
                "AUSTmate",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE53935),
                ),
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
