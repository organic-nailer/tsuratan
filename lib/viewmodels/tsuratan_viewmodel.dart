import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsuratan/repositories/auth_repository.dart';
import 'package:tsuratan/repositories/trophy_repository.dart';
import 'package:tsuratan/viewmodels/tsuratan_state.dart';

class TsuratanViewModel extends StateNotifier<TsuratanState> {
  final IAuthRepository _authRepository;
  final ITrophyRepository _trophyRepository;
  final Reader read;
  TsuratanViewModel(this.read, this._authRepository, this._trophyRepository)
      : super(TsuratanState());

  Future loginGuest() async {
    final result = await _authRepository.loginGuest();
    if (!result) Future.error(Exception("Login Failed"));
  }

  Future checkTrophy() async {}
  Future incrementScore() async {}
  void dropUnko() async {}
  void fireTsuratan() {}
  void finish() async {}
}
