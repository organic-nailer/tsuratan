import 'dart:async';

import 'package:firedart/firedart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsuratan/viewmodels/tsuratan_state.dart';

abstract class IRecordsRepository {
  int getTotalScore();
  void addTotalScore(int score);
  int getTotalTanni();
  void addTotalTanni(int tanni);

  void sendResultData(String name, TsuratanState state);

  Stream<int?> getTotalTsuratanStream();
}

class RecordsRepository implements IRecordsRepository {
  Firestore _firestore = Firestore.instance;
  static const _SCORE_KEY = "TOTAL_SCORE";
  static const _TANNI_KEY = "TOTAL_TANNI";

  final SharedPreferences _prefs;
  RecordsRepository(this._prefs);

  @override
  int getTotalScore() => _prefs.getInt(_SCORE_KEY) ?? 0;
  @override
  void addTotalScore(int score) {
    _prefs.setInt(_SCORE_KEY, getTotalScore() + score);
  }

  @override
  int getTotalTanni() => _prefs.getInt(_TANNI_KEY) ?? 0;
  @override
  void addTotalTanni(int tanni) {
    _prefs.setInt(_TANNI_KEY, getTotalTanni() + tanni);
  }

  @override
  void sendResultData(String name, TsuratanState state) {
    _firestore
        .collection("sample")
        .document("sample")
        .set({"hoge": state.score});
    _firestore.collection("results").add({
      "username": name,
      "score": state.score,
      "one": state.oneClicked,
      "ten": state.tenClicked,
      "hun": state.hunClicked,
      "tho": state.thoClicked
    });
  }

  @override
  Stream<int?> getTotalTsuratanStream() {
    return _firestore
        .collection("statistic")
        .document("1")
        .stream
        .transform<int?>(
            StreamTransformer.fromHandlers(handleData: (data, sink) {
      if (data != null && data["total"] != null) {
        sink.add(data["total"] as int);
      } else {
        sink.add(null);
      }
    }));
  }
}
