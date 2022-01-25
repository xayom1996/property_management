import 'package:equatable/equatable.dart';

class User extends Equatable {
  /// {@macro user}
  const User({
    required this.id,
  });

  final String id;

  /// Empty user which represents an unauthenticated user.
  static const empty = User(id: '');

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == User.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != User.empty;

  @override
  List<Object?> get props => [id];
}