import '../models/transaction.dart';
import 'api_service.dart';

class TransactionService {
  final ApiService _api;
  TransactionService(this._api);

  Future<List<Transaction>> getTransactions({int page = 1, String? status}) async {
    final query = {'page': '$page'};
    if (status != null) query['status'] = status;
    final res = await _api.get('/transactions', query: query);
    final list = res['data'] as List;
    return list.map((e) => Transaction.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Transaction> getTransaction(int id) async {
    final res = await _api.get('/transactions/$id');
    return Transaction.fromJson(res['data'] as Map<String, dynamic>);
  }

  /// items: daftar map { 'product_id': int, 'quantity': int }
  Future<Transaction> createTransaction({
    required List<Map<String, dynamic>> items,
    required double paid,
    String paymentMethod = 'cash',
    String? customerName,
  }) async {
    final res = await _api.post('/transactions', body: {
      'items': items,
      'paid': paid,
      'payment_method': paymentMethod,
      'customer_name': customerName,
    });
    return Transaction.fromJson(res['data'] as Map<String, dynamic>);
  }

  /// Ringkasan penjualan (khusus admin).
  Future<Map<String, dynamic>> getSummary() async {
    final res = await _api.get('/transactions/report/summary');
    return res['data'] as Map<String, dynamic>;
  }
}