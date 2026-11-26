enum Choice { rock, paper, scissors }
 
extension ChoiceExtension on Choice {
  String get label {
    switch (this) {
      case Choice.rock:
        return 'Rock';
      case Choice.paper:
        return 'Paper';
      case Choice.scissors:
        return 'Scissors';
    }
  }
 
  String get emoji {
    switch (this) {
      case Choice.rock:
        return '✊';
      case Choice.paper:
        return '✋';
      case Choice.scissors:
        return '✌️';
    }
  }
}
 