import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/mess_provider.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _amtCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<MessProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Add Expanse')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(labelText: 'Expense name'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _amtCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                final title = _titleCtrl.text.trim();
                final amt = double.tryParse(_amtCtrl.text) ?? 0.0;
                if (title.isEmpty || amt <= 0) return;
                prov.addExpense(title, amt);
                _titleCtrl.clear();
                _amtCtrl.clear();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Expense added')));
              },
              child: const Text('Add Expense'),
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            const Text(
              'All Expenses',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: prov.expenses.length,
                itemBuilder: (context, i) {
                  final e = prov.expenses.reversed.toList()[i];
                  return ListTile(
                    title: Text(e.title),
                    subtitle: Text(e.date.toString()),
                    trailing: Text(e.amount.toStringAsFixed(2)),
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
