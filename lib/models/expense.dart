class Expense {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String? memberId;
  final String? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    this.memberId,
    this.userId,
    DateTime? date,
    this.createdAt,
    this.updatedAt,
  }) : date = date ?? DateTime.now();

  /// Convert Expense to JSON map (for database storage)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'member_id': memberId,
      'user_id': userId,
      'date': date.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Create Expense from JSON map (from database)
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      memberId: map['member_id'] as String?,
      userId: map['user_id'] as String?,
      date: map['date'] != null ? DateTime.parse(map['date'] as String) : null,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
    );
  }

  /// Create a copy of Expense with modified fields
  Expense copyWith({
    String? id,
    String? title,
    double? amount,
    DateTime? date,
    String? memberId,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      memberId: memberId ?? this.memberId,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() =>
      'Expense(id: $id, title: $title, amount: $amount, date: $date)';
}
