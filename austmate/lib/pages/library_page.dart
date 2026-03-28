import 'package:austmate/data/library_data.dart';
import 'package:austmate/pages/drive_viewer_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  String selectedSemester = "All";
  String searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  List<String> semesterList = [
    "All",
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
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget MaterialCard(
      String courseName,
      String courseDetails,
      String driveLink,
      String shareLink,
    ) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
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
                      Icon(Icons.file_copy, color: Color(0xFFD2042D), size: 35),
                      SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text(
                              courseName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "source - $courseDetails",
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Card(
                      //elevation: 10,
                      color: Color(0xFFD2042D),
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
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.drive_file_move,
                                //color: Color(0xFFE1625F),
                                color: Colors.white,
                              ),
                              SizedBox(width: 8),
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
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0xFFF2FEF7),
                        border: Border.all(color: Color(0xFFD2042D), width: 1.5),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () async {
                          await Clipboard.setData(
                            ClipboardData(text: driveLink),
                          );

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Link copied to clipboard!"),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }

                          await Share.share(
                            "Check out this resource for $courseName: $driveLink",
                            subject: "AUST Mate Resource",
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.share, color: Color(0xFFD2042D)),
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

    final filteredCardsBySemester = selectedSemester == "All"
        ? libraryCards
        : libraryCards
              .where((card) => card.semester == selectedSemester)
              .toList();

    final filteredCards = filteredCardsBySemester.where((card) {
      final query = searchQuery.toLowerCase();
      return card.courseName.toLowerCase().contains(query) ||
          card.courseDetails.toLowerCase().contains(query);
    }).toList();

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
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Search Materials",
                      prefixIcon: Icon(Icons.search, color: Color(0xFFD2042D)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
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
              const SizedBox(height: 25),
              ...filteredCards.map(
                (card) => MaterialCard(
                  card.courseDetails,
                  card.courseName,
                  card.driveLink,
                  "Share Link",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
