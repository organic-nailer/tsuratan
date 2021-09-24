import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsuratan/data/meigen.dart';
import 'package:tsuratan/main.dart';
import 'package:tsuratan/pages/settings_page.dart';
import 'package:tsuratan/pages/trophy_page.dart';

class MainStartView extends ConsumerWidget {
  const MainStartView({Key? key}) : super(key: key);

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
                  autoPlayInterval: const Duration(seconds: 30),
                  autoPlayAnimationDuration: const Duration(seconds: 1),
                  autoPlayCurve: Curves.easeInOut,
                  reverse: false,
                  aspectRatio: 5),
              items: shuffledMeigens().map((Meigen m) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                const Text("現在の全世界の集計数"),
                StreamBuilder<int?>(
                    stream: watch(totalTsuratanProvider.stream),
                    builder: (context, snapshot) {
                      final data = snapshot.data;
                      if (data == null) return const Text("loading...");
                      return Text(
                        "$data T(つらたん)",
                        style: const TextStyle(fontSize: 30.0),
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
                      child: const Text("Tap to Tsuratan"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                settings:
                                    const RouteSettings(name: "/settings"),
                                builder: (context) => const SettingsPage()));
                      },
                      child: const Text("Setting"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                settings: const RouteSettings(name: "/trophy"),
                                builder: (context) => const TrophyPage()));
                      },
                      child: const Text("Trophies"),
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
