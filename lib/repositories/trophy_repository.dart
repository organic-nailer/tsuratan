import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsuratan/entities/trophy_entity.dart';

abstract class ITrophyRepository {
  TrophyEntity? setAchieved(int index);
  bool isAchieved(int index);
  List<TrophyWithAchieved> getTrophies();
  TrophyEntity? getTrophy(int index);
}

class TrophyRepository implements ITrophyRepository {
  final SharedPreferences prefs;
  TrophyRepository(this.prefs);

  @override
  TrophyEntity? setAchieved(int index) {
    if (index >= trophies.length) return null;
    prefs.setBool(trophies[index].title, true);
    return trophies[index];
  }

  @override
  bool isAchieved(int index) {
    if (index >= trophies.length) return true;
    return prefs.getBool(trophies[index].title) == true;
  }

  @override
  List<TrophyWithAchieved> getTrophies() {
    return trophies.mapIndexed((index, item) {
      return TrophyWithAchieved(item, index, isAchieved(index));
    });
  }

  @override
  TrophyEntity? getTrophy(int index) => trophies[index];
}

const List<TrophyEntity> trophies = [
  TrophyEntity("初めての", "1つらたんをゲットする"),
  TrophyEntity("まじつらたん", "10つらたんボタンを押す"),
  TrophyEntity("アイデンティティ持ち", "ニックネームを変更する"),
  TrophyEntity("落単", "単位を1つ落とす"),
  TrophyEntity("留確", "合計で単位を100個落とす"),
  TrophyEntity("社会復帰", "何も押さずに戻る"),
  TrophyEntity("インフルエンサー", "共有ボタンを押す"),
  TrophyEntity("おはじきマン", "スコアを弾く"),
  TrophyEntity("つらたんの猛者", "10000に達する"),
  TrophyEntity("レジェンド", "1つらたんだけで1000つらたんに達する"),
  TrophyEntity("効率厨", "最短タップで10000つらたんに達する"),
  TrophyEntity("つらたんな人生", "合計100000つらたんに達する"),
  TrophyEntity("つらたんネ申", "合計1000000つらたんに達する"),
  TrophyEntity("ﾊﾞｯﾌｧﾛｰ", "13個のトロフィーを手に入れる") //13
];

extension MyList<T> on List<T> {
  //https://stackoverflow.com/questions/54898767/enumerate-or-map-through-a-list-with-index-and-value-in-dart のやつを拡張関数に書き換えたやつ
  List<E> mapIndexed<E>(E Function(int index, T item) f) {
    var index = 0;
    var ret = <E>[];

    for (final item in this) {
      ret.add(f(index, item));
      index = index + 1;
    }
    return ret;
  }

  List<T> nonNull() {
    return where((t) => t != null).toList();
  }
}
