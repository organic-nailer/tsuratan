import 'package:flutter/material.dart';
import 'package:tsuratan/pages/main_game_view.dart';
import 'package:tsuratan/pages/main_start_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsuratan/main.dart';

class MainPage extends StatefulWidget {
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
      print(e);
    });
    context.read(tsuratanViewModelProvider.notifier).checkTrophy();
    //context.read(tsuratanViewModelProvider.notifier).checkTotalTsuratan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(
      child: Consumer(builder: (context, watch, widget) {
        return Stack(
          children: <Widget>[
            Positioned.fill(child: MainGameView()),
            if (watch(tsuratanViewModelProvider).startVisible)
              Positioned.fill(child: MainStartView())
          ],
        );
      }),
    ));
  }
}
