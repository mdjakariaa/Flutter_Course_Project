class Expense {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String? memberId;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    this.memberId,
    DateTime? date,
  }) : date = date ?? DateTime.now();
}
