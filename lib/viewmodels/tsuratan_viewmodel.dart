import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsuratan/main.dart';
import 'package:tsuratan/repositories/auth_repository.dart';
import 'package:tsuratan/repositories/nickname_repository.dart';
import 'package:tsuratan/repositories/records_repository.dart';
import 'package:tsuratan/repositories/trophy_repository.dart';
import 'package:tsuratan/viewmodels/tsuratan_state.dart';
import 'package:tsuratan/widgets/falling_credit.dart';
import 'package:tsuratan/widgets/floating_tsuratan.dart';

class TsuratanViewModel extends StateNotifier<TsuratanState> {
  final IAuthRepository _authRepository;
  final ITrophyRepository _trophyRepository;
  final INickNameRepository _nickNameRepository;
  final IRecordsRepository _recordsRepository;
  final Reader read;
  TsuratanViewModel(this.read, this._authRepository, this._trophyRepository,
      this._nickNameRepository, this._recordsRepository)
      : super(TsuratanState());

  void reset() {
    state = TsuratanState();
  }

  Future loginGuest() async {
    final result = await _authRepository.loginGuest();
    if (!result) Future.error(Exception("Login Failed"));
  }

  void onGameClicked(Size canvasSize) {
    state = state.copyWith(oneClicked: state.oneClicked + 1);
    incrementScore(1, canvasSize);
    _updateButtonPosition(canvasSize);
  }

  void _updateButtonPosition(Size canvasSize) {
    if (state.oneClicked > 10000 && (new math.Random()).nextInt(1000) == 334) {
      state = state.copyWith(
        tenButton: state.tenButton.updated(canvasSize.width, canvasSize.height),
        hunButton: state.hunButton.updated(canvasSize.width, canvasSize.height),
        thoButton: state.thoButton.updated(canvasSize.width, canvasSize.height),
      );
    }
  }

  void startGame() {
    state = state.copyWith(startVisible: false);
  }

  void incrementButton(int score, Size size) {
    switch (score) {
      case 10:
        state = state.copyWith(
            tenClicked: state.tenClicked + 1,
            tenButton: state.tenButton.updated(size.width, size.height));
        break;
      case 100:
        state = state.copyWith(
            hunClicked: state.hunClicked + 1,
            hunButton: state.hunButton.updated(size.width, size.height));
        break;
      case 1000:
        state = state.copyWith(
            thoClicked: state.thoClicked + 1,
            thoButton: state.thoButton.updated(size.width, size.height));
        break;
    }
    incrementScore(score, size);
  }

  String getNickName() {
    final saved = _nickNameRepository.getSavedNickName();
    if (saved != null) return saved;
    final newName = _nickNameRepository.getNewName();
    _nickNameRepository.saveNickName(newName);
    return newName;
  }

  Future checkTrophy() async {
    await Future.delayed(Duration(seconds: 2));

    if (!_trophyRepository.isAchieved(4)) {
      final totalTanni = _recordsRepository.getTotalTanni();

      if (totalTanni >= 100) {
        final trophy = _trophyRepository.setAchieved(4);
        if (trophy != null) {
          read(trophyAchievedProvider).state = trophy.title;
        }
      }
    }

    if (!_trophyRepository.isAchieved(11)) {
      final totalScore = _recordsRepository.getTotalScore();

      if (totalScore >= 100000) {
        final trophy = _trophyRepository.setAchieved(11);
        if (trophy != null) {
          read(trophyAchievedProvider).state = trophy.title;
        }
      }
    }

    if (!_trophyRepository.isAchieved(12)) {
      final totalScore = _recordsRepository.getTotalScore();

      if (totalScore >= 1000000) {
        final trophy = _trophyRepository.setAchieved(12);
        if (trophy != null) {
          read(trophyAchievedProvider).state = trophy.title;
        }
      }
    }

    if (!_trophyRepository.isAchieved(2)) {
      final nickName = _nickNameRepository.getSavedNickName() ?? "Mx.";

      if (!nickName.contains("Mx.")) {
        final trophy = _trophyRepository.setAchieved(2);
        if (trophy != null) {
          read(trophyAchievedProvider).state = trophy.title;
        }
      }
    }
  }

  void fireTsuratan(int value, Size canvasSize) {
    state = state.copyWith(tsuratanium: [
      ...state.tsuratanium,
      FloatingTsuratan(
        startX: math.Random().nextDouble() * canvasSize.width,
        startY: canvasSize.height + 10.0,
        endY: -10.0,
        fontSize: value < 10
            ? 40.0
            : value < 100
                ? 50.0
                : value < 1000
                    ? 60.0
                    : 70.0,
      )
    ]);
  }

  void incrementScore(int value, Size canvasSize) {
    if (state.score == 0 && value == 1) {
      _checkAndNotifyTrophy(0);
    }

    if (value == 10) {
      _checkAndNotifyTrophy(1);
    }
    fireTsuratan(value, canvasSize);
    final updated = state.score + value;
    state = state.copyWith(
      score: state.score + value,
      tenButton: updated == 10
          ? state.tenButton.updated(canvasSize.width, canvasSize.height)
          : state.tenButton,
      hunButton: updated == 100
          ? state.hunButton.updated(canvasSize.width, canvasSize.height)
          : state.hunButton,
      thoButton: updated == 1000
          ? state.thoButton.updated(canvasSize.width, canvasSize.height)
          : state.thoButton,
    );

    if (state.score >= 1000 && state.tenClicked == 0 && state.hunClicked == 0) {
      _checkAndNotifyTrophy(9);
    }

    if (state.score == 10000 &&
        state.oneClicked == 10 &&
        state.tenClicked == 9 &&
        state.hunClicked == 9 &&
        state.thoClicked == 9) {
      _checkAndNotifyTrophy(10);
    }

    if (state.score >= 10000) {
      _checkAndNotifyTrophy(8);
    }
  }

  void dropUnko(Size? canvasSize) async {
    if (state.tanni == 0) {
      _checkAndNotifyTrophy(3);
    }

    if (canvasSize == null) return;
    state = state.copyWith(tanni: state.tanni + 1, rakutanium: [
      ...state.rakutanium,
      FallingCredit(
        startX: math.Random().nextDouble() * canvasSize.width,
        startY: -50.0,
        endY: canvasSize.height + 10.0,
        fontSize: (math.Random().nextDouble() + 0.2) * 50,
      )
    ]);
  }

  Future finishGame(String newName) async {
    saveScores(state.score, state.tanni);
    if (newName != "") {
      saveUserName(newName);
    }
    sendData(getNickName(), state);
    reset();
  }

  void checkFinishTrophy() {
    if (state.score == 0 && state.tanni == 0) {
      _checkAndNotifyTrophy(5);
    }
  }

  void sendData(String name, TsuratanState state) {
    _recordsRepository.sendResultData(name, state);
  }

  void saveScores(int score, int tanni) {
    _recordsRepository.addTotalScore(score);
    _recordsRepository.addTotalTanni(tanni);
  }

  // void checkTotalTsuratan() async {
  //   await Future.delayed(Duration(seconds: 1));
  //   read(totalTsuratanProvider).state = 334;
  // }

  void saveUserName(String name) {
    _nickNameRepository.saveNickName(name);
  }

  void checkShareTrophy() {
    _checkAndNotifyTrophy(6);
  }

  void _checkAndNotifyTrophy(int index) {
    if (!_trophyRepository.isAchieved(index)) {
      final trophy = _trophyRepository.setAchieved(index);
      if (trophy != null) {
        read(trophyAchievedProvider).state = trophy.title;
      }
    }
  }
}
