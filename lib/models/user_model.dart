import 'dart:convert';

class UserModel {
  final String email;
  final String name;
  final String type;
  UserModel({
    this.email,
    this.name,
    this.type,
  });

  UserModel copyWith({
    String email,
    String name,
    String type,
  }) {
    return UserModel(
      email: email ?? this.email,
      name: name ?? this.name,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'type': type,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return UserModel(
      email: map['email'],
      name: map['name'],
      type: map['type'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));

  @override
  String toString() => 'UserModel(email: $email, name: $name, type: $type)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is UserModel &&
      o.email == email &&
      o.name == name &&
      o.type == type;
  }

  @override
  int get hashCode => email.hashCode ^ name.hashCode ^ type.hashCode;
}
