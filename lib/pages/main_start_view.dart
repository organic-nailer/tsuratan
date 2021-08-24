import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsuratan/data/meigen.dart';
import 'package:tsuratan/main.dart';
import 'package:tsuratan/pages/settings_page.dart';
import 'package:tsuratan/pages/trophy_page.dart';

class MainStartView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, watch) {
    return Stack(
      children: [
        Positioned(
          bottom: 10.0,
          left: 0,
          right: 0,
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
        Positioned(
          top: 50.0,
          left: 0,
          right: 0,
          child: Center(
            child: Column(
              children: <Widget>[
                Text("現在の全世界の集計数"),
                StreamBuilder<int?>(
                    stream: watch(totalTsuratanProvider.stream),
                    builder: (context, snapshot) {
                      final data = snapshot.data;
                      if (data == null) return Text("loading...");
                      return Text(
                        "$data T(つらたん)",
                        style: TextStyle(fontSize: 30.0),
                      );
                    }),
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
        Positioned.fill(
          child: InkWell(
            onTap: () {
              context.read(tsuratanViewModelProvider.notifier).startGame();
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
                        context
                            .read(tsuratanViewModelProvider.notifier)
                            .startGame();
                      },
                      child: Text("Tap to Tsuratan"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                settings: RouteSettings(name: "/settings"),
                                builder: (context) => new SettingsPage()));
                      },
                      child: Text("Setting"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                settings: RouteSettings(name: "/trophy"),
                                builder: (context) => new TrophyPage()));
                      },
                      child: Text("Trophies"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
