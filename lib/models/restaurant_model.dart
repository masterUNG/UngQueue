import 'dart:convert';

class RestaurantModel {
  final int amountdesk;
  final String name;
  final String token;
  RestaurantModel({
    this.amountdesk,
    this.name,
    this.token,
  });

  RestaurantModel copyWith({
    int amountdesk,
    String name,
    String token,
  }) {
    return RestaurantModel(
      amountdesk: amountdesk ?? this.amountdesk,
      name: name ?? this.name,
      token: token ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amountdesk': amountdesk,
      'name': name,
      'token': token,
    };
  }

  factory RestaurantModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return RestaurantModel(
      amountdesk: map['amountdesk'],
      name: map['name'],
      token: map['token'],
    );
  }

  String toJson() => json.encode(toMap());

  factory RestaurantModel.fromJson(String source) => RestaurantModel.fromMap(json.decode(source));

  @override
  String toString() => 'RestaurantModel(amountdesk: $amountdesk, name: $name, token: $token)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is RestaurantModel &&
      o.amountdesk == amountdesk &&
      o.name == name &&
      o.token == token;
  }

  @override
  int get hashCode => amountdesk.hashCode ^ name.hashCode ^ token.hashCode;
}
