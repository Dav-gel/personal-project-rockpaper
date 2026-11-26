import 'package:flutter/material.dart';
import 'home_page.dart';
 
void main() {
  runApp(const RockPaperScissorsApp());
}
 
class RockPaperScissorsApp extends StatelessWidget {
  const RockPaperScissorsApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rock Paper Scissors',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
 