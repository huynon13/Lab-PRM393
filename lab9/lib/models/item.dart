class Item {
  final int id;
  final String name;
  final String category;
  final int price;

  const Item({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: (json['id'] as num).toInt(),
      name: (json['name'] ?? '').toString(),
      category: (json['category'] ?? '').toString(),
      price: (json['price'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'price': price,
      };

  Item copyWith({
    int? id,
    String? name,
    String? category,
    int? price,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
    );
  }
}
