class Category {
  final int id;
  final String name;
  final String state;

  Category({
    required this.id,
    required this.name,
    required this.state,
  });

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['category_id'] as int,
      name: map['category_name'] as String,
      state: map['category_state'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'category_id': id,
      'category_name': name,
      'category_state': state,
    };
  }
}
