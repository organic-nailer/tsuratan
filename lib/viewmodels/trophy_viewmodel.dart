import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsuratan/main.dart';
import 'package:tsuratan/repositories/trophy_repository.dart';
import 'package:tsuratan/viewmodels/trophy_state.dart';

class TrophyViewModel extends StateNotifier<TrophyState> {
  final ITrophyRepository _trophyRepository;
  final Reader read;
  TrophyViewModel(this.read, this._trophyRepository)
      : super(const TrophyState());

  void checkTrophy() async {
    await Future.delayed(const Duration(seconds: 2));
    var data = _trophyRepository.getTrophies();
    final allAchieved = data.every((t) => t.index == 13 || t.isAchieved);

    if (allAchieved) {
      _trophyRepository.setAchieved(13);
      read(trophyAchievedProvider.notifier).state = "獲得: ${trophies[13].title}";
      data = _trophyRepository.getTrophies();
    }

    state = state.copyWith(trophies: data);
  }
}
