import 'package:flutter/material.dart';
import 'package:kabegami_resize/screens/home.dart';

void main() {
  runApp(const KabegamiResize());
}

class KabegamiResize extends StatelessWidget {
  const KabegamiResize({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.white,
      brightness: Brightness.dark,
    );

    return MaterialApp(
      title: '壁紙リサイズ',
      home: const Home(),
      theme: ThemeData(
        colorScheme: colorScheme,
        fontFamily: 'NotoSansJP',
        appBarTheme: AppBarTheme(backgroundColor: colorScheme.primaryContainer),
      ),
    );
  }
}
