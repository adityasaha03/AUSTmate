import 'package:flutter/material.dart';
import 'package:austmate/services/google_auth_service.dart';
import 'package:austmate/pages/Profile/scheduler_page.dart';

class ConnectPage extends StatefulWidget {
  const ConnectPage({super.key});

  @override
  State<ConnectPage> createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
  bool _loading = false;

  Future<void> _connect() async {
    setState(() => _loading = true);
    final success = await GoogleAuthService.connectGoogle();
    setState(() => _loading = false);

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SchedulerPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Google sign-in failed or was cancelled.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Let's get you connected...",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 40),
            Image.asset("assets/images/google_logo.png", height: 50),
            const SizedBox(height: 50),
            _loading
                ? const CircularProgressIndicator(color: Color(0xFFE53935))
                : ElevatedButton(
                    onPressed: _connect,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE53935),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Connect with Google",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}