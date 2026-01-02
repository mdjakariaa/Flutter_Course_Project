import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/member.dart';
import '../models/expense.dart';
import 'supabase_config.dart';

class DatabaseException implements Exception {
  final String message;
  DatabaseException(this.message);

  @override
  String toString() => message;
}

class DatabaseService {
  final SupabaseClient _supabaseClient;
  final String userId;

  DatabaseService({
    required SupabaseClient supabaseClient,
    required this.userId,
  }) : _supabaseClient = supabaseClient;

  /// ==================== MEMBERS ====================

  /// Get all members for current user
  Future<List<Member>> getMembers() async {
    try {
      final response = await _supabaseClient
          .from(DatabaseTables.members)
          .select()
          .eq(MemberColumns.userId, userId)
          .order(MemberColumns.createdAt, ascending: false);

      return (response as List<dynamic>)
          .map((data) => Member.fromMap(data as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw DatabaseException('Failed to fetch members: ${e.toString()}');
    }
  }

  /// Add a new member
  Future<Member> addMember(String name) async {
    try {
      if (name.trim().isEmpty) {
        throw DatabaseException('Member name cannot be empty');
      }

      final now = DateTime.now().toIso8601String();
      final id = const Uuid().v4();
      final response =
          await _supabaseClient.from(DatabaseTables.members).insert({
            MemberColumns.id: id,
            MemberColumns.userId: userId,
            MemberColumns.name: name.trim(),
            MemberColumns.meal: 0,
            MemberColumns.createdAt: now,
            MemberColumns.updatedAt: now,
          }).select();

      if (response.isEmpty) {
        throw DatabaseException('Failed to create member');
      }

      return Member.fromMap(response[0]);
    } catch (e) {
      throw DatabaseException('Failed to add member: ${e.toString()}');
    }
  }

  /// Delete a member and associated expenses
  Future<void> deleteMember(String memberId) async {
    try {
      // Delete associated expenses
      await _supabaseClient
          .from(DatabaseTables.expenses)
          .delete()
          .eq(ExpenseColumns.userId, userId)
          .eq(ExpenseColumns.memberId, memberId);

      // Delete member
      await _supabaseClient
          .from(DatabaseTables.members)
          .delete()
          .eq(MemberColumns.userId, userId)
          .eq(MemberColumns.id, memberId);
    } catch (e) {
      throw DatabaseException('Failed to delete member: ${e.toString()}');
    }
  }

  /// Update member meal count
  Future<void> addMeal(String memberId, int mealCount) async {
    try {
      // Get current meal count
      final response = await _supabaseClient
          .from(DatabaseTables.members)
          .select(MemberColumns.meal)
          .eq(MemberColumns.userId, userId)
          .eq(MemberColumns.id, memberId)
          .single();

      final currentMeal = (response[MemberColumns.meal] as int?) ?? 0;
      final newMeal = currentMeal + mealCount;

      // Update meal count
      await _supabaseClient
          .from(DatabaseTables.members)
          .update({
            MemberColumns.meal: newMeal,
            MemberColumns.updatedAt: DateTime.now().toIso8601String(),
          })
          .eq(MemberColumns.userId, userId)
          .eq(MemberColumns.id, memberId);
    } catch (e) {
      throw DatabaseException('Failed to update meal count: ${e.toString()}');
    }
  }

  /// ==================== EXPENSES ====================

  /// Get all expenses for current user
  Future<List<Expense>> getExpenses() async {
    try {
      final response = await _supabaseClient
          .from(DatabaseTables.expenses)
          .select()
          .eq(ExpenseColumns.userId, userId)
          .order(ExpenseColumns.createdAt, ascending: false);

      return (response as List<dynamic>)
          .map((data) => Expense.fromMap(data as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw DatabaseException('Failed to fetch expenses: ${e.toString()}');
    }
  }

  /// Add a new expense
  Future<Expense> addExpense({
    required String title,
    required double amount,
    String? memberId,
    DateTime? date,
  }) async {
    try {
      if (title.trim().isEmpty) {
        throw DatabaseException('Expense title cannot be empty');
      }

      if (amount <= 0) {
        throw DatabaseException('Expense amount must be greater than 0');
      }

      final now = DateTime.now().toIso8601String();
      final expenseDate = (date ?? DateTime.now()).toIso8601String();
      final id = const Uuid().v4();

      final response =
          await _supabaseClient.from(DatabaseTables.expenses).insert({
            ExpenseColumns.id: id,
            ExpenseColumns.userId: userId,
            ExpenseColumns.title: title.trim(),
            ExpenseColumns.amount: amount,
            ExpenseColumns.memberId: memberId,
            ExpenseColumns.date: expenseDate,
            ExpenseColumns.createdAt: now,
            ExpenseColumns.updatedAt: now,
          }).select();

      if (response.isEmpty) {
        throw DatabaseException('Failed to create expense');
      }

      return Expense.fromMap(response[0]);
    } catch (e) {
      throw DatabaseException('Failed to add expense: ${e.toString()}');
    }
  }

  /// Delete an expense
  Future<void> deleteExpense(String expenseId) async {
    try {
      await _supabaseClient
          .from(DatabaseTables.expenses)
          .delete()
          .eq(ExpenseColumns.userId, userId)
          .eq(ExpenseColumns.id, expenseId);
    } catch (e) {
      throw DatabaseException('Failed to delete expense: ${e.toString()}');
    }
  }

  /// Update an expense
  Future<Expense> updateExpense({
    required String expenseId,
    required String title,
    required double amount,
    String? memberId,
    DateTime? date,
  }) async {
    try {
      if (title.trim().isEmpty) {
        throw DatabaseException('Expense title cannot be empty');
      }

      if (amount <= 0) {
        throw DatabaseException('Expense amount must be greater than 0');
      }

      final expenseDate = (date ?? DateTime.now()).toIso8601String();

      final response = await _supabaseClient
          .from(DatabaseTables.expenses)
          .update({
            ExpenseColumns.title: title.trim(),
            ExpenseColumns.amount: amount,
            ExpenseColumns.memberId: memberId,
            ExpenseColumns.date: expenseDate,
            ExpenseColumns.updatedAt: DateTime.now().toIso8601String(),
          })
          .eq(ExpenseColumns.userId, userId)
          .eq(ExpenseColumns.id, expenseId)
          .select();

      if (response.isEmpty) {
        throw DatabaseException('Failed to update expense');
      }

      return Expense.fromMap(response[0]);
    } catch (e) {
      throw DatabaseException('Failed to update expense: ${e.toString()}');
    }
  }

  /// Get expenses for a specific member
  Future<List<Expense>> getMemberExpenses(String memberId) async {
    try {
      final response = await _supabaseClient
          .from(DatabaseTables.expenses)
          .select()
          .eq(ExpenseColumns.userId, userId)
          .eq(ExpenseColumns.memberId, memberId)
          .order(ExpenseColumns.createdAt, ascending: false);

      return (response as List<dynamic>)
          .map((data) => Expense.fromMap(data as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw DatabaseException(
        'Failed to fetch member expenses: ${e.toString()}',
      );
    }
  }

  /// ==================== CALCULATIONS ====================

  /// Get total expense amount
  Future<double> getTotalExpense() async {
    try {
      final expenses = await getExpenses();
      return expenses.fold<double>(0.0, (sum, exp) => sum + exp.amount);
    } catch (e) {
      throw DatabaseException(
        'Failed to calculate total expense: ${e.toString()}',
      );
    }
  }

  /// Get total meal count
  Future<int> getTotalMeal() async {
    try {
      final members = await getMembers();
      return members.fold<int>(0, (sum, member) => sum + member.meal);
    } catch (e) {
      throw DatabaseException(
        'Failed to calculate total meals: ${e.toString()}',
      );
    }
  }

  /// Get per-meal cost
  Future<double> getPerMealCost() async {
    try {
      final totalExpense = await getTotalExpense();
      final totalMeal = await getTotalMeal();

      if (totalMeal == 0) return 0.0;
      return totalExpense / totalMeal;
    } catch (e) {
      throw DatabaseException(
        'Failed to calculate per-meal cost: ${e.toString()}',
      );
    }
  }

  /// Get member's total expense (meal count * per-meal cost)
  Future<double> getMemberExpenseAmount(Member member) async {
    try {
      final perMealCost = await getPerMealCost();
      return member.meal * perMealCost;
    } catch (e) {
      throw DatabaseException(
        'Failed to calculate member expense: ${e.toString()}',
      );
    }
  }
}
