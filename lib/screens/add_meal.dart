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
  final TextEditingController _mealController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load members on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final messProvider = context.read<MessProvider>();
      if (messProvider.members.isEmpty) {
        messProvider.loadMembers();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final messProvider = context.read<MessProvider>();
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Error message
            Consumer<MessProvider>(
              builder: (context, provider, _) {
                if (provider.errorMessage != null) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        border: Border.all(color: Colors.red.shade200),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error, color: Colors.red.shade700),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              provider.errorMessage!,
                              style: TextStyle(color: Colors.red.shade700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),

            Consumer<MessProvider>(
              builder: (context, provider, _) {
                return DropdownButtonFormField<String>(
                  value: _selectedId,
                  hint: const Text('Select Member'),
                  isExpanded: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: provider.members
                      .map(
                        (member) => DropdownMenuItem(
                          value: member.id,
                          child: Text(member.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => _selectedId = value),
                );
              },
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _mealController,
              enabled: !messProvider.isLoading,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Number of Meals',
                hintText: '1',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: messProvider.isLoading ? null : _addMeal,
              child: Consumer<MessProvider>(
                builder: (context, provider, _) {
                  return provider.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Add Meal');
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Members & Meals',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Consumer<MessProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoading && provider.members.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (provider.members.isEmpty) {
                    return Center(
                      child: Text(
                        'No members yet. Add members first!',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: provider.members.length,
                    itemBuilder: (context, i) {
                      final member = provider.members[i];
                      return Card(
                        child: ListTile(
                          title: Text(member.name),
                          trailing: Text(
                            'Meals: ${member.meal}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addMeal() async {
    final id = _selectedId;
    final meals = int.tryParse(_mealController.text) ?? 0;

    if (id == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a member')));
      return;
    }

    if (meals <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid meal count')),
      );
      return;
    }

    await context.read<MessProvider>().addMeal(id, meals);
    _mealController.clear();

    if (mounted && !context.read<MessProvider>().isLoading) {
      if (context.read<MessProvider>().errorMessage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Meal added successfully')),
        );
      }
    }
  }

  @override
  void dispose() {
    _mealController.dispose();
    super.dispose();
  }
}
