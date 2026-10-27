import '../utils/parser.dart';
import 'transaction_detail.dart';
import 'user.dart';

class Transaction {
  final int id;
  final String invoiceNumber;
  final double total;
  final double paid;
  final double change;
  final String status;
  final Map<String, dynamic> metadata;
  final List<TransactionDetail> details;
  final User? user;
  final DateTime? createdAt;

  Transaction({
    required this.id,
    required this.invoiceNumber,
    required this.total,
    required this.paid,
    required this.change,
    required this.status,
    required this.metadata,
    required this.details,
    this.user,
    this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: toInt(json['id']),
      invoiceNumber: json['invoice_number'] ?? '',
      total: toDouble(json['total']),
      paid: toDouble(json['paid']),
      change: toDouble(json['change']),
      status: json['status'] ?? '',
      // metadata (jsonb) → Map; beri default {} bila null
      metadata: json['metadata'] is Map
          ? Map<String, dynamic>.from(json['metadata'])
          : {},
      // details → List<TransactionDetail>; beri default [] bila tidak ada
      details: (json['details'] as List?)
              ?.map((e) => TransactionDetail.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      user: json['user'] != null
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }
}