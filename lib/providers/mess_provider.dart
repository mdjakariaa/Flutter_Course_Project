import 'package:flutter/material.dart';
import '../models/member.dart';
import '../models/expense.dart';
import '../services/database_service.dart';

class MessProvider extends ChangeNotifier {
  final DatabaseService? databaseService;

  final List<Member> _members = [];
  final List<Expense> _expenses = [];
  bool _isDark = false;
  bool _isLoading = false;
  String? _errorMessage;

  MessProvider({this.databaseService});

  // Getters
  List<Member> get members => List.unmodifiable(_members);
  List<Expense> get expenses => List.unmodifiable(_expenses);
  bool get isDark => _isDark;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Local calculations (for offline support)
  double get totalExpense => _expenses.fold(0.0, (p, e) => p + e.amount);
  int get totalMeal => _members.fold(0, (p, m) => p + m.meal);
  double get perMeal => totalMeal > 0 ? (totalExpense / totalMeal) : 0.0;

  double memberExpense(Member m) => m.meal * perMeal;

  /// Toggle dark mode
  void toggleDark() {
    _isDark = !_isDark;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// ==================== MEMBERS ====================

  /// Load all members from database
  Future<void> loadMembers() async {
    if (databaseService == null) return;

    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _members.clear();
      final members = await databaseService!.getMembers();
      _members.addAll(members);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add a new member
  Future<void> addMember(String name) async {
    if (name.trim().isEmpty) {
      _errorMessage = 'Member name cannot be empty';
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      if (databaseService != null) {
        // Add to database
        final member = await databaseService!.addMember(name);
        _members.add(member);
      } else {
        // Local storage only
        final id = DateTime.now().microsecondsSinceEpoch.toString();
        _members.add(Member(id: id, name: name));
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Delete a member
  Future<void> deleteMember(String id) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      if (databaseService != null) {
        await databaseService!.deleteMember(id);
      }

      _members.removeWhere((m) => m.id == id);
      _expenses.removeWhere((e) => e.memberId == id);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add meal to a member
  Future<void> addMeal(String memberId, int mealCount) async {
    if (mealCount <= 0) {
      _errorMessage = 'Meal count must be greater than 0';
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      if (databaseService != null) {
        await databaseService!.addMeal(memberId, mealCount);
      }

      final member = _members.firstWhere((m) => m.id == memberId);
      member.meal += mealCount;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// ==================== EXPENSES ====================

  /// Load all expenses from database
  Future<void> loadExpenses() async {
    if (databaseService == null) return;

    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _expenses.clear();
      final expenses = await databaseService!.getExpenses();
      _expenses.addAll(expenses);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add a new expense
  Future<void> addExpense(
    String title,
    double amount, {
    String? memberId,
    DateTime? date,
  }) async {
    if (title.trim().isEmpty) {
      _errorMessage = 'Expense title cannot be empty';
      notifyListeners();
      return;
    }

    if (amount <= 0) {
      _errorMessage = 'Expense amount must be greater than 0';
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      if (databaseService != null) {
        final expense = await databaseService!.addExpense(
          title: title,
          amount: amount,
          memberId: memberId,
          date: date,
        );
        _expenses.add(expense);
      } else {
        final id = DateTime.now().microsecondsSinceEpoch.toString();
        _expenses.add(
          Expense(
            id: id,
            title: title,
            amount: amount,
            memberId: memberId,
            date: date,
          ),
        );
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Delete an expense
  Future<void> deleteExpense(String id) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      if (databaseService != null) {
        await databaseService!.deleteExpense(id);
      }

      _expenses.removeWhere((e) => e.id == id);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update an expense
  Future<void> updateExpense({
    required String expenseId,
    required String title,
    required double amount,
    String? memberId,
    DateTime? date,
  }) async {
    if (title.trim().isEmpty) {
      _errorMessage = 'Expense title cannot be empty';
      notifyListeners();
      return;
    }

    if (amount <= 0) {
      _errorMessage = 'Expense amount must be greater than 0';
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      if (databaseService != null) {
        await databaseService!.updateExpense(
          expenseId: expenseId,
          title: title,
          amount: amount,
          memberId: memberId,
          date: date,
        );
      }

      final index = _expenses.indexWhere((e) => e.id == expenseId);
      if (index != -1) {
        _expenses[index] = _expenses[index].copyWith(
          title: title,
          amount: amount,
          memberId: memberId,
          date: date,
        );
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load all data (members and expenses)
  Future<void> loadAllData() async {
    await Future.wait([loadMembers(), loadExpenses()]);
  }

  /// Clear all local data
  void clearData() {
    _members.clear();
    _expenses.clear();
    notifyListeners();
  }
}
