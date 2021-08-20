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
import 'package:shared_preferences/shared_preferences.dart';

class Trophy {
  final String title;
  final String description;

  const Trophy(this.title, this.description);
}

class TrophyWithAchieved {
  final Trophy trophy;
  final int index;
  final bool isAchieved;

  TrophyWithAchieved(this.trophy, this.index, this.isAchieved);
}

const List<Trophy> trophies = [
  const Trophy("初めての", "1つらたんをゲットする"),
  const Trophy("まじつらたん", "10つらたんボタンを押す"),
  const Trophy("アイデンティティ持ち", "ニックネームを変更する"),
  const Trophy("落単", "単位を1つ落とす"),
  const Trophy("留確", "合計で単位を100個落とす"),
  const Trophy("社会復帰", "何も押さずに戻る"),
  const Trophy("インフルエンサー", "共有ボタンを押す"),
  const Trophy("おはじきマン", "スコアを弾く"),
  const Trophy("つらたんの猛者", "10000に達する"),
  const Trophy("レジェンド", "1つらたんだけで1000つらたんに達する"),
  const Trophy("効率厨", "最短タップで10000つらたんに達する"),
  const Trophy("つらたんな人生", "合計100000つらたんに達する"),
  const Trophy("つらたんネ申", "合計1000000つらたんに達する"),
  const Trophy("ﾊﾞｯﾌｧﾛｰ", "13個のトロフィーを手に入れる") //13
];

Future<bool> isAchieved(int index) async {
  if(index >= trophies.length) return true;

  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool(trophies[index].title) == true;
}

void setAchieved(int index) async {
  if(index >= trophies.length) return;

  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool(trophies[index].title, true);
}

Future<List<TrophyWithAchieved>> getTrophyAchieved() async {
  return Future.wait(trophies.mapIndexed((i,e) async {
    bool achieved = await isAchieved(i);
    return TrophyWithAchieved(
      e, i, achieved
    );
  }).toList());
}

class TrophyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TrophyPageState();
}

class TrophyPageState extends State<TrophyPage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    checkTrophy();
  }

  void checkTrophy() async {
    Future.delayed(Duration(seconds: 2));

    var data = await getTrophyAchieved();

    print(data.length);

    var allAchieved = true;
    data.forEach((element) {
      print("${element.index}, ${element.isAchieved}, ${element.trophy.title}");
      if(element.index != 13 && !element.isAchieved) {
        allAchieved = false;
      }
    });

    if(allAchieved) {
      setAchieved(13);
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("獲得: ${trophies[13].title}"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("トロフィー"),
      ),
      body: Center(
        child: FutureBuilder<List<TrophyWithAchieved>>(
          future: getTrophyAchieved(),
          builder: (context, snapshot) {
            if(!snapshot.hasData) return Text("loading...");

            return CarouselSlider(
              options: CarouselOptions(
                aspectRatio: 0.8,
                viewportFraction: 0.8,
                reverse: false,
                enableInfiniteScroll: false,
              ),
              items: snapshot.data.map((e) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        Text(
                            e.trophy.title,
                          style: TextStyle(
                            fontSize: 30.0
                          ),
                        ),
                        Image.asset(e.isAchieved ? "image/torofi_gold.png" : "image/torofi_gray.png"),
                        Text(
                            e.trophy.description,
                          style: TextStyle(
                            fontSize: 20.0
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }).toList()
            );
          }
        ),
      ),
    );
  }
}

extension MyList<E, T> on List<T> {
  //https://stackoverflow.com/questions/54898767/enumerate-or-map-through-a-list-with-index-and-value-in-dart のやつを拡張関数に書き換えたやつ
  List<E> mapIndexed<E>(E Function(int index, T item) f) {
    var index = 0;
    var ret = List<E>();

    for (final item in this) {
      ret.add(f(index, item));
      index = index + 1;
    }
    return ret;
  }

  List<T> nonNull() {
    return this.where((t) => t != null).toList();
  }
}
