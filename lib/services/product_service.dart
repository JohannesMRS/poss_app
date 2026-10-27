import '../models/product.dart';
import 'api_service.dart';

class ProductService {
  final ApiService _api;
  ProductService(this._api);

  Future<List<Product>> getProducts({int page = 1}) async {
    final res = await _api.get('/products', query: {'page': '$page'});
    final list = res['data'] as List;
    return list.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Product> getProduct(int id) async {
    final res = await _api.get('/products/$id');
    return Product.fromJson(res['data'] as Map<String, dynamic>);
  }

  Future<Product> createProduct(Product product) async {
    final res = await _api.post('/products', body: product.toJson());
    return Product.fromJson(res['data'] as Map<String, dynamic>);
  }

  Future<Product> updateProduct(int id, Product product) async {
    final res = await _api.put('/products/$id', body: product.toJson());
    return Product.fromJson(res['data'] as Map<String, dynamic>);
  }

  Future<void> deleteProduct(int id) async {
    await _api.delete('/products/$id');
  }

  Future<List<Product>> searchProducts(String keyword) async {
    final res = await _api.get('/products/search', query: {'q': keyword});
    final list = res['data'] as List;
    return list.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
  }
}