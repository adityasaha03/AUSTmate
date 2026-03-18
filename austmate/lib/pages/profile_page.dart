import 'package:austmate/pages/connect_google_page.dart';
import 'package:austmate/pages/login_page.dart';
import 'package:austmate/pages/scheduler_page.dart';
import 'package:austmate/services/google_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final supabase = Supabase.instance.client;

  String name = "";
  String studentId = "";

  String selectedSemester = "Year 1 Semester 1";

  List<String> semesterList = [
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
    loadProfile();
  }

  Future<void> loadProfile() async {
    final user = supabase.auth.currentUser;

    if (user != null) {
      final data = await supabase
          .from('students')
          .select()
          .eq('id', user.id)
          .single();

      setState(() {
        name = "${data['first_name']} ${data['last_name']}";
        studentId = data['student_id'] ?? "";
      });
    }
  }

  Future<void> logout() async {
    await supabase.auth.signOut();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  Future<void> _onSetSchedule() async {
    final connected = await GoogleAuthService.isConnected();
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => connected ? const SchedulerPage() : const ConnectPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [
              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 10),
                  ],
                ),

                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 45,
                      backgroundColor: Color.fromARGB(255, 233, 195, 184),
                      foregroundColor: Color(0xFFE1625F),
                      child: Icon(Icons.person, size: 40),
                    ),

                    const SizedBox(height: 15),

                    Text(
                      "Name: $name",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Computer Science and Engineering",
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 5),

                    Text("Student ID: $studentId", textAlign: TextAlign.center),

                    const SizedBox(height: 5),

                    const Text(
                      "Ahsanullah University of Science & Technology",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(height: 20),

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Select Semester"),
                    ),

                    const SizedBox(height: 5),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey),
                      ),

                      child: DropdownButton<String>(
                        value: selectedSemester,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        underline: const SizedBox(),

                        items: semesterList.map((semester) {
                          return DropdownMenuItem(
                            value: semester,
                            child: Text(
                              semester,
                              style: const TextStyle(fontSize: 14),
                            ),
                          );
                        }).toList(),

                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              selectedSemester = value;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _onSetSchedule,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE53935),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),

                      child: const Text(
                        "Set Schedule",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: logout,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE53935),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),

                      child: const Text(
                        "Logout",
                        style: TextStyle(color: Colors.white),
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