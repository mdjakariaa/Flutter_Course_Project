/// Supabase Configuration
/// This file contains Supabase credentials and constants
library;

const String supabaseUrl = 'https://ibkjfbbcvhtyemvpgwcf.supabase.co';
const String supabaseAnonKey = 'sb_publishable_jJv2nPMnuXOpRrhutK9q6A_lNkKkgSr';

/// Database table names
class DatabaseTables {
  static const String members = 'members';
  static const String expenses = 'expenses';
  static const String userProfiles = 'user_profiles';
}

/// Column names
class MemberColumns {
  static const String id = 'id';
  static const String userId = 'user_id';
  static const String name = 'name';
  static const String meal = 'meal';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
}

class ExpenseColumns {
  static const String id = 'id';
  static const String userId = 'user_id';
  static const String title = 'title';
  static const String amount = 'amount';
  static const String memberId = 'member_id';
  static const String date = 'date';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
}

class UserProfileColumns {
  static const String id = 'id';
  static const String userId = 'user_id';
  static const String email = 'email';
  static const String fullName = 'full_name';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
}
