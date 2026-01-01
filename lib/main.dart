import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/mess_provider.dart';
import 'screens/home.dart';
import 'screens/add_member.dart';
import 'screens/add_meal.dart';
import 'screens/profile.dart';
import 'screens/add_expense.dart';
import 'screens/login.dart';
import 'screens/signup.dart';

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
            debugShowCheckedModeBanner: false,
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
      appBar: AppBar(
        title: _index == 0 ? const Text('Home') : const SizedBox.shrink(),
        actions: _index == 0
            ? [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      ),
                      child: const Text('Login'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const SignupScreen()),
                      ),
                      child: const Text('SignUp'),
                    ),
                  ),
                ),
              ]
            : null,
      ),
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
