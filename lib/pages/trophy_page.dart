// はじめての: 1つらたんゲットする
// まじつらたん: 10つらたんボタンを押す
// 効率厨: 最短タップで10000つらたんに達する
// アイデンティティ持ち: ニックネームを変更する
// 落単: 単位を1こ落とす
// 留確: 単位を100こ落とす
// レジェンド: 1つらたんだけで1000つらたんに達する
// インフルエンサー: 共有ボタンを押す
// つらたんの猛者: 10000つらたんに達する
// つらたんな人生: 合計100000つらたんに達する
// つらたんネ申: 合計1000000つらたんに達する
// 社会復帰: 何も押さずに戻る
// ﾊﾞｯﾌｧﾛｰ: 12個のトロフィーを手に入れる
// おはじきマン: スコアを弾く

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsuratan/main.dart';

class TrophyPage extends StatefulWidget {
  const TrophyPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TrophyPageState();
}

class TrophyPageState extends State<TrophyPage> {
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read(trophyViewModelProvider.notifier).checkTrophy();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("トロフィー"),
      ),
      body: ProviderListener(
        provider: trophyAchievedProvider,
        onChange: (context, StateController<String?> messanger) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(messanger.state ?? "unknown")));
        },
        child: Center(
          child: Consumer(builder: (context, watch, child) {
            final state = watch(trophyViewModelProvider);
            if (state.trophies.isEmpty) return const Text("loading...");
            return CarouselSlider(
                options: CarouselOptions(
                  aspectRatio: 0.8,
                  viewportFraction: 0.8,
                  reverse: false,
                  enableInfiniteScroll: false,
                ),
                items: state.trophies.map((e) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      child: Column(
                        children: <Widget>[
                          Text(
                            e.trophy.title,
                            style: const TextStyle(fontSize: 30.0),
                          ),
                          Image.asset(e.isAchieved
                              ? "image/torofi_gold.png"
                              : "image/torofi_gray.png"),
                          Text(
                            e.trophy.description,
                            style: const TextStyle(fontSize: 20.0),
                          )
                        ],
                      ),
                    ),
                  );
                }).toList());
          }),
        ),
      ),
    );
  }
}
