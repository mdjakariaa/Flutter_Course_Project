import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/mess_provider.dart';
import 'screens/home.dart';
import 'screens/add_member.dart';
import 'screens/add_meal.dart';
import 'screens/profile.dart';
import 'screens/add_expense.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MessProvider(),
      child: Consumer<MessProvider>(
        builder: (context, prov, _) {
          return MaterialApp(
            title: 'Mess Manager',
            theme: prov.isDark ? ThemeData.dark() : ThemeData.light(),
            home: const RootPage(),
          );
        },
      ),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _index = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    AddMemberScreen(),
    AddMealScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const AddExpenseScreen()));
        },
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () => setState(() => _index = 0),
            ),
            IconButton(
              icon: const Icon(Icons.person_add),
              onPressed: () => setState(() => _index = 1),
            ),
            const SizedBox(width: 48),
            IconButton(
              icon: const Icon(Icons.restaurant),
              onPressed: () => setState(() => _index = 2),
            ),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () => setState(() => _index = 3),
            ),
          ],
        ),
      ),
    );
  }
}
