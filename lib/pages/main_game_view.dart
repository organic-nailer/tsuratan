import 'dart:io';
import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:tsuratan/main.dart';
import 'package:tsuratan/pages/main_page.dart';
import 'package:tsuratan/viewmodels/tsuratan_state.dart';
import 'package:tsuratan/widgets/swimming_positioned.dart';
import 'package:url_launcher/url_launcher.dart';

const TextStyle scoreTextStyle = TextStyle(
    color: Colors.deepOrange,
    fontSize: 30.0,
    fontWeight: FontWeight.w900,
    shadows: [Shadow(offset: Offset(1.0, 1.0))]);

class MainGameView extends ConsumerWidget {
  final AudioPlayer _audioPlayer = AudioPlayer();

  MainGameView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, watch) {
    final state = watch(tsuratanViewModelProvider);
    final viewModel = watch(tsuratanViewModelProvider.notifier);
    return Stack(
      children: [
        Positioned.fill(
          child: Stack(
            children: state.rakutanium,
          ),
        ),
        Positioned.fill(
          child: Stack(
            children: state.tsuratanium,
          ),
        ),
        Positioned.fill(
          child: GestureDetector(
            onTap: () {
              if (context.size != null) {
                context
                    .read(tsuratanViewModelProvider.notifier)
                    .onGameClicked(context.size!);
              }
            },
          ),
        ),
        Positioned.fill(
            child: SwimmingStack(
          children: <Widget>[
            Text(
              "${(state.score / 100000).floor() % 10}",
              style: scoreTextStyle,
            ),
            Text(
              "${(state.score / 10000).floor() % 10}",
              style: scoreTextStyle,
            ),
            Text(
              "${(state.score / 1000).floor() % 10}",
              style: scoreTextStyle,
            ),
            Text(
              "${(state.score / 100).floor() % 10}",
              style: scoreTextStyle,
            ),
            Text(
              "${(state.score / 10).floor() % 10}",
              style: scoreTextStyle,
            ),
            Text(
              "${(state.score / 1).floor() % 10}",
              style: scoreTextStyle,
            ),
            const Text(
              "T",
              style: scoreTextStyle,
            ),
          ],
          arrangeStream: watch(numberArrangeProvider).stream,
        )),
        Positioned.fill(
          child: Stack(
            children: <Widget>[
              Positioned(
                left: state.thoButton.x,
                top: state.thoButton.y,
                child: OutlinedButton(
                  onPressed: () {
                    final boxSize = context.size;
                    if (boxSize == null) return;
                    viewModel.incrementButton(1000, boxSize);
                  },
                  child: const Text(
                    "1000つらたん",
                    style: TextStyle(fontSize: 20.0, color: Color(0x40673AB7)),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0x40673AB7)),
                    backgroundColor: Colors.transparent,
                    shape: const StadiumBorder(),
                  ),
                ),
              ),
              Positioned(
                left: state.hunButton.x,
                top: state.hunButton.y,
                child: OutlinedButton(
                  onPressed: () {
                    final boxSize = context.size;
                    if (boxSize == null) return;
                    viewModel.incrementButton(100, boxSize);
                  },
                  child: const Text(
                    "100つらたん",
                    style: TextStyle(fontSize: 20.0, color: Color(0x402196F3)),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0x402196F3)),
                    backgroundColor: Colors.transparent,
                    shape: const StadiumBorder(),
                  ),
                ),
              ),
              Positioned(
                left: state.tenButton.x,
                top: state.tenButton.y,
                child: OutlinedButton(
                  onPressed: () {
                    final boxSize = context.size;
                    if (boxSize == null) return;
                    viewModel.incrementButton(10, boxSize);
                  },
                  child: const Text(
                    "10つらたん",
                    style: TextStyle(fontSize: 20.0, color: Color(0x4000BCD4)),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0x4000BCD4)),
                    backgroundColor: Colors.transparent,
                    shape: const StadiumBorder(),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                bottom: 0,
                child: TextButton(
                  onPressed: () async {
                    viewModel.checkFinishTrophy();
                    finishDialog(context, state);
                  },
                  child: const Text(
                    "終わる",
                    style: TextStyle(fontSize: 20.0, color: Colors.black45),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: InkWell(
                    onTap: () {
                      viewModel.checkShareTrophy();
                      share(state.score);
                    },
                    child: Image.asset(
                      "image/twitter_logo.png",
                      width: 40.0,
                      height: 40.0,
                      color: Colors.black45,
                    )),
              )
            ],
          ),
        ),
        Positioned(
          top: 0.0,
          left: 0.0,
          child: TextButton(
            onPressed: () async {
              viewModel.dropUnko(context.size);
              if (!Platform.isWindows && !kIsWeb) {
                _audioPlayer.play("sound/explosion.mp3", isLocal: true);
              }
            },
            child: const Text(
              "単位",
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black45,
              ),
            ),
          ),
        ),
        Positioned(
          top: 0.0,
          right: 0.0,
          child: TextButton(
            onPressed: () {
              context.read(numberArrangeProvider).state = true;
            },
            child: const Text(
              "整列",
              style: TextStyle(fontSize: 20.0, color: Colors.black45),
            ),
          ),
        ),
      ],
    );
  }

  void share(int score) async {
    final tweetText = "つらたん...× $score \n"
        "https://tsuratan.fastriver.dev/";

    if (!Platform.isAndroid && !Platform.isIOS) {
      final url = "https://twitter.com/intent/tweet?text=" + tweetText;
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } else {
      await FlutterShare.share(title: 'Tsuratan', text: tweetText);
    }
  }

  static const List<String> _tsuramiList = [
    "つらみ",
    "結局の所つらたん",
    "まじつらたん",
    "ﾁｮｯﾄﾂﾗﾀﾝ",
    "完全につらたん",
    "つらたん何も分からん",
    "つらつら",
    "たんつら"
  ];

  void finishDialog(BuildContext context, TsuratanState state) async {
    final userNickName =
        context.read(tsuratanViewModelProvider.notifier).getNickName();

    TextEditingController _controller = TextEditingController();

    _controller.text = userNickName;

    showDialog(
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              title: Text(
                  _tsuramiList[math.Random().nextInt(_tsuramiList.length)]),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: const Text("ニックネーム"),
                    subtitle: TextField(
                      controller: _controller,
                    ),
                  ),
                  ListTile(
                    title: Text("つらたん × ${state.score}"),
                    subtitle: Text("${state.tanni} 単位を落としました"),
                  )
                ],
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () async {
                      share(state.score);
                    },
                    child: const Text("Twitterで共有")),
                TextButton(
                    onPressed: () async {
                      await context
                          .read(tsuratanViewModelProvider.notifier)
                          .finishGame(_controller.text);

                      // context.refresh(tsuratanViewModelProvider);

                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              settings: const RouteSettings(name: "/tsurai"),
                              //builder: (context) => new MainPage(),
                              builder: (context) {
                                return const MainPage();
                              }));
                    },
                    child: const Text("終わる")),
              ],
            ),
          );
        },
        barrierDismissible: false);
  }
}
