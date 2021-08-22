import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tsuratan/entities/trophy_entity.dart';

part 'trophy_state.freezed.dart';

@freezed
class TrophyState with _$TrophyState {
  const factory TrophyState({@Default([]) List<TrophyWithAchieved> trophies}) =
      _TrophyState;
}
