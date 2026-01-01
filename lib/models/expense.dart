class Expense {
  final String id;
  final String memberId;
  final String memberName;
  final double amount;
  final DateTime date;

  Expense({
    required this.id,
    required this.memberId,
    required this.memberName,
    required this.amount,
    DateTime? date,
  }) : date = date ?? DateTime.now();
}
