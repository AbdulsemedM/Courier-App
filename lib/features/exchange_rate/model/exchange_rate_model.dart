// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:courier_app/features/currency/model/currency_model.dart';

class ExchangeRateModel {
  final int id;
  final CurrencyModel fromCurrency;
  final CurrencyModel toCurrency;
  final double factor;
  final String createdAt;
  ExchangeRateModel({
    required this.id,
    required this.fromCurrency,
    required this.toCurrency,
    required this.factor,
    required this.createdAt,
  });

  ExchangeRateModel copyWith({
    int? id,
    CurrencyModel? fromCurrency,
    CurrencyModel? toCurrency,
    double? factor,
    String? createdAt,
  }) {
    return ExchangeRateModel(
      id: id ?? this.id,
      fromCurrency: fromCurrency ?? this.fromCurrency,
      toCurrency: toCurrency ?? this.toCurrency,
      factor: factor ?? this.factor,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'fromCurrency': fromCurrency.toMap(),
      'toCurrency': toCurrency.toMap(),
      'factor': factor,
      'createdAt': createdAt,
    };
  }

  factory ExchangeRateModel.fromMap(Map<String, dynamic> map) {
    return ExchangeRateModel(
      id: map['id'] as int,
      fromCurrency: CurrencyModel.fromMap(map['fromCurrency'] as Map<String,dynamic>),
      toCurrency: CurrencyModel.fromMap(map['toCurrency'] as Map<String,dynamic>),
      factor: map['factor'] as double,
      createdAt: map['createdAt'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ExchangeRateModel.fromJson(String source) => ExchangeRateModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ExchangeRateModel(id: $id, fromCurrency: $fromCurrency, toCurrency: $toCurrency, factor: $factor, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant ExchangeRateModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.fromCurrency == fromCurrency &&
      other.toCurrency == toCurrency &&
      other.factor == factor &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      fromCurrency.hashCode ^
      toCurrency.hashCode ^
      factor.hashCode ^
      createdAt.hashCode;
  }
}
