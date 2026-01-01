import 'package:flutter/material.dart';
import '../models/member.dart';
import '../models/expense.dart';

class MessProvider extends ChangeNotifier {
  final List<Member> _members = [];
  final List<Expense> _expenses = [];
  bool _isDark = false;

  List<Member> get members => List.unmodifiable(_members);
  List<Expense> get expenses => List.unmodifiable(_expenses);
  bool get isDark => _isDark;

  void toggleDark() {
    _isDark = !_isDark;
    notifyListeners();
  }

  void addMember(String name) {
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    _members.add(Member(id: id, name: name));
    notifyListeners();
  }

  void deleteMember(String id) {
    _members.removeWhere((m) => m.id == id);
    _expenses.removeWhere((e) => e.memberId == id);
    notifyListeners();
  }

  /// Add an expense by [title]. Optionally associate to a [memberId].
  void addExpense(String title, double amount, {String? memberId}) {
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    _expenses.add(
      Expense(id: id, title: title, amount: amount, memberId: memberId),
    );
    notifyListeners();
  }

  void addMeal(String memberId, int mealCount) {
    final member = _members.firstWhere((m) => m.id == memberId);
    member.meal += mealCount;
    notifyListeners();
  }

  double get totalExpense => _expenses.fold(0.0, (p, e) => p + e.amount);

  int get totalMeal => _members.fold(0, (p, m) => p + m.meal);

  double get perMeal => totalMeal > 0 ? (totalExpense / totalMeal) : 0.0;

  double memberExpense(Member m) => m.meal * perMeal;
}
