// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'trophy_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$TrophyStateTearOff {
  const _$TrophyStateTearOff();

  _TrophyState call({List<TrophyWithAchieved> trophies = const []}) {
    return _TrophyState(
      trophies: trophies,
    );
  }
}

/// @nodoc
const $TrophyState = _$TrophyStateTearOff();

/// @nodoc
mixin _$TrophyState {
  List<TrophyWithAchieved> get trophies => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TrophyStateCopyWith<TrophyState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrophyStateCopyWith<$Res> {
  factory $TrophyStateCopyWith(
          TrophyState value, $Res Function(TrophyState) then) =
      _$TrophyStateCopyWithImpl<$Res>;
  $Res call({List<TrophyWithAchieved> trophies});
}

/// @nodoc
class _$TrophyStateCopyWithImpl<$Res> implements $TrophyStateCopyWith<$Res> {
  _$TrophyStateCopyWithImpl(this._value, this._then);

  final TrophyState _value;
  // ignore: unused_field
  final $Res Function(TrophyState) _then;

  @override
  $Res call({
    Object? trophies = freezed,
  }) {
    return _then(_value.copyWith(
      trophies: trophies == freezed
          ? _value.trophies
          : trophies // ignore: cast_nullable_to_non_nullable
              as List<TrophyWithAchieved>,
    ));
  }
}

/// @nodoc
abstract class _$TrophyStateCopyWith<$Res>
    implements $TrophyStateCopyWith<$Res> {
  factory _$TrophyStateCopyWith(
          _TrophyState value, $Res Function(_TrophyState) then) =
      __$TrophyStateCopyWithImpl<$Res>;
  @override
  $Res call({List<TrophyWithAchieved> trophies});
}

/// @nodoc
class __$TrophyStateCopyWithImpl<$Res> extends _$TrophyStateCopyWithImpl<$Res>
    implements _$TrophyStateCopyWith<$Res> {
  __$TrophyStateCopyWithImpl(
      _TrophyState _value, $Res Function(_TrophyState) _then)
      : super(_value, (v) => _then(v as _TrophyState));

  @override
  _TrophyState get _value => super._value as _TrophyState;

  @override
  $Res call({
    Object? trophies = freezed,
  }) {
    return _then(_TrophyState(
      trophies: trophies == freezed
          ? _value.trophies
          : trophies // ignore: cast_nullable_to_non_nullable
              as List<TrophyWithAchieved>,
    ));
  }
}

/// @nodoc

class _$_TrophyState implements _TrophyState {
  const _$_TrophyState({this.trophies = const []});

  @JsonKey(defaultValue: const [])
  @override
  final List<TrophyWithAchieved> trophies;

  @override
  String toString() {
    return 'TrophyState(trophies: $trophies)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _TrophyState &&
            (identical(other.trophies, trophies) ||
                const DeepCollectionEquality()
                    .equals(other.trophies, trophies)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(trophies);

  @JsonKey(ignore: true)
  @override
  _$TrophyStateCopyWith<_TrophyState> get copyWith =>
      __$TrophyStateCopyWithImpl<_TrophyState>(this, _$identity);
}

abstract class _TrophyState implements TrophyState {
  const factory _TrophyState({List<TrophyWithAchieved> trophies}) =
      _$_TrophyState;

  @override
  List<TrophyWithAchieved> get trophies => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$TrophyStateCopyWith<_TrophyState> get copyWith =>
      throw _privateConstructorUsedError;
}
