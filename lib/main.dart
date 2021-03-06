import 'dart:async';

import 'package:firedart/auth/firebase_auth.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsuratan/common/late_provide.dart';
import 'package:tsuratan/firebase/token_store.dart';
import 'package:tsuratan/pages/main_page.dart';
import 'package:tsuratan/repositories/auth_repository.dart';
import 'package:tsuratan/repositories/nickname_repository.dart';
import 'package:tsuratan/repositories/records_repository.dart';
import 'package:tsuratan/repositories/trophy_repository.dart';
import 'package:tsuratan/viewmodels/trophy_state.dart';
import 'package:tsuratan/viewmodels/trophy_viewmodel.dart';
import 'package:tsuratan/viewmodels/tsuratan_state.dart';
import 'package:tsuratan/viewmodels/tsuratan_viewmodel.dart';

final _sharedPrefProvider = lateProvide<SharedPreferences>();
final packageInfoProvider = lateProvide<PackageInfo>();

final _trophyRepositoryProvider =
    Provider((ref) => TrophyRepository(ref.watch(_sharedPrefProvider)));

final _authRepositoryProvider = StateNotifierProvider((_) => AuthRepository());

final _nickNameRepository =
    Provider((ref) => NickNameRepository(ref.watch(_sharedPrefProvider)));
final _recordsRepository =
    Provider((ref) => RecordsRepository(ref.watch(_sharedPrefProvider)));
final trophyViewModelProvider =
    StateNotifierProvider<TrophyViewModel, TrophyState>((ref) =>
        TrophyViewModel(ref.read, ref.watch(_trophyRepositoryProvider)));
final tsuratanViewModelProvider =
    StateNotifierProvider<TsuratanViewModel, TsuratanState>(
        (ref) => TsuratanViewModel(
              ref.read,
              ref.read(_authRepositoryProvider.notifier),
              ref.watch(_trophyRepositoryProvider),
              ref.watch(_nickNameRepository),
              ref.watch(_recordsRepository),
            ));

final numberArrangeProvider = StateProvider<bool>((_) => false);

final totalTsuratanProvider = StreamProvider.autoDispose<int?>((ref) {
  final isLoggedIn = ref.watch(_authRepositoryProvider);
  final dummyController = StreamController<int?>();
  ref.onDispose(() {
    dummyController.close();
  });
  if (isLoggedIn) {
    return ref.watch(_recordsRepository).getTotalTsuratanStream();
  } else {
    return dummyController.stream;
  }
});

final trophyAchievedProvider = StateProvider<String?>((_) {
  return null;
});

final finishShareDialogProvider = StateProvider<bool>((_) => false);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  late final SharedPreferences pref;
  late final PackageInfo packageInfo;
  FirebaseAuth.initialize(MyTokenStore.apiKey, MyTokenStore());
  Firestore.initialize(MyTokenStore.projectId);
  await Future.wait([
    Future(() async {
      pref = await SharedPreferences.getInstance();
      packageInfo = await PackageInfo.fromPlatform();
    })
  ]);
  runApp(ProviderScope(
    overrides: [
      _sharedPrefProvider.overrideWithValue(pref),
      packageInfoProvider.overrideWithValue(packageInfo),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '????????????',
      theme: ThemeData(primarySwatch: Colors.indigo, fontFamily: "Noto Sans JP"
          //fontFamily: "Hiragino Sans",
          ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ja', 'JP'),
      ],
      locale: const Locale("ja", "JP"),
      home: DefaultTextStyle.merge(
          style: const TextStyle(
            height: 1.5,
          ),
          child: const MainPage()),
    );
  }
}
