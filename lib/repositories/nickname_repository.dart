import 'package:english_words/english_words.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class INickNameRepository {
  String? getSavedNickName();
  void saveNickName(String name);
  String getNewName();
}

class NickNameRepository implements INickNameRepository {
  static const _key = "USER_NAME";
  final SharedPreferences prefs;
  NickNameRepository(this.prefs);
  @override
  String? getSavedNickName() => prefs.getString(_key);
  @override
  void saveNickName(String name) {
    prefs.setString(_key, name);
  }

  @override
  String getNewName() =>
      "Mx.${generateWordPairs().first.asString.toUpperCase()}";
}
