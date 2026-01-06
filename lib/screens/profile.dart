import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/mess_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _loadUserProfile();
  }

  void _loadUserProfile() async {
    final authProvider = context.read<AuthProvider>();
    final profile = await authProvider.getUserProfile();
    if (profile != null) {
      setState(() {
        _nameController.text = profile['full_name'] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User info section
              Consumer<AuthProvider>(
                builder: (context, authProvider, _) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Account Information',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Email: ${authProvider.userEmail ?? 'N/A'}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          if (_isEditing)
                            TextField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: 'Full Name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            )
                          else
                            Text(
                              'Name: ${_nameController.text.isEmpty ? 'N/A' : _nameController.text}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              ElevatedButton.icon(
                                icon: Icon(
                                  _isEditing ? Icons.save : Icons.edit,
                                ),
                                label: Text(_isEditing ? 'Save' : 'Edit'),
                                onPressed: () async {
                                  if (_isEditing) {
                                    if (_nameController.text.isNotEmpty) {
                                      await authProvider.updateProfile(
                                        fullName: _nameController.text,
                                      );
                                      if (mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text('Profile updated'),
                                          ),
                                        );
                                      }
                                    }
                                  }
                                  setState(() => _isEditing = !_isEditing);
                                },
                              ),
                              const SizedBox(width: 8),
                              if (_isEditing)
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() => _isEditing = false);
                                    _loadUserProfile();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey,
                                  ),
                                  child: const Text('Cancel'),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // Settings section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Consumer<MessProvider>(
                        builder: (context, messProvider, _) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Dark Mode'),
                              Switch(
                                value: messProvider.isDark,
                                onChanged: (_) => messProvider.toggleDark(),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Statistics section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Consumer<MessProvider>(
                    builder: (context, messProvider, _) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Statistics',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _StatItem(
                            label: 'Total Members',
                            value: '${messProvider.members.length}',
                          ),
                          const SizedBox(height: 8),
                          _StatItem(
                            label: 'Total Expenses',
                            value:
                                '৳${messProvider.totalExpense.toStringAsFixed(2)}',
                          ),
                          const SizedBox(height: 8),
                          _StatItem(
                            label: 'Total Meals',
                            value: '${messProvider.totalMeal}',
                          ),
                          const SizedBox(height: 8),
                          _StatItem(
                            label: 'Per Meal Cost',
                            value:
                                '৳${messProvider.perMeal.toStringAsFixed(2)}',
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // About section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'About',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Mess Manager v1.0\n\n'
                        'A simple and efficient application to manage shared expenses among mess members.\n\n'
                        'Built with Flutter & Supabase',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Logout button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: _logout,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await context.read<AuthProvider>().logout();
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
