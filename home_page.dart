import 'package:flutter/material.dart';

import 'choice.dart';
import 'game_screen.dart';
import 'modifier.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<Choice, int> _choicePercentages = {
    Choice.rock: 64,
    Choice.paper: 3,
    Choice.scissors: 33,
  };

  Future<void> openModifiers() async {
    final percentages = await Navigator.push<Map<Choice, int>>(
      context,
      MaterialPageRoute(
        builder: (context) => Modifier(initialPercentages: _choicePercentages),
      ),
    );
    if (percentages != null) {
      setState(() {
        _choicePercentages = percentages;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.indigo],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(
                  Icons.videogame_asset_rounded,
                  size: 90,
                  color: Colors.white,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Rock Paper Scissors',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Challenge the computer and test your luck!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.white70),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              GameScreen(choicePercentages: _choicePercentages),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Play Now',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: OutlinedButton(
                    onPressed: openModifiers,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'View modifiers',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
