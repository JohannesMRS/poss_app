import '../utils/parser.dart';

class Product {
  final int? id;
  final String name;
  final String? sku;
  final String? description;
  final double price;
  final int stock;
  final String? category;
  final bool isActive;

  Product({
    this.id,
    required this.name,
    this.sku,
    this.description,
    required this.price,
    required this.stock,
    this.category,
    this.isActive = true,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: toInt(json['id']),
      name: json['name'] ?? '',
      sku: json['sku'],
      description: json['description'],
      price: toDouble(json['price']),      // string "18000.00" → 18000.0
      stock: toInt(json['stock']),
      category: json['category'],
      isActive: json['is_active'] ?? true, // snake_case → camelCase
    );
  }

  /// Untuk dikirim saat CREATE/UPDATE. 'id' sengaja tidak disertakan.
  Map<String, dynamic> toJson() => {
        'name': name,
        'sku': sku,
        'description': description,
        'price': price,
        'stock': stock,
        'category': category,
        'is_active': isActive,
      };
}