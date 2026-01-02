import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/mess_provider.dart';

class AddMemberScreen extends StatefulWidget {
  const AddMemberScreen({super.key});

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load members on init if not already loaded
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Member',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

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

            TextField(
              controller: _nameController,
              enabled: !messProvider.isLoading,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: messProvider.isLoading ? null : _addMember,
              child: Consumer<MessProvider>(
                builder: (context, provider, _) {
                  return provider.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Add');
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Members',
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
                        'No members yet. Add one to get started!',
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
                          subtitle: Text('Meals: ${member.meal}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteMember(member.id),
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

  void _addMember() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a member name')),
      );
      return;
    }

    await context.read<MessProvider>().addMember(name);
    _nameController.clear();

    if (mounted && !context.read<MessProvider>().isLoading) {
      if (context.read<MessProvider>().errorMessage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Member added successfully')),
        );
      }
    }
  }

  void _deleteMember(String memberId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Member'),
        content: const Text(
          'Are you sure? This will also delete associated expenses.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await context.read<MessProvider>().deleteMember(memberId);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
