import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsuratan/data/Meigen.dart';
import 'package:tsuratan/pages/settings_page.dart';
import 'package:tsuratan/pages/trophy_page.dart';
import 'package:tsuratan/random_appear_button_data.dart';
import 'package:tsuratan/widgets/falling_credit.dart';
import 'package:tsuratan/widgets/floating_tsuratan.dart';
import 'package:tsuratan/widgets/swimming_positioned.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsuratan/main.dart';

class MainPage extends StatefulWidget {
  final bool startVisible;

  MainPage({Key? key, this.startVisible = true}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

const TextStyle scoreTextStyle = TextStyle(
    color: Colors.deepOrange,
    fontSize: 30.0,
    fontWeight: FontWeight.w900,
    shadows: [Shadow(offset: Offset(1.0, 1.0))]);

void saveData(score, oneClicked, tenClicked, hunClicked, thoClicked) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final userNickName = prefs.getString("USER_NAME") ??
      "Mx." + generateWordPairs().first.asString.toUpperCase();
  prefs.setString("USER_NAME", userNickName);
  sendData(score, userNickName, oneClicked, tenClicked, hunClicked, thoClicked);
}

class _MainPageState extends State<MainPage> {
  final _arrangeController = StreamController<bool>.broadcast();
  Sink get arrangeSink => _arrangeController;
  Stream<bool> get arrangeStream => _arrangeController.stream;

  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void dispose() {
    if (!startVisible) {
      saveData(score, oneClicked, tenClicked, hunClicked, thoClicked);
    }

    _arrangeController.close();
    _audioPlayer.dispose();
    super.dispose();
  }

  bool startVisible = true;

  int score = 0;
  int tanni = 0;
  int oneClicked = 0;
  int tenClicked = 0;
  int hunClicked = 0;
  int thoClicked = 0;

  List<FloatingTsuratan> tsuratanium = [];
  List<FallingCredit> rakutanium = [];

  @override
  void initState() {
    super.initState();
    startVisible = widget.startVisible;
    score = 0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context
        .read(tsuratanViewModelProvider.notifier)
        .loginGuest()
        .catchError((e) {
      print(e);
    });
    checkTrophy();
  }

  void checkTrophy() async {
    print("checktrophy");
    await Future.delayed(Duration(seconds: 2));

// TODO: implement
    // SharedPreferences prefs = await SharedPreferences.getInstance();

    // if (!(await isAchieved(4))) {
    //   final totalTanni = prefs.getInt("TOTAL_TANNI") ?? 0;

    //   if (totalTanni >= 100) {
    //     setAchieved(4);
    //     getTrophy(trophies[4].title);
    //   }
    // }

    // if (!(await isAchieved(11))) {
    //   final totalScore = prefs.getInt("TOTAL_SCORE") ?? 0;

    //   if (totalScore >= 100000) {
    //     setAchieved(11);
    //     getTrophy(trophies[11].title);
    //   }
    // }

    // if (!(await isAchieved(12))) {
    //   final totalScore = prefs.getInt("TOTAL_SCORE") ?? 0;

    //   if (totalScore >= 1000000) {
    //     setAchieved(12);
    //     getTrophy(trophies[12].title);
    //   }
    // }

    // if (!(await isAchieved(2))) {
    //   final nickName = prefs.getString("USER_NAME") ?? "Mx.";

    //   if (!nickName.contains("Mx.")) {
    //     setAchieved(2);
    //     getTrophy(trophies[2].title);
    //   }
    // }
  }

  GlobalKey? _floatingStack;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final tenButton = RandomAppearButtonData(10, -1000, -1000, false);
  final hunButton = RandomAppearButtonData(100, -1000, -1000, false);
  final thoButton = RandomAppearButtonData(1000, -1000, -1000, false);

