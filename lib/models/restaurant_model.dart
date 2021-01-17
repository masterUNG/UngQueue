import 'dart:convert';

class RestaurantModel {
  final int amountdesk;
  final String name;
  RestaurantModel({
    this.amountdesk,
    this.name,
  });

  RestaurantModel copyWith({
    int amountdesk,
    String name,
  }) {
    return RestaurantModel(
      amountdesk: amountdesk ?? this.amountdesk,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amountdesk': amountdesk,
      'name': name,
    };
  }

  factory RestaurantModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return RestaurantModel(
      amountdesk: map['amountdesk'],
      name: map['name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory RestaurantModel.fromJson(String source) => RestaurantModel.fromMap(json.decode(source));

  @override
  String toString() => 'RestaurantModel(amountdesk: $amountdesk, name: $name)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is RestaurantModel &&
      o.amountdesk == amountdesk &&
      o.name == name;
  }

  @override
  int get hashCode => amountdesk.hashCode ^ name.hashCode;
}
