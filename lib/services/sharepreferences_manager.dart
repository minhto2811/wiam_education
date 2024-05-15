import 'package:shared_preferences/shared_preferences.dart';

enum SettingKey {
  volume,
  showDialogRequiredLogin,
}

class SharePreferencesManager {
  static Future<void> saveSetting(SettingKey key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (key == SettingKey.volume) {
      await prefs.setDouble('volume', value as double);
    } else if (key == SettingKey.showDialogRequiredLogin) {
      await prefs.setBool('showDialogRequiredLogin', value as bool);
    }
  }

  static Future<dynamic> getSetting(SettingKey key) async {
    final prefs = await SharedPreferences.getInstance();
    if (key == SettingKey.volume) {
      return prefs.getDouble('volume') ?? 1.0;
    } else if (key == SettingKey.showDialogRequiredLogin) {
      return prefs.getBool('showDialogRequiredLogin') ?? true;
    }
  }
}
