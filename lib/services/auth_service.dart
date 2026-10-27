import '../models/user.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _api;
  AuthService(this._api);

  /// Registrasi → simpan token → kembalikan User.
  Future<User> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final res = await _api.post('/register', body: {
      'name': name,
      'email': email,
      'password': password,
    });
    final data = res['data'] as Map<String, dynamic>;
    await _api.saveToken(data['token'] as String);
    return User.fromJson(data['user'] as Map<String, dynamic>);
  }

  /// Login → simpan token → kembalikan User.
  Future<User> login({required String email, required String password}) async {
    final res = await _api.post('/login', body: {
      'email': email,
      'password': password,
    });
    final data = res['data'] as Map<String, dynamic>;
    await _api.saveToken(data['token'] as String);
    return User.fromJson(data['user'] as Map<String, dynamic>);
  }

  /// Logout → panggil API lalu hapus token lokal (apa pun hasilnya).
  Future<void> logout() async {
    try {
      await _api.post('/logout');
    } finally {
      await _api.clearToken();
    }
  }

  /// Ambil data user yang sedang login (butuh token valid).
  Future<User> getUser() async {
    final res = await _api.get('/user');
    return User.fromJson(res['data'] as Map<String, dynamic>);
  }
}