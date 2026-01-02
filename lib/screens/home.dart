import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/mess_provider.dart';
import '../widgets/cart_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MessProvider>(
      builder: (context, messProvider, _) {
        return RefreshIndicator(
          onRefresh: () => messProvider.loadAllData(),
          child: Column(
            children: [
              const CartWidget(),
              if (messProvider.isLoading && messProvider.members.isEmpty)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (messProvider.members.isEmpty)
                Expanded(
                  child: Center(
                    child: Text(
                      'No members yet. Add members to get started!',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: messProvider.members.length,
                    itemBuilder: (context, i) {
                      final member = messProvider.members[i];
                      final exp = messProvider.memberExpense(member);
                      return Card(
                        child: ListTile(
                          title: Text(
                            member.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Meals: ${member.meal}  •  Expense: \$${exp.toStringAsFixed(2)}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () =>
                                _confirmDelete(member.id, member.name),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(String memberId, String memberName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Member'),
        content: Text('Delete $memberName and all associated expenses?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<MessProvider>().deleteMember(memberId);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
