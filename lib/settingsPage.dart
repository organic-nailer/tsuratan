import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("設定"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            new ListTile(
              title: Text("製作者"),
              subtitle: Text("@fastriver_org"),
            ),
            new Divider(),
            new ListTile(
              title: Text("遊び方"),
              subtitle: Text("つらたん...な気分のあなた。 \n" +
                  "そのつらたんさを原動力にタップしまくりましょう \n" +
                  "スコア表示は弾けます \n" +
                  "「10つらたん」を押すと10加算されますよ \n" +
                  "トップ画面では全世界の遊んだ合計がみられます \n" +
                  "Twitterマークを押してつらたんさを共有しよう"),
            ),
            new ListTile(
              title: Text("OpenSource Licence"),
              onTap: () {
                showLicensePage(
                  context: context,
                  applicationName: 'Tsuratan by Fastriver_org',
                  applicationVersion: '1.0.0',
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
