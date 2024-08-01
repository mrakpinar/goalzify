import 'package:shared_preferences/shared_preferences.dart';

class MotivationService {
  static const String MOTIVATION_KEY = 'motivation';
  static const String READ_CONTENTS_KEY = 'read_contents';
  static const String LAST_RESET_DATE_KEY = 'last_reset_date';

  Future<void> resetMotivationIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final String? lastResetDateStr = prefs.getString(LAST_RESET_DATE_KEY);
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);

    if (lastResetDateStr == null ||
        DateTime.parse(lastResetDateStr).isBefore(today)) {
      await prefs.setInt(MOTIVATION_KEY, 0);
      await prefs.setString(LAST_RESET_DATE_KEY, today.toIso8601String());
      await prefs.setStringList(READ_CONTENTS_KEY, []);
    }
  }

  Future<int> getMotivation() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(MOTIVATION_KEY) ?? 0;
  }

  Future<void> increaseMotivation(String contentId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> readContents = prefs.getStringList(READ_CONTENTS_KEY) ?? [];

    if (!readContents.contains(contentId)) {
      int currentMotivation = await getMotivation();
      currentMotivation = (currentMotivation + 10).clamp(0, 100);
      await prefs.setInt(MOTIVATION_KEY, currentMotivation);

      readContents.add(contentId);
      await prefs.setStringList(READ_CONTENTS_KEY, readContents);
    }
  }
}
