import 'dart:async';

import 'package:firedart/auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsuratan/common/late_provide.dart';
import 'package:tsuratan/firebase/token_store.dart';
import 'package:tsuratan/pages/main_page.dart';
import 'package:tsuratan/repositories/auth_repository.dart';
import 'package:tsuratan/repositories/trophy_repository.dart';
import 'package:tsuratan/viewmodels/trophy_state.dart';
import 'package:tsuratan/viewmodels/trophy_viewmodel.dart';
import 'package:tsuratan/viewmodels/tsuratan_state.dart';
import 'package:tsuratan/viewmodels/tsuratan_viewmodel.dart';

final _sharedPrefProvider = lateProvide<SharedPreferences>();

final _trophyRepositoryProvider =
    Provider((ref) => TrophyRepository(ref.watch(_sharedPrefProvider)));

final _authRepositoryProvider = Provider((_) => AuthRepository());

final trophyViewModelProvider =
    StateNotifierProvider<TrophyViewModel, TrophyState>((ref) =>
        TrophyViewModel(ref.read, ref.watch(_trophyRepositoryProvider)));
final tsuratanViewModelProvider =
    StateNotifierProvider<TsuratanViewModel, TsuratanState>((ref) =>
        TsuratanViewModel(ref.read, ref.watch(_authRepositoryProvider),
            ref.watch(_trophyRepositoryProvider)));

final trophyAchievedProvider = StateProvider<String?>((_) {
  return null;
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  late final SharedPreferences pref;
  FirebaseAuth.initialize(MyTokenStore.apiKey, MyTokenStore());
  await Future.wait([
    Future(() async {
      pref = await SharedPreferences.getInstance();
    })
  ]);
  runApp(ProviderScope(
    overrides: [_sharedPrefProvider.overrideWithValue(pref)],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'つらたん',
      theme: ThemeData(primarySwatch: Colors.indigo, fontFamily: "Noto Sans JP"
          //fontFamily: "Hiragino Sans",
          ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('ja', 'JP'),
      ],
      locale: Locale("ja", "JP"),
      home: DefaultTextStyle.merge(
          style: TextStyle(
            height: 1.5,
          ),
          child: MainPage()),
    );
  }
}
