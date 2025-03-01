import 'package:chess/providers/board_provider.dart';
import 'package:chess/view/game_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => BoardProvider()..initializeBoard()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: GameScreen(),
      ),
    );
  }
}
