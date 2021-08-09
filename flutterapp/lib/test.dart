import 'dart:convert';

class Demo {
  Demo({
    required this.a,
    required this.b,
  });

  factory Demo.fromJson(String source) => Demo.fromMap(json.decode(source));

  factory Demo.fromMap(Map<String, dynamic> map) {
    return Demo(
      a: map['a'],
      b: map['b'],
    );
  }

final String a;
final int b;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Demo &&
      other.a == a &&
      other.b == b;
  }

  @override
  int get hashCode => a.hashCode ^ b.hashCode;

  @override
  String toString() => 'Demo(a: $a, b: $b)';

  Demo copyWith({
    String? a,
    int? b,
  }) {
    return Demo(
      a: a ?? this.a,
      b: b ?? this.b,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'a': a,
      'b': b,
    };
  }

  String toJson() => json.encode(toMap());
}
