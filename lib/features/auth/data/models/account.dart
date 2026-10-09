import 'package:flutter/foundation.dart';

/// The public view of a local account: only what screens may show.
///
/// It deliberately has no password, security answer, hash or salt. Those
/// stay inside the database layer and the auth repository, so they can never
/// leak into a screen or a log by accident. The repository builds this from
/// the stored row.
@immutable
class Account {
  const Account({required this.id, required this.name, required this.email});

  final int id;
  final String name;
  final String email;

  Account copyWith({int? id, String? name, String? email}) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Account &&
        other.id == id &&
        other.name == name &&
        other.email == email;
  }

  @override
  int get hashCode => Object.hash(id, name, email);
}
