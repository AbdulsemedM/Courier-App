// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CountryModel {
  final int? id;
  final String? name;
  final String? isoCode;
  final String? countryCode;
  final String? createdAt;

  CountryModel({
    this.id,
    this.name,
    this.isoCode,
    this.countryCode,
    this.createdAt,
  });

  CountryModel copyWith({
    int? id,
    String? name,
    String? isoCode,
    String? countryCode,
    String? createdAt,
  }) {
    return CountryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isoCode: isoCode ?? this.isoCode,
      countryCode: countryCode ?? this.countryCode,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'isoCode': isoCode,
      'countryCode': countryCode,
      'createdAt': createdAt,
    };
  }

  factory CountryModel.fromMap(Map<String, dynamic> map) {
    return CountryModel(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      isoCode: map['isoCode'] != null ? map['isoCode'] as String : null,
      countryCode:
          map['countryCode'] != null ? map['countryCode'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CountryModel.fromJson(String source) =>
      CountryModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CountryModel(id: $id, name: $name, isoCode: $isoCode, countryCode: $countryCode, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant CountryModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.isoCode == isoCode &&
        other.countryCode == countryCode &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        isoCode.hashCode ^
        countryCode.hashCode ^
        createdAt.hashCode;
  }
}
