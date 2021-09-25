import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsuratan/main.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("設定"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const ListTile(
              title: Text("製作者"),
              subtitle: Text("@fastriver_org"),
            ),
            const Divider(),
            const ListTile(
              title: Text("遊び方"),
              subtitle: Text("つらたん...な気分のあなた。 \n"
                  "そのつらたんさを原動力にタップしまくりましょう \n"
                  "スコア表示は弾けます \n"
                  "「10つらたん」を押すと10加算されますよ \n"
                  "トップ画面では全世界の遊んだ合計がみられます \n"
                  "Twitterマークを押してつらたんさを共有しよう"),
            ),
            Consumer(builder: (context, watch, child) {
              final packageInfo = watch(packageInfoProvider);
              return ListTile(
                title: const Text("OpenSource Licence"),
                onTap: () {
                  print(packageInfo.appName);
                  print(packageInfo.version);
                  print(packageInfo.buildNumber);
                  print(packageInfo.packageName);
                  showLicensePage(
                    context: context,
                    applicationName: 'Tsuratan by Fastriver_org',
                    applicationVersion: packageInfo.version,
                  );
                },
              );
            })
          ],
        ),
      ),
    );
  }
}