  void incrementScore(int value, BuildContext context) async {
    // TODO: implement
    // if (score == 0 && value == 1 && !(await isAchieved(0))) {
    //   setAchieved(0);
    //   getTrophy(trophies[0].title);
    // }

    // if (value == 10 && !(await isAchieved(1))) {
    //   setAchieved(1);
    //   getTrophy(trophies[1].title);
    // }

    final boxSize = context.size;
    if (boxSize == null) return;
    print("$boxSize");
    fireTuratan(value, boxSize);
    setState(() {
      score += value;
      if (score == 10) {
        tenButton.update(boxSize.width, boxSize.height);
      } else if (score == 100) {
        hunButton.update(boxSize.width, boxSize.height);
      } else if (score == 1000) {
        thoButton.update(boxSize.width, boxSize.height);
      }
    });

    // if (score >= 1000 &&
    //     tenClicked == 0 &&
    //     hunClicked == 0 &&
    //     !(await isAchieved(9))) {
    //   setAchieved(9);
    //   getTrophy(trophies[9].title);
    // }

    // if (score == 10000 &&
    //     oneClicked == 10 &&
    //     tenClicked == 9 &&
    //     hunClicked == 9 &&
    //     thoClicked == 9 &&
    //     !(await isAchieved(10))) {
    //   setAchieved(10);
    //   getTrophy(trophies[10].title);
    // }

    // if (score >= 10000 && !(await isAchieved(8))) {
    //   setAchieved(8);
    //   getTrophy(trophies[8].title);
    // }
  }

