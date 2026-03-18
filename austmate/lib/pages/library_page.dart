import 'package:austmate/pages/drive_viewer_page.dart';
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
      String driveLink,
      String shareLink,
    ) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Card(
          elevation: 10,
          //color: Color(0xFFE53935),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.file_copy, color: Color(0xFFE53935)),
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
                      color: Color(0xFFE53935),
                      //color: Color(0xFFFF8A80),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DriveViewerPage(
                              driveUrl: driveLink,
                              title: courseName,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              SizedBox(width: 5),
                              Icon(
                                Icons.drive_file_move,
                                //color: Color(0xFFE53935),
                                color: Colors.white,
                              ),
                              SizedBox(width: 9),
                              Text(
                                "Open in Drive",
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(width: 5),
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
                              Icon(Icons.share, color: Color(0xFFE53935)),
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 22),
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
                      prefixIcon: Icon(Icons.search, color: Color(0xFFE53935)),
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
                  child: Text(
                    "Select Semester",
                    style: TextStyle(fontSize: 14),
                  ),
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
                "https://drive.google.com/drive/folders/1OzCL8utxKeIZ02U7G0W18WHJq6O6GLxD",
                "Share Link",
              ),
              MaterialCard(
                "Data Structure",
                "CSE 2103",
                "https://drive.google.com/drive/folders/1OzCL8utxKeIZ02U7G0W18WHJq6O6GLxD",
                "Share Link",
              ),
              MaterialCard(
                "Data Structure Lab",
                "CSE 2104",
                "https://drive.google.com/drive/folders/1c-qFFuClCJ-dJ5rmg23ZlILSOXkyPXpk",
                "Share Link",
              ),
              MaterialCard(
                "Digital Logic Design",
                "CSE 2105",
                "https://drive.google.com/drive/folders/13JJBrnZ14gvETyiQ3efMFPybC9JhTH95",
                "Share Link",
              ),
              MaterialCard(
                "Digital Logic Design Lab",
                "CSE 2106",
                "https://drive.google.com/drive/folders/16JEjtO9TXtjeR8VUjsJ3-cYb-GPFzyoE",
                "Share Link",
              ),
              MaterialCard(
                "Electrical and Electronic Engineering",
                "EEE 2141",
                "https://drive.google.com/drive/folders/1b0guabwf3--mXyhY48i72365WpKDDaYf",
                "Share Link",
              ),
              MaterialCard(
                "Electrical and Electronic Engineering Lab",
                "EEE 2141",
                "https://drive.google.com/drive/folders/1rU1A6j8YJ8m25aKbVNLKmO-YDIqcfQJe",
                "Share Link",
              ),
              MaterialCard(
                "Society, Ethics & Technology",
                "HUM 2109",
                "https://drive.google.com/drive/folders/1Pr6DyapwjZBaGZxTajrtnAHmdtlQju-3",
                "Share Link",
              ),
              MaterialCard(
                "Complex Variable, Laplace Transformation & Statistics",
                "MATH 2101",
                "https://drive.google.com/drive/folders/1TiaLChE_sZH6fBJFjgnr1K9IQItLUpQl",
                "Share Link",
              ),
              MaterialCard(
                "Question Bank",
                "Previous Year Question Bank",
                "https://drive.google.com/drive/folders/1cMcqFWDa_HERZLzvuFk5FBa7GJqvjgyv",
                "Share Link",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
