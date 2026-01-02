class Member {
  final String id;
  final String name;
  int meal;
  final String? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Member({
    required this.id,
    required this.name,
    this.meal = 0,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  /// Convert Member to JSON map (for database storage)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'meal': meal,
      'user_id': userId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Create Member from JSON map (from database)
  factory Member.fromMap(Map<String, dynamic> map) {
    return Member(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      meal: map['meal'] as int? ?? 0,
      userId: map['user_id'] as String?,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
    );
  }

  /// Create a copy of Member with modified fields
  Member copyWith({
    String? id,
    String? name,
    int? meal,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Member(
      id: id ?? this.id,
      name: name ?? this.name,
      meal: meal ?? this.meal,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() => 'Member(id: $id, name: $name, meal: $meal)';
}
