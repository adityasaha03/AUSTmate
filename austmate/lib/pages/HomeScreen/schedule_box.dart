import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:austmate/services/google_auth_service.dart';
import 'my_schedule_page.dart';
import 'package:austmate/pages/Profile/connect_google_page.dart';

class CalendarEvent {
  final String title;
  final DateTime start;
  final DateTime end;

  CalendarEvent({
    required this.title,
    required this.start,
    required this.end,
  });
}

class ScheduleBox extends StatefulWidget {
  const ScheduleBox({super.key});

  @override
  State<ScheduleBox> createState() => _ScheduleBoxState();
}

class _ScheduleBoxState extends State<ScheduleBox> {
  List<CalendarEvent> _todayEvents = [];
  bool _loading = true;
  bool _connected = false;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<String?> _getAustmateCalendarId(String token) async {
    final response = await http.get(
      Uri.parse(
          'https://www.googleapis.com/calendar/v3/users/me/calendarList'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) return null;

    final items = jsonDecode(response.body)['items'] as List;
    for (final cal in items) {
      if (cal['summary'] == 'AustMate') return cal['id'];
    }
    return null;
  }

  Future<void> _loadEvents() async {
    setState(() => _loading = true);

    final connected = await GoogleAuthService.isConnected();

    if (!connected) {
      setState(() {
        _connected = false;
        _loading = false;
      });
      return;
    }

    setState(() => _connected = true);

    try {
      final token = await GoogleAuthService.getAccessToken();
      if (token == null) throw Exception("No token");

      final calendarId = await _getAustmateCalendarId(token);
      if (calendarId == null) throw Exception("AustMate calendar not found");

      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final url = Uri.parse(
        'https://www.googleapis.com/calendar/v3/calendars/${Uri.encodeComponent(calendarId)}/events'
        '?timeMin=${startOfDay.toUtc().toIso8601String()}'
        '&timeMax=${endOfDay.toUtc().toIso8601String()}'
        '&singleEvents=true'
        '&orderBy=startTime',
      );

      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode != 200) throw Exception("API error");

      final items = jsonDecode(response.body)['items'] as List;

      final events = items.map((e) {
        final startStr = e['start']['dateTime'] ?? e['start']['date'];
        final endStr = e['end']['dateTime'] ?? e['end']['date'];
        return CalendarEvent(
          title: e['summary'] ?? 'No Title',
          start: DateTime.parse(startStr).toLocal(),
          end: DateTime.parse(endStr).toLocal(),
        );
      }).toList();

      setState(() => _todayEvents = events);
    } catch (e) {
      setState(() => _todayEvents = []);
    } finally {
      setState(() => _loading = false);
    }
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour;
    final m = dt.minute.toString().padLeft(2, '0');
    final period = h >= 12 ? 'PM' : 'AM';
    final hour = h % 12 == 0 ? 12 : h % 12;
    return '$hour:$m $period';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 120),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F2F2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              child: _buildContent(),
            ),
          ),
          if (_connected)
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
                        builder: (_) => const MySchedulePage()),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_loading) {
      return const SizedBox(
        height: 60,
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Color(0xFFE53935),
            ),
          ),
        ),
      );
    }

    if (!_connected) {
      return GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ConnectPage()),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.link_off,
                    color: Color(0xFFE53935), size: 25),
                const SizedBox(width: 6),
                const Text(
                  "Connect Google",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              "Head over to Profile page to connect to Google",
              style: TextStyle(
                color: Colors.black.withOpacity(0.35),
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    if (_todayEvents.isEmpty) {
      return Text(
        "No classes today 🎉",
        style: TextStyle(
          color: Colors.black.withOpacity(0.5),
          fontSize: 13,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: _todayEvents.take(3).map((e) {
        return ScheduleText(
          "${_formatTime(e.start)}-${_formatTime(e.end)}",
          e.title,
        );
      }).toList(),
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
      padding: const EdgeInsets.only(bottom: 4),
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