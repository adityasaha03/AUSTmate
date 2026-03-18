import 'package:flutter/material.dart';
import '../Profile/scheduler_page.dart' ;

class ScheduleBox extends StatelessWidget {
  const ScheduleBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: const Color(0xFFF6F2F2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  ScheduleText("09:40-10:30", "EEE 2141 ..."),
                  ScheduleText("10:30-11:20", "HUM 2109..."),
                  ScheduleText("11:20-12:10", "CSE 2105..."),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: IconButton(
              icon: Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: Colors.black.withOpacity(0.5),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SchedulerPage(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ScheduleText extends StatelessWidget {
  final String time;
  final String subject;
  const ScheduleText(this.time, this.subject, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "$time ",
              style: TextStyle(
                color: Colors.black.withOpacity(0.4),
                fontSize: 13,
              ),
            ),
            TextSpan(
              text: subject,
              style: TextStyle(
                color: Colors.black.withOpacity(0.7),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}