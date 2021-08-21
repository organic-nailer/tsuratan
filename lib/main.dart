import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tsuratan/pages/main_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'つらたん',
      theme: ThemeData(primarySwatch: Colors.indigo, fontFamily: "Noto Sans JP"
          //fontFamily: "Hiragino Sans",
          ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('ja', 'JP'),
      ],
      locale: Locale("ja", "JP"),
      home: DefaultTextStyle.merge(
          style: TextStyle(
            height: 1.5,
          ),
          child: MainPage()),
    );
  }
}
