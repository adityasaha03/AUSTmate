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
      if (cal['summary'] == 'AUSTmate') return cal['id'];
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
      constraints: const BoxConstraints(minHeight: 144),
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
              color: Color(0xFFD2042D),
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
                    color: Color(0xFFD2042D), size: 25),
                const SizedBox(width: 6),
                const Text(
                  "Connect Google",
                  style: TextStyle(
                    color: Color(0xFFD2042D) ,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    if (_todayEvents.isEmpty) {
    return SizedBox(
      width: double.infinity,
      child: Text(
        "No classes today 🎉",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black.withOpacity(0.5),
          fontSize: 15,
        ),
      ),
    );
  }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: _todayEvents.take(5).map((e) {
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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          // Fixed width container forces all event names to align
          SizedBox(
            width: 140, // ← adjust this to fit your longest time string
            child: Row(
              children: [
                Text(
                  time.split('-')[0], // start time
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.4),
                    fontSize: 13,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    "-",
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.3),
                      fontSize: 13,
                    ),
                  ),
                ),
                Text(
                  time.split('-')[1], // end time
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.4),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              subject,
              style: TextStyle(
                color: Colors.black.withOpacity(0.7),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
}
}