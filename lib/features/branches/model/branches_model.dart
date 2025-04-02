// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class BranchesModel {
  final int id;
  final String name;
  final String phone;
  final String code;
  final bool isAgent;
  final String settlementAccount;
  final double balance;
  final String createdAt;
  final String currency;
  BranchesModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.code,
    required this.isAgent,
    required this.settlementAccount,
    required this.balance,
    required this.createdAt,
    required this.currency,
  });

  BranchesModel copyWith({
    int? id,
    String? name,
    String? phone,
    String? code,
    bool? isAgent,
    String? settlementAccount,
    double? balance,
    String? createdAt,
    String? currency,
  }) {
    return BranchesModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      code: code ?? this.code,
      isAgent: isAgent ?? this.isAgent,
      settlementAccount: settlementAccount ?? this.settlementAccount,
      balance: balance ?? this.balance,
      createdAt: createdAt ?? this.createdAt,
      currency: currency ?? this.currency,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'phone': phone,
      'code': code,
      'isAgent': isAgent,
      'settlementAccount': settlementAccount,
      'balance': balance,
      'createdAt': createdAt,
      'currency': currency,
    };
  }

  factory BranchesModel.fromMap(Map<String, dynamic> map) {
    return BranchesModel(
      id: map['id'] as int,
      name: map['name'] as String,
      phone: map['phone'] as String,
      code: map['code'] as String,
      isAgent: map['isAgent'] as bool,
      settlementAccount: map['settlementAccount'] as String,
      balance: map['balance'] as double,
      createdAt: map['createdAt'] as String,
      currency: map['currency']['code'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory BranchesModel.fromJson(String source) =>
      BranchesModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BranchesModel(id: $id, name: $name, phone: $phone, code: $code, isAgent: $isAgent, settlementAccount: $settlementAccount, balance: $balance, createdAt: $createdAt, currency: $currency)';
  }

  @override
  bool operator ==(covariant BranchesModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.phone == phone &&
        other.code == code &&
        other.isAgent == isAgent &&
        other.settlementAccount == settlementAccount &&
        other.balance == balance &&
        other.createdAt == createdAt &&
        other.currency == currency;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        phone.hashCode ^
        code.hashCode ^
        isAgent.hashCode ^
        settlementAccount.hashCode ^
        balance.hashCode ^
        createdAt.hashCode ^
        currency.hashCode;
  }
}
