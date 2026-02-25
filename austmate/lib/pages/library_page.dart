import 'package:flutter/material.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
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
  Widget build(BuildContext context) {
    Widget MaterialCard(
      String courseName,
      String courseDetails,
      String driveName,
      String shareLink,
    ) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Card(
          elevation: 10,
          //color: Color(0xFFE1625F),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.file_copy, color: Color(0xFFE1625F)),
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              courseName,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                //color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              courseDetails,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                //color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Card(
                      //elevation: 10,
                      color: Color(0xFFFF5A5F),
                      //color: Color(0xFFFF8A80),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          print("Tap on ${driveName}");
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.drive_file_move,
                                //color: Color(0xFFE1625F),
                                color: Colors.white,
                              ),
                              SizedBox(width: 15),
                              Text(
                                "Open in Drive",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    //SizedBox(width: 15),
                    Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xFFF2FEF7),
                        border: Border.all(color: Colors.red, width: 1.5),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          print("Tap on $shareLink");
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.share, color: Color(0xFFE1625F)),
                              SizedBox(width: 8),
                              Text("Share Link"),
                            ],
                          ),
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

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Align(
                alignment: AlignmentGeometry.centerLeft,
                child: Text(
                  "Drive & Resources",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade400,
                      blurRadius: 6,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search Materials",
                    prefixIcon: Icon(Icons.search, color: Color(0xFFE1625F)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Select Semester", style: TextStyle(fontSize: 14)),
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey),
                  color: Colors.white,
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
            ),
            SizedBox(height: 25),
            MaterialCard(
              "Software Development - II",
              "CSE 2100",
              "CSE 2100",
              "Share Link",
            ),
            MaterialCard(
              "Data Structure",
              "CSE 2103",
              "CSE 2103",
              "Share Link",
            ),
            MaterialCard(
              "Data Structure Lab",
              "CSE 2104",
              "CSE 2104",
              "Share Link",
            ),
            MaterialCard(
              "Digital Logic Design",
              "CSE 2105",
              "CSE 2105",
              "Share Link",
            ),
            MaterialCard(
              "Digital Logic Design Lab",
              "CSE 2106",
              "CSE 2106",
              "Share Link",
            ),
            MaterialCard(
              "Electrical and Electronic Engineering",
              "EEE 2141",
              "EEE 2141",
              "Share Link",
            ),
          ],
        ),
      ),
    );
  }
}
