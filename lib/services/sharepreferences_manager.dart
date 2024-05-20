import 'package:shared_preferences/shared_preferences.dart';

class SharePreferencesManager {
   Future<void> saveSettingVolume(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('volume', value);
  }

   Future<void> saveSettingLanguage(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', value);
  }

   Future<double?> getSettingVolume() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('volume');
  }

   Future<String?> getSettingLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('language');
  }
}
