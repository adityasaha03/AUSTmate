import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:austmate/services/google_auth_service.dart';

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

class MySchedulePage extends StatefulWidget {
  const MySchedulePage({super.key});

  @override
  State<MySchedulePage> createState() => _MySchedulePageState();
}

class _MySchedulePageState extends State<MySchedulePage> {
  Map<String, List<CalendarEvent>> _eventsByDay = {};
  bool _loading = true;
  String? _error;

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
      if (cal['summary'] == 'AUSTate') return cal['id'];
    }
    return null;
  }

  Future<void> _loadEvents() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final token = await GoogleAuthService.getAccessToken();
      if (token == null) throw Exception("Not authenticated with Google.");

      final calendarId = await _getAustmateCalendarId(token);
      if (calendarId == null) {
        throw Exception(
            "AustMate calendar not found.\nSave a schedule first from the Profile page.");
      }

      final now = DateTime.now();
      final startOfToday = DateTime(now.year, now.month, now.day);
      final endOf3Days = startOfToday.add(const Duration(days: 3));

      final url = Uri.parse(
        'https://www.googleapis.com/calendar/v3/calendars/${Uri.encodeComponent(calendarId)}/events'
        '?timeMin=${startOfToday.toUtc().toIso8601String()}'
        '&timeMax=${endOf3Days.toUtc().toIso8601String()}'
        '&singleEvents=true'
        '&orderBy=startTime',
      );

      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode != 200) {
        throw Exception("Calendar API error ${response.statusCode}");
      }

      final items = jsonDecode(response.body)['items'] as List;

      final Map<String, List<CalendarEvent>> grouped = {
        'Today': [],
        'Tomorrow': [],
        'Day After Tomorrow': [],
      };

      for (final e in items) {
        final startStr = e['start']['dateTime'] ?? e['start']['date'];
        final endStr = e['end']['dateTime'] ?? e['end']['date'];
        final start = DateTime.parse(startStr).toLocal();
        final end = DateTime.parse(endStr).toLocal();

        final event = CalendarEvent(
          title: e['summary'] ?? 'No Title',
          start: start,
          end: end,
        );

        final dayDiff = DateTime(start.year, start.month, start.day)
            .difference(startOfToday)
            .inDays;

        if (dayDiff == 0) grouped['Today']!.add(event);
        else if (dayDiff == 1) grouped['Tomorrow']!.add(event);
        else if (dayDiff == 2) grouped['Day After Tomorrow']!.add(event);
      }

      setState(() => _eventsByDay = grouped);
    } catch (e) {
      setState(() => _error = e.toString());
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

  String _daySubtitle(String label) {
    final now = DateTime.now();
    DateTime date;
    if (label == 'Today') date = now;
    else if (label == 'Tomorrow') date = now.add(const Duration(days: 1));
    else date = now.add(const Duration(days: 2));

    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    const weekdays = ['', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${weekdays[date.weekday]}, ${date.day} ${months[date.month]}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text("My Schedule"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadEvents,
          ),
        ],
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFE53935)))
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline,
                            color: Color(0xFFE53935), size: 48),
                        const SizedBox(height: 16),
                        Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 14),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _loadEvents,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE53935),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text("Retry"),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  color: const Color(0xFFE53935),
                  onRefresh: _loadEvents,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: ['Today', 'Tomorrow', 'Day After Tomorrow']
                        .map((label) => _buildDaySection(label))
                        .toList(),
                  ),
                ),
    );
  }

  Widget _buildDaySection(String label) {
    final events = _eventsByDay[label] ?? [];

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day header
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: const Color(0xFFE53935),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _daySubtitle(label),
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          events.isEmpty
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    "No classes",
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 13,
                    ),
                  ),
                )
              : Column(
                  children: events.map(_buildEventCard).toList(),
                ),
        ],
      ),
    );
  }

  Widget _buildEventCard(CalendarEvent event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFE53935),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${_formatTime(event.start)} — ${_formatTime(event.end)}",
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.school_outlined,
              color: Color(0xFFE53935), size: 20),
        ],
      ),
    );
  }
}
