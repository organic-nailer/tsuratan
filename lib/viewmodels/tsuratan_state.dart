import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tsuratan/random_appear_button_data.dart';
import 'package:tsuratan/widgets/falling_credit.dart';
import 'package:tsuratan/widgets/floating_tsuratan.dart';

part 'tsuratan_state.freezed.dart';

@freezed
class TsuratanState with _$TsuratanState {
  const factory TsuratanState(
      {@Default(true)
          bool startVisible,
      @Default(0)
          int score,
      @Default(0)
          int tanni,
      @Default(0)
          int oneClicked,
      @Default(0)
          int tenClicked,
      @Default(0)
          int hunClicked,
      @Default(0)
          int thoClicked,
      @Default([])
          List<FloatingTsuratan> tsuratanium,
      @Default([])
          List<FallingCredit> rakutanium,
      @Default(RandomAppearButtonData.defaultPosition)
          RandomAppearButtonData tenButton,
      @Default(RandomAppearButtonData.defaultPosition)
          RandomAppearButtonData hunButton,
      @Default(RandomAppearButtonData.defaultPosition)
          RandomAppearButtonData thoButton}) = _TsuratanState;
}
