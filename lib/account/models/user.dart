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
    this.owner,
    required this.role,
    this.pushToken,
    this.chattingWith,
  });

  final String id;
  final String email;
  final String? firstName;
  final String? secondName;
  final String? patronymic;
  final String role;
  final String? owner;
  final String? pushToken;
  final String? chattingWith;

  /// Empty user which represents an unauthenticated user.
  static const empty = User(id: '', email: '', role: 'user');

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == User.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != User.empty;

  String getFullName() {
    if (isEmpty) {
      return 'Фамилия Имя Отчество';
    }
    return firstName!.isEmpty && secondName!.isEmpty && patronymic!.isEmpty
        ? 'Фамилия Имя Отчество'
        : '${secondName ?? ''} ${firstName ?? ''} ${patronymic ?? ''}';
  }

  bool isAdminOrManager() {
    return role == 'admin' || role == 'manager';
  }

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    email: json["email"],
    firstName: json["firstName"] ?? '',
    secondName: json["secondName"] ?? '',
    patronymic: json["patronymic"] ?? '',
    role: json["role"] ?? 'user',
    owner: json["owner"] ?? '',
    pushToken: json["pushToken"] ?? '',
    chattingWith: json["chattingWith"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "firstName": firstName ?? '',
    "secondName": secondName ?? '',
    "patronymic": patronymic ?? '',
    "role": role,
    "owner": owner ?? '',
    "pushToken": pushToken ?? '',
    "chattingWith": chattingWith ?? '',
  };

  User copyWith({
    String? id,
    String? email,
    String? firstName,
    String? secondName,
    String? patronymic,
    String? role,
    String? owner,
    String? pushToken,
    String? chattingWith,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      secondName: secondName ?? this.secondName,
      patronymic: patronymic ?? this.patronymic,
      role: role ?? this.role,
      owner: owner ?? this.owner,
      pushToken: pushToken ?? this.pushToken,
      chattingWith: chattingWith ?? this.chattingWith,
    );
  }

  @override
  String toString() {
    return '$email $id';
  }
}
