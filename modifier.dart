import 'package:flutter/material.dart';
import 'choice.dart';

class Modifier extends StatefulWidget {
  final Map<Choice, int> initialPercentages;

  const Modifier({super.key, required this.initialPercentages});
 
  @override
  State<Modifier> createState() => _ModifierState();
}
 
class _ModifierState extends State<Modifier> {
  // Хэдэн modifier-ийн слот байхыг энд өөрчилнө
  static const int slotCount = 4;
 
  // Аль слот сонгогдсон (null = сонгоогүй)
  int? selectedSlot;
 
  late final Map<Choice, TextEditingController> _percentageControllers;
  String? _percentageError;

  @override
  void initState() {
    super.initState();
    _percentageControllers = {
      for (final choice in Choice.values)
        choice: TextEditingController(
          text: widget.initialPercentages[choice].toString(),
        ),
    };
  }

  @override
  void dispose() {
    for (final controller in _percentageControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _savePercentages() {
    final percentages = <Choice, int>{};
    for (final choice in Choice.values) {
      final value = int.tryParse(_percentageControllers[choice]!.text);
      if (value == null || value < 0 || value > 100) {
        setState(() {
          _percentageError =
              'Enter a whole number from 0 to 100 for each move.';
        });
        return;
      }
      percentages[choice] = value;
    }

    final total = percentages.values.reduce((sum, value) => sum + value);
    if (total != 100) {
      setState(() {
        _percentageError = 'Percentages must total 100% (currently $total%).';
      });
      return;
    }

    Navigator.pop(context, percentages);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifiers'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const _SectionTitle('Computer move chances'),
          const SizedBox(height: 4),
          const Text(
            'Set the chance of each move. The percentages must add up to 100%.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 12),
          for (final choice in Choice.values)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextField(
                controller: _percentageControllers[choice],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: '${choice.label} (%)',
                  border: const OutlineInputBorder(),
                  suffixText: '%',
                ),
              ),
            ),
          if (_percentageError != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                _percentageError!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _savePercentages,
              child: const Text('Save chances'),
            ),
          ),

          const SizedBox(height: 28),

          // ---------- 1) Modifier байрлуулах хэсэг ----------
          const _SectionTitle('Modifier slots'),
          const SizedBox(height: 4),
          const Text(
            'Place a modifier in a slot to use it in the game.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: [
              for (int i = 0; i < slotCount; i++)
                _ModifierSlot(
                  index: i,
                  selected: selectedSlot == i,
                  onTap: () => setState(() => selectedSlot = i),
                ),
            ],
          ),
 
          const SizedBox(height: 28),
 
          // ---------- 2) Тоглоомд хэрхэн нөлөөлөхийг харуулах хэсэг ----------
          const _SectionTitle('Effect on the game'),
          const SizedBox(height: 12),
          _EffectCard(slot: selectedSlot),
        ],
      ),
    );
  }
}
 
class _SectionTitle extends StatelessWidget {
  final String text;
 
  const _SectionTitle(this.text);
 
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }
}
 
// Modifier-ийн нэг хоосон слот
class _ModifierSlot extends StatelessWidget {
  final int index;
  final bool selected;
  final VoidCallback onTap;
 
  const _ModifierSlot({
    required this.index,
    required this.selected,
    required this.onTap,
  });
 
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.deepPurple.withValues(alpha: selected ? 0.18 : 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? Colors.deepPurple : Colors.grey.shade400,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO: modifier орсон үед энд түүний дүрс/нэр гарна
            Icon(
              Icons.add_circle_outline,
              size: 32,
              color: selected ? Colors.deepPurple : Colors.grey,
            ),
            const SizedBox(height: 6),
            Text(
              'Slot ${index + 1}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const Text('Empty', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
 
// Сонгосон слотын modifier тоглоомд хэрхэн нөлөөлөхийг харуулна
class _EffectCard extends StatelessWidget {
  final int? slot;
 
  const _EffectCard({required this.slot});
 
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.deepPurple.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: slot == null
          ? const Text(
              'Select a slot to see how its modifier changes the game.',
              style: TextStyle(fontSize: 16),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Slot ${slot! + 1}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text('No modifier placed yet.'),
                const SizedBox(height: 12),
                // TODO: modifier бүрийн нөлөөг энд бичнэ
                const Text('Rules: —'),
                const Text('Score: —'),
                const Text('Computer: —'),
              ],
            ),
    );
  }
}
 