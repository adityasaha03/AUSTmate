import 'package:austmate/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final birthController = TextEditingController();
  final phoneController = TextEditingController();
  final studentIdController = TextEditingController();

  Widget buildTextField(
    String label,
    IconData icon,
    TextEditingController controller, {
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[50],
          prefixIcon: Icon(icon, color: const Color(0xFFE53935), size: 20),
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Future<void> register() async {
    final auth = AuthService();

    try {
      final response = await auth.signUp(
        emailController.text.trim(),
        passwordController.text.trim(),
        firstNameController.text.trim(),
        lastNameController.text.trim(),
      );

      final user = response.user;

      if (user != null) {
        await Supabase.instance.client
            .from('students')
            .update({
              'birth_date': birthController.text,
              'phone_number': phoneController.text,
              'student_id': studentIdController.text,
            })
            .eq('id', user.id);
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Create Account",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 9),

              Text(
                "Join AustMate to get started",
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),

              const SizedBox(height: 35),

              Row(
                children: [
                  Expanded(
                    child: buildTextField(
                      "First Name",
                      Icons.person_outline,
                      firstNameController,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: buildTextField(
                      "Last Name",
                      Icons.person_outline,
                      lastNameController,
                    ),
                  ),
                ],
              ),

              buildTextField(
                "Email Address",
                Icons.email_outlined,
                emailController,
              ),

              buildTextField(
                "Birth Date",
                Icons.calendar_today_outlined,
                birthController,
              ),

              buildTextField(
                "Phone Number",
                Icons.phone_android_outlined,
                phoneController,
              ),

              buildTextField(
                "Student ID",
                Icons.badge_outlined,
                studentIdController,
              ),

              buildTextField(
                "Set Password",
                Icons.lock_outline,
                passwordController,
                obscureText: true,
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE53935),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "SIGN UP",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Have an account? ",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: Color(0xFFE53935),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
