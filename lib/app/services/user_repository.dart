import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meta/meta.dart';
import 'package:property_management/account/models/user.dart';
import 'package:property_management/app/utils/cache.dart';
import 'package:property_management/app/utils/utils.dart';
import 'package:property_management/characteristics/models/characteristics.dart';
import 'package:property_management/objects/models/place.dart';

class LogInWithEmailAndPasswordFailure implements Exception {
  /// {@macro log_in_with_email_and_password_failure}
  const LogInWithEmailAndPasswordFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  factory LogInWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const LogInWithEmailAndPasswordFailure(
          'Введите корректный почтовый адрес',
        );
      case 'user-not-found':
        return const LogInWithEmailAndPasswordFailure(
          'Аккаунт с такой почтой не найден',
        );
      default:
        return const LogInWithEmailAndPasswordFailure('Неверный логин и пароль');
    }
  }

  /// The associated error message.
  final String message;
}

/// Thrown during the logout process if a failure occurs.
class LogOutFailure implements Exception {}

/// {@template authentication_repository}
/// Repository which manages user authentication.
/// {@endtemplate}
class UserRepository {
  /// {@macro authentication_repository}
  UserRepository({
    CacheClient? cache,
    firebase_auth.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? fireStore,
  })  : _cache = cache ?? CacheClient(),
        _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _fireStore = fireStore ?? FirebaseFirestore.instance;

  final CacheClient _cache;
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _fireStore;

  @visibleForTesting
  bool isWeb = kIsWeb;

  @visibleForTesting
  static const userCacheKey = '__user_cache_key__';

  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser == null ? User.empty : firebaseUser.toUser;
      _cache.write(key: userCacheKey, value: user);
      return user;
    });
  }

  User get currentUser {
    return _cache.read<User>(key: userCacheKey) ?? User.empty;
  }

  void reloadUser() async {
    if (_firebaseAuth.currentUser != null) {
      await _firebaseAuth.currentUser?.reload();
    }
  }

  Future<void> addUser() {
    return _fireStore.collection('users')
        .add({
          'email': 'email',
          'firstName': 'firstName',
          'secondName': 'secondName',
          'patronymic': 'patronymic',
          'role': 'user',
          'updatedAt': Timestamp.fromDate(DateTime.now().toUtc()),
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> addCharacteristics() async {
    Map<String, dynamic> items = {};
    for (var i = 0; i < objectItems.length; i++){
      items[objectItems[i]['title']] = {
        'id': i,
        'title': objectItems[i]['title'],
        'placeholder': objectItems[i]['placeholder'],
        'type': objectItems[i]['type'],
        'unit': objectItems[i]['unit'],
      };
    }
    await _fireStore.collection('characteristics').doc('object_characteristics')
        .set(items)
        .then((value) => print("Added items"))
        .catchError((error) => print("Failed to add: $error"));
  }


  Future<User> getUser() async {
    if (currentUser.id == '') {
      return User.empty;
    }
    String documentId = currentUser.id;
    DocumentSnapshot userRef = await _fireStore.collection('users')
        .doc(documentId)
        .get();
    return userRef.exists
        ? User.fromJson(userRef.data() as Map<String, dynamic>)
        : User.empty;
  }

  Future<void> updateUser(User user) async {
    String documentId = currentUser.id;
    Map<String, dynamic> userJs = user.toJson();
    userJs['updatedAt'] = Timestamp.fromDate(DateTime.now().toUtc());

    await _fireStore.collection('users').doc(documentId)
        .update(userJs)
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> signUp({required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      // throw SignUpWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      // throw const SignUpWithEmailAndPasswordFailure();
    }
  }

  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw LogInWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const LogInWithEmailAndPasswordFailure();
    }
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    final user = _firebaseAuth.currentUser;
    var box = await Hive.openBox('accountsBox');
    Map currentAccount = box.get('account');

    if (currentPassword != currentAccount['password']){
      throw const LogInWithEmailAndPasswordFailure('Неверный текущий пароль');
    }

    if (newPassword.length < 6) {
      throw const LogInWithEmailAndPasswordFailure('Пароль должен быть минимум 6 символов');
    }

    final cred = EmailAuthProvider.credential(
        email: user!.email!, password: currentPassword
    );

    user.reauthenticateWithCredential(cred).then((value) {
      user.updatePassword(newPassword).then((_) {
        print('Пароль изменен');
      }).catchError((error) {
        print(error);
      });
    }).catchError((err) {
      throw const LogInWithEmailAndPasswordFailure();
    });
    // try {
    //   await _firebaseAuth.signInWithEmailAndPassword(
    //       email: user.email!, password: currentPassword
    //   );
    //   user.updatePassword(newPassword).then((_) {
    //     print('Пароль изменен');
    //   }).catchError((error) {
    //     print(error);
    //   });
    // } on FirebaseAuthException catch (e) {
    //   throw const LogInWithEmailAndPasswordFailure('Неверный текущий пароль');
    // } catch (_) {
    //   throw const LogInWithEmailAndPasswordFailure();
    // }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw LogInWithEmailAndPasswordFailure.fromCode(e.code);
    } catch(err) {
      print(err);
    }
  }

  Future<void> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
      ]);
    } catch (_) {
      throw LogOutFailure();
    }
  }
}

extension on firebase_auth.User {
  User get toUser {
    return User(id: uid, email: email!, role: 'user');
  }
}
