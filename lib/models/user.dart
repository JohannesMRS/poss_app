import '../utils/parser.dart';

class User{
  final int id;
  final String name;
  final String email;
  final String role;

  User({required this.id, required this.name, required this.email, required this.role});

  factory User.fromJson(Map<String, dynamic>json){
    return User(
      id: toInt(json['id']),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'kasir',
    );
  }

  Map<String, dynamic> toJson()=>{
    'id': id,
    'name': name,
    'email': email,
    'role': role
  };

  bool get isAdmim => role == 'admin';
}