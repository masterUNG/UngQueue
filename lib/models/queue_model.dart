import 'dart:convert';

class QueueModel {
  final String uiduser;
  final String datereceive;
  final String timereceive;
  QueueModel({
    this.uiduser,
    this.datereceive,
    this.timereceive,
  });

  QueueModel copyWith({
    String uiduser,
    String datereceive,
    String timereceive,
  }) {
    return QueueModel(
      uiduser: uiduser ?? this.uiduser,
      datereceive: datereceive ?? this.datereceive,
      timereceive: timereceive ?? this.timereceive,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uiduser': uiduser,
      'datereceive': datereceive,
      'timereceive': timereceive,
    };
  }

  factory QueueModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return QueueModel(
      uiduser: map['uiduser'],
      datereceive: map['datereceive'],
      timereceive: map['timereceive'],
    );
  }

  String toJson() => json.encode(toMap());

  factory QueueModel.fromJson(String source) => QueueModel.fromMap(json.decode(source));

  @override
  String toString() => 'QueueModel(uiduser: $uiduser, datereceive: $datereceive, timereceive: $timereceive)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is QueueModel &&
      o.uiduser == uiduser &&
      o.datereceive == datereceive &&
      o.timereceive == timereceive;
  }

  @override
  int get hashCode => uiduser.hashCode ^ datereceive.hashCode ^ timereceive.hashCode;
}
