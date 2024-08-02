import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kabegami_resize/screens/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const KabegamiResize());
}

class KabegamiResize extends StatelessWidget {
  const KabegamiResize({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '壁紙リサイズ',
      home: const Home(),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.cyan,
          brightness: Brightness.light,
        ),
        fontFamily: 'NotoSansJP',
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.cyan,
          brightness: Brightness.dark,
        ),
        fontFamily: 'NotoSansJP',
      ),
      themeMode: ThemeMode.system,
    );
  }
}