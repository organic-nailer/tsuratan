import 'package:flutter/material.dart';
import 'package:tsuratan/pages/main_game_view.dart';
import 'package:tsuratan/pages/main_start_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsuratan/main.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context
        .read(tsuratanViewModelProvider.notifier)
        .loginGuest()
        .catchError((e) {
      // ignore: avoid_print
      print(e);
    });
    context.read(tsuratanViewModelProvider.notifier).checkTrophy();
    //context.read(tsuratanViewModelProvider.notifier).checkTotalTsuratan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ProviderListener(
      provider: trophyAchievedProvider,
      onChange: (context, StateController<String?> messanger) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(messanger.state ?? "unknown")));
      },
      child: SafeArea(
        child: Consumer(builder: (context, watch, widget) {
          return Stack(
            children: <Widget>[
              Positioned.fill(child: MainGameView()),
              if (watch(tsuratanViewModelProvider).startVisible)
                const Positioned.fill(child: MainStartView()),
            ],
          );
        }),
      ),
    ));
  }
}
