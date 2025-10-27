import 'package:shared_preferences/shared_preferences.dart';

class SaveManager {
  /// 💾 Сохранение прогресса игрока
  static Future<void> saveProgress({
    required double silver,
    required double gold,
    required int level,
    required int subs,
    required double income,
    required double clickIncome,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setDouble('silver', silver);
    await prefs.setDouble('gold', gold);
    await prefs.setInt('level', level);
    await prefs.setInt('subs', subs);
    await prefs.setDouble('income', income);
    await prefs.setDouble('clickIncome', clickIncome);
  }

  /// 📤 Загрузка сохранённого прогресса
  static Future<Map<String, dynamic>> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      'silver': prefs.getDouble('silver') ?? 0.0,
      'gold': prefs.getDouble('gold') ?? 0.0,
      'level': prefs.getInt('level') ?? 1,
      'subs': prefs.getInt('subs') ?? 0,
      'income': prefs.getDouble('income') ?? 0.0,
      'clickIncome': prefs.getDouble('clickIncome') ?? 1.0,
    };
  }

  /// 🔄 Очистка сохранённых данных (для отладки или новой игры)
  static Future<void> resetProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
