import '../utils/parser.dart';

class TransactionDetail {
  final int? id;
  final int productId;
  final String productName;
  final double price;
  final int quantity;
  final double subtotal;

  TransactionDetail({
    this.id,
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.subtotal,
  });

  factory TransactionDetail.fromJson(Map<String, dynamic> json) {
    return TransactionDetail(
      id: toInt(json['id']),
      productId: toInt(json['product_id']),
      productName: json['product_name'] ?? '',
      price: toDouble(json['price']),
      quantity: toInt(json['quantity']),
      subtotal: toDouble(json['subtotal']),
    );
  }
}