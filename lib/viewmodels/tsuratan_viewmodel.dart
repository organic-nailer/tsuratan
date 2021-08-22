import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsuratan/viewmodels/tsuratan_state.dart';

class TsuratanViewModel extends StateNotifier<TsuratanState> {
  TsuratanViewModel() : super(TsuratanState());
  StreamController<String> _snackStreamController = StreamController();
  Stream<String> get snackStream => _snackStreamController.stream;
  @override
  void dispose() {
    _snackStreamController.close();
    super.dispose();
  }

  Future loginGuest() async {}
  Future checkTrophy() async {}
  Future incrementScore() async {}
  void dropUnko() async {}
  void fireTsuratan() {}
  void finish() async {}
}
