import 'package:austmate/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

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
  String? selectedDepartment;

  final List<String> departments = [
    'Department of Architecture (ARCH)',
    'Department of Civil Engineering (CE)',
    'Department of Computer Science & Engineering (CSE)',
    'Department of Electrical & Electronic Engineering (EEE)',
    'Department of Industrial and Production Engineering (IPE)',
    'Department of Mechanical Engineering (ME)',
    'Department of Textile Engineering (TE)',
    'Department of School of Business (SoB)',
  ];

  Widget buildTextField(
    String label,
    IconData icon,
    TextEditingController controller, {
    bool obscureText = false,
    bool readOnly = false,
    String? hintText,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[50],
          prefixIcon: Icon(icon, color: const Color(0xFFD2042D), size: 20),
          labelText: label,
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Future<void> register() async {
    final email = emailController.text.trim();
    if (!email.endsWith('@aust.edu')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please use your @aust.edu email.')),
      );
      return;
    }

    if (selectedDepartment == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your department.')),
      );
      return;
    }

    final auth = AuthService();

    try {
      final response = await auth.signUp(
        email,
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
              'department': selectedDepartment,
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
                hintText: "example12@aust.edu",
              ),

              buildTextField(
                "Birth Date",
                Icons.calendar_today_outlined,
                birthController,
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      birthController.text =
                          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                    });
                  }
                },
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

              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: DropdownButtonFormField<String>(
                  isExpanded: true,
                  value: selectedDepartment,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[50],
                    prefixIcon: const Icon(
                      Icons.account_balance_outlined,
                      color: Color(0xFFD2042D),
                      size: 20,
                    ),
                    labelText: "Department",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: departments.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedDepartment = newValue;
                    });
                  },
                ),
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
                    backgroundColor: const Color(0xFFD2042D),
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
                        color: Color(0xFFD2042D),
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
