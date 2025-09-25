import 'package:shared_preferences/shared_preferences.dart';

class CollectionManager {
  static const String _key = 'collection_images';

  /// 画像パスリストを取得
  static Future<List<String>> getImages() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  /// 画像パスを追加
  static Future<void> addImage(String path) async {
    final prefs = await SharedPreferences.getInstance();
    final images = prefs.getStringList(_key) ?? [];
    if (!images.contains(path)) {
      images.add(path);
      await prefs.setStringList(_key, images);
    }
  }

  /// 画像リストをリセット
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