  void getTrophy(String title) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("獲得: $title"),
    ));
  }

  void dropUnko(BuildContext context) async {
    // TODO: implement
    // if (tanni == 0 && !(await isAchieved(3))) {
    //   setAchieved(3);
    //   getTrophy(trophies[3].title);
    // }

    final boxSize = context.size;
    if (boxSize == null) return;
    setState(() {
      tanni++;
      rakutanium.add(FallingCredit(
        startX: math.Random().nextDouble() * boxSize.width,
        startY: -50.0,
        endY: boxSize.height + 10.0,
        fontSize: (math.Random().nextDouble() + 0.2) * 50,
      ));
    });
  }

  void fireTuratan(int value, Size boxSize) {
    tsuratanium.add(FloatingTsuratan(
      startX: math.Random().nextDouble() * boxSize.width,
      startY: boxSize.height + 10.0,
      endY: -10.0,
      fontSize: value < 10
          ? 40.0
          : value < 100
              ? 50.0
              : value < 1000
                  ? 60.0
                  : 70.0,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: Stack(
                  children: rakutanium,
                ),
              ),
              Positioned.fill(
                child: Stack(
                  key: _floatingStack,
                  children: tsuratanium,
                ),
              ),
              Positioned.fill(
                child: GestureDetector(
                  onTap: () async {
                    oneClicked++;
                    incrementScore(1, context);

                    if (oneClicked > 10000 &&
                        (new math.Random()).nextInt(1000) == 334) {
                      final boxSize = context.size;
                      if (boxSize != null) {
                        setState(() {
                          thoButton.update(boxSize.width, boxSize.height);
                          hunButton.update(boxSize.width, boxSize.height);
                          tenButton.update(boxSize.width, boxSize.height);
                        });
                      }
                    }
                  },
                ),
              ),
              Positioned.fill(
                  child: SwimmingStack(
                children: <Widget>[
                  Text(
                    "${(score / 100000).floor() % 10}",
                    style: scoreTextStyle,
                  ),
                  Text(
                    "${(score / 10000).floor() % 10}",
                    style: scoreTextStyle,
                  ),
                  Text(
                    "${(score / 1000).floor() % 10}",
                    style: scoreTextStyle,
                  ),
                  Text(
                    "${(score / 100).floor() % 10}",
                    style: scoreTextStyle,
                  ),
                  Text(
                    "${(score / 10).floor() % 10}",
                    style: scoreTextStyle,
                  ),
                  Text(
                    "${(score / 1).floor() % 10}",
                    style: scoreTextStyle,
                  ),
                  Text(
                    "T",
                    style: scoreTextStyle,
                  ),
                ],
                arrangeStream: arrangeStream,
                scaffoldkey: _scaffoldKey,
              )),
              Positioned.fill(
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: thoButton.x,
                      top: thoButton.y,
                      child: OutlinedButton(
                        onPressed: () {
                          final boxSize = context.size;
                          if (boxSize == null) return;
                          setState(() {
                            thoClicked++;
                            incrementScore(thoButton.score, context);
                            thoButton.update(boxSize.width, boxSize.height);
                          });
                        },
                        child: Text(
                          "1000つらたん",
                          style: TextStyle(
                              fontSize: 20.0, color: Color(0x40673AB7)),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Color(0x40673AB7)),
                          backgroundColor: Colors.transparent,
                          shape: StadiumBorder(),
                        ),
                      ),
                    ),
                    Positioned(
                      left: hunButton.x,
                      top: hunButton.y,
                      child: OutlinedButton(
                        onPressed: () {
                          final boxSize = context.size;
                          if (boxSize == null) return;
                          setState(() {
                            hunClicked++;
                            incrementScore(hunButton.score, context);
                            hunButton.update(boxSize.width, boxSize.height);
                          });
                        },
                        child: Text(
                          "100つらたん",
                          style: TextStyle(
                              fontSize: 20.0, color: Color(0x402196F3)),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Color(0x402196F3)),
                          backgroundColor: Colors.transparent,
                          shape: StadiumBorder(),
                        ),
                      ),
                    ),
                    Positioned(
                      left: tenButton.x,
                      top: tenButton.y,
                      child: OutlinedButton(
                        onPressed: () {
                          final boxSize = context.size;
                          if (boxSize == null) return;
                          setState(() {
                            tenClicked++;
                            incrementScore(tenButton.score, context);
                            tenButton.update(boxSize.width, boxSize.height);
                          });
                        },
                        child: Text(
                          "10つらたん",
                          style: TextStyle(
                              fontSize: 20.0, color: Color(0x4000BCD4)),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Color(0x4000BCD4)),
                          backgroundColor: Colors.transparent,
                          shape: StadiumBorder(),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      bottom: 0,
                      child: TextButton(
                        onPressed: () async {
                          // TODO: implement
                          // if (score == 0 &&
                          //     tanni == 0 &&
                          //     !(await isAchieved(5))) {
                          //   setAchieved(5);
                          //   getTrophy(trophies[5].title);
                          // }

                          finishDialog(context, score, tanni, oneClicked,
                              tenClicked, hunClicked, thoClicked);
                        },
                        child: Text(
                          "終わる",
                          style:
                              TextStyle(fontSize: 20.0, color: Colors.black45),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: InkWell(
                          onTap: () async {
                            // TODO: implement
                            // if (!(await isAchieved(6))) {
                            //   setAchieved(6);
                            //   getTrophy(trophies[6].title);
                            // }
                            // share(score);
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
                    dropUnko(context);
                    if (!Platform.isWindows && !kIsWeb) {
                      _audioPlayer.play("sound/explosion.mp3", isLocal: true);
                    }
                  },
                  child: Text(
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
                  onPressed: () async {
                    arrangeSink.add(true);
                  },
                  child: Text(
                    "整列",
                    style: TextStyle(fontSize: 20.0, color: Colors.black45),
                  ),
                ),
              ),
              //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++StartMenu
              Positioned(
                bottom: 10.0,
                left: 0,
                right: 0,
                child: Visibility(
                  visible: startVisible,
                  child: Center(
                    child: CarouselSlider(
                      options: CarouselOptions(
                          height: 150.0,
                          viewportFraction: 1.0,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 30),
                          autoPlayAnimationDuration: Duration(seconds: 1),
                          autoPlayCurve: Curves.easeInOut,
                          reverse: false,
                          aspectRatio: 5),
                      items: shuffledMeigens().map((Meigen m) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: ListTile(
                                title: Text(m.text),
                                subtitle: Text("―${m.author}"),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 50.0,
                left: 0,
                right: 0,
                child: Visibility(
                  visible: startVisible,
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text("現在の全世界の集計数"),
                        // TODO: implement
                        // StreamBuilder<DocumentSnapshot>(
                        //   stream: firestoreInstance.collection("statistic").document("1").snapshots(),
                        //   builder: (context, snapshot) {
                        //     Map<String, dynamic> data = snapshot?.data?.data; //Android -> data, Web -> data()
                        //     if(data == null) return Text("loading...");
                        //     return Text(
                        //       "${data["total"] ?? 114514}T(つらたん)",
                        //       style: TextStyle(fontSize: 30.0),
                        //     );
                        //   }
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Visibility(
                  visible: startVisible,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        startVisible = false;
                      });
                    },
                    child: Container(
                      color: Colors.black26,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const Text(
                              "つらたん",
                              style: TextStyle(fontSize: 70.0),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      settings: RouteSettings(name: "/tsurai"),
                                      //builder: (context) => new MainPage(),
                                      builder: (context) => new MainPage(
                                        startVisible: false,
                                      ),
                                    ));
                              },
                              child: Text("Tap to Tsuratan"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        settings:
                                            RouteSettings(name: "/settings"),
                                        builder: (context) =>
                                            new SettingsPage()));
                              },
                              child: Text("Setting"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        settings:
                                            RouteSettings(name: "/trophy"),
                                        builder: (context) =>
                                            new TrophyPage()));
                              },
                              child: Text("Trophies"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

const List<String> tsuramiList = [
  "つらみ",
  "結局の所つらたん",
  "まじつらたん",
  "ﾁｮｯﾄﾂﾗﾀﾝ",
  "完全につらたん",
  "つらたん何も分からん",
  "つらつら",
  "たんつら"
];

void finishDialog(BuildContext context, int score, int tanni, int oneClicked,
    int tenClicked, int hunClicked, int thoClicked) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final userNickName = prefs.getString("USER_NAME") ??
      "Mx." + generateWordPairs().first.asString.toUpperCase();
  prefs.setString("USER_NAME", userNickName);

  TextEditingController _controller = TextEditingController();

  _controller.text = userNickName;

  showDialog(
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text(
                tsuramiList[(new math.Random()).nextInt(tsuramiList.length)]),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: Text("ニックネーム"),
                  subtitle: TextField(
                    controller: _controller,
                  ),
                ),
                ListTile(
                  title: Text("つらたん × $score"),
                  subtitle: Text("$tanni 単位を落としました"),
                )
              ],
            ),
            actions: <Widget>[
              new TextButton(
                  onPressed: () async {
                    share(score);
                  },
                  child: Text("Twitterで共有")),
              new TextButton(
                  onPressed: () async {
                    final totalScore = prefs.getInt("TOTAL_SCORE") ?? 0;
                    prefs.setInt("TOTAL_SCORE", totalScore + score);
                    final totalTanni = prefs.getInt("TOTAL_TANNI") ?? 0;
                    prefs.setInt("TOTAL_TANNI", totalTanni + tanni);

                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          settings: RouteSettings(name: "/tsurai"),
                          //builder: (context) => new MainPage(),
                          builder: (context) => new MainPage(
                            startVisible: true,
                          ),
                        ));

                    if (_controller.text != "") {
                      prefs.setString("USER_NAME", _controller.text);
                    }

                    sendData(
                        score,
                        _controller.text != ""
                            ? _controller.text
                            : userNickName,
                        oneClicked,
                        tenClicked,
                        hunClicked,
                        thoClicked);
                  },
                  child: Text("終わる")),
            ],
          ),
        );
      },
      barrierDismissible: false);
}

void sendData(
    score, userNickName, oneClicked, tenClicked, hunClicked, thoClicked) async {
  // firestoreInstance
  //     .collection("sample")
  //     .document("sample")
  //     .setData({"hoge": score});
  // firestoreInstance.collection("results").add({
  //   "username": userNickName,
  //   "score": score,
  //   "one": oneClicked,
  //   "ten": tenClicked,
  //   "hun": hunClicked,
  //   "tho": thoClicked
  // });
}

void share(int score) async {
  final tweetText = "つらたん...× $score \n" + "https://tsuratan.fastriver.dev/";

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
