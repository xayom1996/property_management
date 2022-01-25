import 'dart:convert';

// Account accountFromJson(String str) => Account.fromJson(json.decode(str));
//
// String accountToJson(Account data) => json.encode(data.toJson());

class User {
  const User({
    required this.id,
    required this.email,
    this.firstName,
    this.secondName,
    this.patronymic,
    required this.role,
  });

  final String id;
  final String email;
  final String? firstName;
  final String? secondName;
  final String? patronymic;
  final String role;

  /// Empty user which represents an unauthenticated user.
  static const empty = User(id: '', email: '', role: 'user');

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == User.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != User.empty;

  String getFullName() {
    return firstName == null && secondName == null && patronymic == null
        ? 'Фамилия Имя Отчество'
        : '${firstName ?? ''} ${secondName ?? ''} ${patronymic ?? ''}';
  }

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    email: json["email"],
    firstName: json["firstName"] ?? null,
    secondName: json["secondName"] ?? null,
    patronymic: json["patronymic"] ?? null,
    role: json["role"] ?? 'user',
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "firstName": firstName ?? null,
    "secondName": secondName ?? null,
    "patronymic": patronymic ?? null,
    "role": role,
  };
}
