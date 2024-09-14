import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:zcart_delivery/helper/constants.dart';

const _savedAccount = 'savedAccount';

class HiveProvider {
  static SavedAccount? getSavedAccount() {
    final _box = Hive.box(hiveBox);
    final _result = _box.get(_savedAccount, defaultValue: null);
    if (_result == null) {
      return null;
    } else {
      return SavedAccount.fromJson(jsonDecode(_result));
    }
  }

  static void setSavedAccount(SavedAccount? account) async {
    final _box = Hive.box(hiveBox);
    await _box.put(_savedAccount, jsonEncode(account?.toJson()));
  }
}

class SavedAccount {
  String email;
  String password;
  SavedAccount({
    required this.email,
    required this.password,
  });

  SavedAccount copyWith({
    String? email,
    String? password,
  }) {
    return SavedAccount(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
    };
  }

  factory SavedAccount.fromMap(Map<String, dynamic> map) {
    return SavedAccount(
      email: map['email'] ?? '',
      password: map['password'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SavedAccount.fromJson(String source) =>
      SavedAccount.fromMap(json.decode(source));

  @override
  String toString() => 'SavedAccount(email: $email, password: $password)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SavedAccount &&
        other.email == email &&
        other.password == password;
  }

  @override
  int get hashCode => email.hashCode ^ password.hashCode;
}
