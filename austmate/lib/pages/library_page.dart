import 'package:flutter/material.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    Widget MaterialCard(String courseName, String courseDetails) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Card(
          elevation: 10,
          //color: Color(0xFFE1625F),
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
                      elevation: 10,
                      color: Color(0xFFF2FEF7),
                      //color: Color(0xFFFF8A80),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.drive_file_move,
                              color: Color(0xFFE1625F),
                            ),
                            SizedBox(width: 15),
                            Text("Open in Drive"),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    Card(
                      elevation: 10,
                      color: Color(0xFFF2FEF7),
                      //color: Color(0xFFFF8A80),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Row(
                          children: [
                            Icon(Icons.share, color: Color(0xFFE1625F)),
                            SizedBox(width: 15),
                            Text("Share Link"),
                          ],
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Align(
                alignment: AlignmentGeometry.centerLeft,
                child: Text(
                  "Drive & Resources",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
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
            SizedBox(height: 25),
            MaterialCard("Software Development - II", "CSE 2100"),
            MaterialCard("Data Structure", "CSE 2103"),
            MaterialCard("Data Structure Lab", "CSE 2104"),
            MaterialCard("Digital Logic Design", "CSE 2105"),
            MaterialCard("Digital Logic Design Lab", "CSE 2106"),
            MaterialCard("Electrical and Electronic Engineering", "EEE 2141"),
          ],
        ),
      ),
    );
  }
}
