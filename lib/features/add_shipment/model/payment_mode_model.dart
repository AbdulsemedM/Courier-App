class PaymentModeModel {
  final int? id;
  final String? code;
  final String? description;
  final String? addedBy;
  final String? createdAt;
  final String? updatedAt;

  PaymentModeModel({
    this.id,
    this.code,
    this.description,
    this.addedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory PaymentModeModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return PaymentModeModel();

    return PaymentModeModel(
      id: json['id'] as int?,
      code: json['code']?.toString(),
      description: json['description']?.toString(),
      addedBy: json['addedBy']?.toString(),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'description': description,
      'addedBy': addedBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  @override
  String toString() => code ?? description ?? '';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PaymentModeModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  bool get isCash => code?.toUpperCase() == 'CASH';
  bool get isCredit => code?.toUpperCase() == 'CREDIT';
}

// class PaymentMethodModel {
//   final int? id;
//   final String? code;
//   final String? description;
//   final String? addedBy;
//   final String? createdAt;
//   final String? updatedAt;

//   PaymentMethodModel({
//     this.id,
//     this.code,
//     this.description,
//     this.addedBy,
//     this.createdAt,
//     this.updatedAt,
//   });

//   factory PaymentMethodModel.fromJson(Map<String, dynamic>? json) {
//     if (json == null) return PaymentMethodModel();

//     return PaymentMethodModel(
//       id: json['id'] as int?,
//       code: json['code'] as String?,
//       description: json['description'] as String?,
//       addedBy: json['addedBy'] as String?,
//       createdAt: json['createdAt'] as String?,
//       updatedAt: json['updatedAt'] as String?,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'code': code,
//       'description': description,
//       'addedBy': addedBy,
//       'createdAt': createdAt,
//       'updatedAt': updatedAt,
//     };
//   }

//   @override
//   String toString() => code ?? description ?? '';

//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;
//     return other is PaymentMethodModel && other.id == id;
//   }

//   @override
//   int get hashCode => id.hashCode;

//   bool get isCash => code?.toUpperCase() == 'CASH';
//   bool get isBankTransfer => code?.toUpperCase() == 'BANK TRANSFER';
//   bool get isMobileMoney => code?.toUpperCase() == 'MOBILE MONEY';
// }
