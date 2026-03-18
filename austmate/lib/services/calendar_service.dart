import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:austmate/services/google_auth_service.dart';

class CalendarService {
  static const _calendarListUrl =
      'https://www.googleapis.com/calendar/v3/calendars';

  static const _calendarListFetchUrl =
      'https://www.googleapis.com/calendar/v3/users/me/calendarList';

  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static const _keyCalendarId = 'austmate_calendar_id';

  static const _rruleDay = {
    'Sunday': 'SU', 'Monday': 'MO', 'Tuesday': 'TU',
    'Wednesday': 'WE', 'Thursday': 'TH',
    'Friday': 'FR', 'Saturday': 'SA',
  };

  static const _dayMap = {
    'Sunday': DateTime.sunday, 'Monday': DateTime.monday,
    'Tuesday': DateTime.tuesday, 'Wednesday': DateTime.wednesday,
    'Thursday': DateTime.thursday, 'Friday': DateTime.friday,
    'Saturday': DateTime.saturday,
  };

  static String _pad(int n) => n.toString().padLeft(2, '0');

  /// Checks Google Calendar API for an existing "AUSTmate" calendar.
  /// Returns its ID if found, null otherwise.
  static Future<String?> _findExistingCalendar(String token) async {
    final response = await http.get(
      Uri.parse(_calendarListFetchUrl),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) return null;

    final items = jsonDecode(response.body)['items'] as List<dynamic>? ?? [];
    for (final item in items) {
      if (item['summary'] == 'AUSTmate') {
        return item['id'] as String;
      }
    }
    return null;
  }

  /// Gets the AUSTmate calendar ID using a 3-step priority:
  /// 1. Locally stored ID (fastest)
  /// 2. Search existing calendars on Google (handles reinstall / cleared data)
  /// 3. Create a brand-new calendar
  static Future<String> _getOrCreateCalendar(String token) async {
    // Step 1: Check local storage
    final stored = await _storage.read(key: _keyCalendarId);
    if (stored != null) return stored;

    // Step 2: Check if "AUSTmate" calendar already exists on Google
    final existing = await _findExistingCalendar(token);
    if (existing != null) {
      await _storage.write(key: _keyCalendarId, value: existing);
      return existing;
    }

    // Step 3: Create a new calendar
    final response = await http.post(
      Uri.parse(_calendarListUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "summary": "AUSTmate",
        "description": "Class schedules created by AUSTmate app",
        "timeZone": "Asia/Dhaka",
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Failed to create calendar: ${response.body}");
    }

    final calendarId = jsonDecode(response.body)['id'] as String;
    await _storage.write(key: _keyCalendarId, value: calendarId);

    return calendarId;
  }

  /// Creates a single weekly recurring event in the AustMate calendar.
  static Future<void> createRecurringEvent({
    required String calendarId,
    required String token,
    required String courseName,
    required String weekdayName,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    required DateTime repeatUntil,
  }) async {
    final eventsUrl =
        'https://www.googleapis.com/calendar/v3/calendars/${Uri.encodeComponent(calendarId)}/events';

    // Find next occurrence of this weekday
    final today = DateTime.now();
    final targetDay = _dayMap[weekdayName]!;
    int daysAhead = (targetDay - today.weekday + 7) % 7;
    if (daysAhead == 0) daysAhead = 7;

    final firstDate = today.add(Duration(days: daysAhead));
    final dateStr =
        '${firstDate.year}-${_pad(firstDate.month)}-${_pad(firstDate.day)}';

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
      "recurrence": ["RRULE:FREQ=WEEKLY;BYDAY=$rruleDay;UNTIL=$untilStr"],
    });

    final response = await http.post(
      Uri.parse(eventsUrl),
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
  static Future<void> createEventsForSchedule({
    required String courseName,
    required List<String> selectedDays,
    required List<TimeOfDay?> startTimes,
    required List<TimeOfDay?> endTimes,
    required DateTime repeatUntil,
  }) async {
    // Resolve token and calendar ID ONCE before spawning parallel futures
    final token = await GoogleAuthService.getAccessToken();
    if (token == null) throw Exception("Not authenticated with Google.");
    final calendarId = await _getOrCreateCalendar(token);

    final futures = <Future>[];

    for (int i = 0; i < selectedDays.length; i++) {
      final start = i < startTimes.length ? startTimes[i] : null;
      final end = i < endTimes.length ? endTimes[i] : null;
      if (start == null || end == null) continue;

      futures.add(
        createRecurringEvent(
          calendarId: calendarId,
          token: token,
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