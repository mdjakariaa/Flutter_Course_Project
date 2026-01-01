import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/mess_provider.dart';

class AddMealScreen extends StatefulWidget {
  const AddMealScreen({super.key});

  @override
  State<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  String? _selectedId;
  final TextEditingController _mealCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<MessProvider>();
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Meal',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedId,
              hint: const Text('Select Member'),
              items: prov.members
                  .map(
                    (m) => DropdownMenuItem(value: m.id, child: Text(m.name)),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _selectedId = v),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _mealCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Meals to add'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                final id = _selectedId;
                final meals = int.tryParse(_mealCtrl.text) ?? 0;
                if (id == null || meals <= 0) return;
                prov.addMeal(id, meals);
                _mealCtrl.clear();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Meal added')));
              },
              child: const Text('Add Meal'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Members & Meals',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: prov.members.length,
                itemBuilder: (context, i) {
                  final m = prov.members[i];
                  return ListTile(
                    title: Text(m.name),
                    trailing: Text('Meals: ${m.meal}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
