// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class EstimatedRateModel {
  final dynamic unit;
  final double rate;
  final double? silverPrice;
  final double? goldPrice;
  final double? platinumPrice;
  final dynamic expectedDurationHours;
  EstimatedRateModel({
    required this.unit,
    required this.rate,
    this.silverPrice,
    this.goldPrice,
    this.platinumPrice,
    required this.expectedDurationHours,
  });

  EstimatedRateModel copyWith({
    dynamic unit,
    double? rate,
    double? silverPrice,
    double? goldPrice,
    double? platinumPrice,
    dynamic expectedDurationHours,
  }) {
    return EstimatedRateModel(
      unit: unit ?? this.unit,
      rate: rate ?? this.rate,
      silverPrice: silverPrice ?? this.silverPrice,
      goldPrice: goldPrice ?? this.goldPrice,
      platinumPrice: platinumPrice ?? this.platinumPrice,
      expectedDurationHours:
          expectedDurationHours ?? this.expectedDurationHours,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'unit': unit,
      'rate': rate,
      'silverPrice': silverPrice,
      'goldPrice': goldPrice,
      'platinumPrice': platinumPrice,
      'expectedDurationHours': expectedDurationHours,
    };
  }

  factory EstimatedRateModel.fromMap(Map<String, dynamic> map) {
    return EstimatedRateModel(
      unit: map['unit'] as dynamic,
      rate: map['rate'] as double,
      silverPrice:
          map['silverPrice'] != null ? map['silverPrice'] as double : null,
      goldPrice: map['goldPrice'] != null ? map['goldPrice'] as double : null,
      platinumPrice:
          map['platinumPrice'] != null ? map['platinumPrice'] as double : null,
      expectedDurationHours: map['expectedDurationHours'] as dynamic,
    );
  }

  String toJson() => json.encode(toMap());

  factory EstimatedRateModel.fromJson(String source) =>
      EstimatedRateModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'EstimatedRateModel(unit: $unit, rate: $rate, silverPrice: $silverPrice, goldPrice: $goldPrice, platinumPrice: $platinumPrice, expectedDurationHours: $expectedDurationHours)';
  }

  @override
  bool operator ==(covariant EstimatedRateModel other) {
    if (identical(this, other)) return true;

    return other.unit == unit &&
        other.rate == rate &&
        other.silverPrice == silverPrice &&
        other.goldPrice == goldPrice &&
        other.platinumPrice == platinumPrice &&
        other.expectedDurationHours == expectedDurationHours;
  }

  @override
  int get hashCode {
    return unit.hashCode ^
        rate.hashCode ^
        silverPrice.hashCode ^
        goldPrice.hashCode ^
        platinumPrice.hashCode ^
        expectedDurationHours.hashCode;
  }
}
