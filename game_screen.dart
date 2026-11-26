import 'dart:math';
import 'package:flutter/material.dart';
import 'choice.dart';
 
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});
 
  @override
  State<GameScreen> createState() => _GameScreenState();
}
 
class _GameScreenState extends State<GameScreen> {
  final Random _random = Random();
 
  int playerScore = 0;
  int computerScore = 0;
  int draws = 0;
 
  Choice? playerChoice;
  Choice? computerChoice;
  String resultText = 'Choose your move!';
 
  Choice getRandomChoice() {
    final values = Choice.values;
    return values[_random.nextInt(values.length)];
  }
 
  void play(Choice choice) {
    final computer = getRandomChoice();
 
    setState(() {
      playerChoice = choice;
      computerChoice = computer;
 
      if (choice == computer) {
        resultText = "It's a draw!";
        draws++;
      } else if ((choice == Choice.rock && computer == Choice.scissors) ||
          (choice == Choice.paper && computer == Choice.rock) ||
          (choice == Choice.scissors && computer == Choice.paper)) {
        resultText = 'You win!';
        playerScore++;
      } else {
        resultText = 'Computer wins!';
        computerScore++;
      }
    });
  }
 
  void resetGame() {
    setState(() {
      playerScore = 0;
      computerScore = 0;
      draws = 0;
      playerChoice = null;
      computerChoice = null;
      resultText = 'Choose your move!';
    });
  }
 
  Widget choiceButton(Choice choice) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ElevatedButton(
          onPressed: () => play(choice),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                choice.emoji,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(height: 8),
              Text(choice.label),
            ],
          ),
        ),
      ),
    );
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rock Paper Scissors'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
 
            Row(
              children: [
                Expanded(
                  child: _ScoreCard(title: 'You', value: playerScore.toString()),
                ),
                Expanded(
                  child: _ScoreCard(title: 'Draw', value: draws.toString()),
                ),
                Expanded(
                  child: _ScoreCard(title: 'CPU', value: computerScore.toString()),
                ),
              ],
            ),
 
            const SizedBox(height: 30),
 
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text(
                    'Result',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    resultText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 24),
                  ),
                  if (playerChoice != null && computerChoice != null) ...[
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'You: ${playerChoice!.emoji} ${playerChoice!.label}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          'CPU: ${computerChoice!.emoji} ${computerChoice!.label}',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
 
            const SizedBox(height: 30),
 
            Row(
              children: [
                choiceButton(Choice.rock),
                choiceButton(Choice.paper),
                choiceButton(Choice.scissors),
              ],
            ),
 
            const Spacer(),
 
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: resetGame,
                icon: const Icon(Icons.refresh),
                label: const Text('Reset Score'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
 
class _ScoreCard extends StatelessWidget {
  final String title;
  final String value;
 
  const _ScoreCard({
    required this.title,
    required this.value,
  });
 
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.deepPurple.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
 