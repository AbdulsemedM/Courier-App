// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DiscountModel {
  final double weightKg;
  final double basePricePerKg;
  final double discountPricePerKg;
  final double originalTotal;
  final double discountedTotal;
  final double discountAmount;
  final double discountPercentage;
  final double discountKgEquivalent;
  final String currency;

  DiscountModel({
    required this.weightKg,
    required this.basePricePerKg,
    required this.discountPricePerKg,
    required this.originalTotal,
    required this.discountedTotal,
    required this.discountAmount,
    required this.discountPercentage,
    required this.discountKgEquivalent,
    required this.currency,
  });

  DiscountModel copyWith({
    double? weightKg,
    double? basePricePerKg,
    double? discountPricePerKg,
    double? originalTotal,
    double? discountedTotal,
    double? discountAmount,
    double? discountPercentage,
    double? discountKgEquivalent,
    String? currency,
  }) {
    return DiscountModel(
      weightKg: weightKg ?? this.weightKg,
      basePricePerKg: basePricePerKg ?? this.basePricePerKg,
      discountPricePerKg: discountPricePerKg ?? this.discountPricePerKg,
      originalTotal: originalTotal ?? this.originalTotal,
      discountedTotal: discountedTotal ?? this.discountedTotal,
      discountAmount: discountAmount ?? this.discountAmount,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      discountKgEquivalent: discountKgEquivalent ?? this.discountKgEquivalent,
      currency: currency ?? this.currency,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'weightKg': weightKg,
      'basePricePerKg': basePricePerKg,
      'discountPricePerKg': discountPricePerKg,
      'originalTotal': originalTotal,
      'discountedTotal': discountedTotal,
      'discountAmount': discountAmount,
      'discountPercentage': discountPercentage,
      'discountKgEquivalent': discountKgEquivalent,
      'currency': currency,
    };
  }

  factory DiscountModel.fromMap(Map<String, dynamic> map) {
    return DiscountModel(
      weightKg: (map['weightKg'] as num?)?.toDouble() ?? 0.0,
      basePricePerKg: (map['basePricePerKg'] as num?)?.toDouble() ?? 0.0,
      discountPricePerKg:
          (map['discountPricePerKg'] as num?)?.toDouble() ?? 0.0,
      originalTotal: (map['originalTotal'] as num?)?.toDouble() ?? 0.0,
      discountedTotal: (map['discountedTotal'] as num?)?.toDouble() ?? 0.0,
      discountAmount: (map['discountAmount'] as num?)?.toDouble() ?? 0.0,
      discountPercentage:
          (map['discountPercentage'] as num?)?.toDouble() ?? 0.0,
      discountKgEquivalent:
          (map['discountKgEquivalent'] as num?)?.toDouble() ?? 0.0,
      currency: map['currency'] as String? ?? 'ETB',
    );
  }

  String toJson() => json.encode(toMap());

  factory DiscountModel.fromJson(String source) =>
      DiscountModel.fromMap(json.decode(source) as Map<String, dynamic>);

  // Helper method to round big decimal numbers
  DiscountModel rounded() {
    return DiscountModel(
      weightKg: double.parse(weightKg.toStringAsFixed(2)),
      basePricePerKg: double.parse(basePricePerKg.toStringAsFixed(2)),
      discountPricePerKg: double.parse(discountPricePerKg.toStringAsFixed(2)),
      originalTotal: double.parse(originalTotal.toStringAsFixed(2)),
      discountedTotal: double.parse(discountedTotal.toStringAsFixed(2)),
      discountAmount: double.parse(discountAmount.toStringAsFixed(2)),
      discountPercentage: double.parse(discountPercentage.toStringAsFixed(2)),
      discountKgEquivalent:
          double.parse(discountKgEquivalent.toStringAsFixed(2)),
      currency: currency,
    );
  }

  @override
  String toString() {
    return 'DiscountModel(weightKg: $weightKg, basePricePerKg: $basePricePerKg, discountPricePerKg: $discountPricePerKg, originalTotal: $originalTotal, discountedTotal: $discountedTotal, discountAmount: $discountAmount, discountPercentage: $discountPercentage, discountKgEquivalent: $discountKgEquivalent, currency: $currency)';
  }

  @override
  bool operator ==(covariant DiscountModel other) {
    if (identical(this, other)) return true;

    return other.weightKg == weightKg &&
        other.basePricePerKg == basePricePerKg &&
        other.discountPricePerKg == discountPricePerKg &&
        other.originalTotal == originalTotal &&
        other.discountedTotal == discountedTotal &&
        other.discountAmount == discountAmount &&
        other.discountPercentage == discountPercentage &&
        other.discountKgEquivalent == discountKgEquivalent &&
        other.currency == currency;
  }

  @override
  int get hashCode {
    return weightKg.hashCode ^
        basePricePerKg.hashCode ^
        discountPricePerKg.hashCode ^
        originalTotal.hashCode ^
        discountedTotal.hashCode ^
        discountAmount.hashCode ^
        discountPercentage.hashCode ^
        discountKgEquivalent.hashCode ^
        currency.hashCode;
  }
}
