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
    return const MaterialApp(
      title: 'Kabegami Resize',
      home: Home(),
    );
  }
}