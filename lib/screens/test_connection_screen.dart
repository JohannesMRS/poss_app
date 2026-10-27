import 'package:flutter/material.dart';

import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../services/product_service.dart';

class TestConnectionScreen extends StatefulWidget {
  const TestConnectionScreen({super.key});
  @override
  State<TestConnectionScreen> createState() => _TestConnectionScreenState();
}

class _TestConnectionScreenState extends State<TestConnectionScreen> {
  final _api = ApiService();
  late final _auth = AuthService(_api);
  late final _products = ProductService(_api);

  String _log = 'Tekan tombol untuk menguji koneksi ke API.';
  bool _loading = false;

  Future<void> _runTest() async {
    setState(() { _loading = true; _log = 'Menjalankan...'; });
    try {
      final user = await _auth.login(email: 'admin@post.test', password: 'password123');
      final list = await _products.getProducts();
      setState(() {
        _log = 'Login OK sebagai ${user.name} (${user.role}).\n'
               'Berhasil mengambil ${list.length} produk.\n'
               'Contoh: ${list.isNotEmpty ? list.first.name : "-"}';
      });
    } on ApiException catch (e) {
      setState(() => _log = 'Gagal: ${e.message} (status ${e.statusCode})');
    } catch (e) {
      setState(() => _log = 'Error tak terduga: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Uji Koneksi API')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_log, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _loading ? null : _runTest,
              child: _loading
                  ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Uji Login + Ambil Produk'),
            ),
          ],
        ),
      ),
    );
  }
}