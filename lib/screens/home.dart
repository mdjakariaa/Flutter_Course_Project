import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/mess_provider.dart';
import '../widgets/cart_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<MessProvider>();
    return SafeArea(
      child: Column(
        children: [
          const CartWidget(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: prov.members.length,
              itemBuilder: (context, i) {
                final m = prov.members[i];
                final exp = prov.memberExpense(m);
                return Card(
                  child: ListTile(
                    title: Text(m.name),
                    subtitle: Text(
                      'Meals: ${m.meal}  •  Expense: ${exp.toStringAsFixed(2)}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => prov.deleteMember(m.id),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
