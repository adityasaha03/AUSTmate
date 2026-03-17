import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:austmate/services/google_auth_service.dart';

class CalendarService {
  static const _url =
      'https://www.googleapis.com/calendar/v3/calendars/primary/events';

  static const _dayMap = {
    'Sunday': DateTime.sunday,
    'Monday': DateTime.monday,
    'Tuesday': DateTime.tuesday,
    'Wednesday': DateTime.wednesday,
    'Thursday': DateTime.thursday,
    'Friday': DateTime.friday,
    'Saturday': DateTime.saturday,
  };

  static const _rruleDay = {
    'Sunday': 'SU',
    'Monday': 'MO',
    'Tuesday': 'TU',
    'Wednesday': 'WE',
    'Thursday': 'TH',
    'Friday': 'FR',
    'Saturday': 'SA',
  };

  static String _pad(int n) => n.toString().padLeft(2, '0');

  /// Creates a single weekly recurring event for one weekday.
  static Future<void> createRecurringEvent({
    required String courseName,
    required String weekdayName,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    required DateTime repeatUntil,
  }) async {
    final token = await GoogleAuthService.getAccessToken();
    if (token == null) throw Exception("Not authenticated with Google.");

    // Find the next occurrence of this weekday from today
    final today = DateTime.now();
    final targetDay = _dayMap[weekdayName]!;
    int daysAhead = (targetDay - today.weekday + 7) % 7;
    if (daysAhead == 0) daysAhead = 7; // if today, schedule for next week

    final firstDate = today.add(Duration(days: daysAhead));
    final dateStr =
        '${firstDate.year}-${_pad(firstDate.month)}-${_pad(firstDate.day)}';

    // RRULE UNTIL must be in UTC format: 20251231T000000Z
    final untilStr =
        '${repeatUntil.year}${_pad(repeatUntil.month)}${_pad(repeatUntil.day)}T000000Z';

    final rruleDay = _rruleDay[weekdayName]!;

    final body = jsonEncode({
      "summary": courseName,
      "start": {
        "dateTime":
            "${dateStr}T${_pad(startTime.hour)}:${_pad(startTime.minute)}:00",
        "timeZone": "Asia/Dhaka",
      },
      "end": {
        "dateTime":
            "${dateStr}T${_pad(endTime.hour)}:${_pad(endTime.minute)}:00",
        "timeZone": "Asia/Dhaka",
      },
      "recurrence": [
        "RRULE:FREQ=WEEKLY;BYDAY=$rruleDay;UNTIL=$untilStr"
      ],
    });

    

    final response = await http.post(
      Uri.parse(_url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
          "Calendar API error ${response.statusCode}: ${response.body}");
    }
  }

  /// Creates recurring events for multiple weekdays in parallel.
  /// Each day gets its own time slot.
  static Future<void> createEventsForSchedule({
    required String courseName,
    required List<String> selectedDays,
    required List<TimeOfDay?> startTimes,
    required List<TimeOfDay?> endTimes,
    required DateTime repeatUntil,
  }) async {
    final futures = <Future>[];

    for (int i = 0; i < selectedDays.length; i++) {
      final start = i < startTimes.length ? startTimes[i] : null;
      final end = i < endTimes.length ? endTimes[i] : null;

      if (start == null || end == null) continue;

      futures.add(
        createRecurringEvent(
          courseName: courseName,
          weekdayName: selectedDays[i],
          startTime: start,
          endTime: end,
          repeatUntil: repeatUntil,
        ),
      );
    }

    await Future.wait(futures);
  }
}