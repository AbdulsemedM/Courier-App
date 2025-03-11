class BranchModel {
  final int? id;
  final String? name;
  final String? code;
  final String? addedBy;
  final CurrencyModel? currency;
  final CountryModel? country;
  final String? phone;
  final bool? isAgent;
  final double? hudhudPercent;
  final String? createdAt;
  final String? updatedAt;

  BranchModel({
    this.id,
    this.name,
    this.code,
    this.addedBy,
    this.currency,
    this.country,
    this.phone,
    this.isAgent,
    this.hudhudPercent,
    this.createdAt,
    this.updatedAt,
  });

  factory BranchModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return BranchModel();

    return BranchModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      code: json['code'] as String?,
      addedBy: json['addedBy'] as String?,
      currency: json['currency'] != null
          ? CurrencyModel.fromJson(json['currency'] as Map<String, dynamic>)
          : null,
      country: json['country'] != null
          ? CountryModel.fromJson(json['country'] as Map<String, dynamic>)
          : null,
      phone: json['phone'] as String?,
      isAgent: json['isAgent'] as bool?,
      hudhudPercent: json['hudhudPercent']?.toDouble(),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'addedBy': addedBy,
      'currency': currency?.toJson(),
      'country': country?.toJson(),
      'phone': phone,
      'isAgent': isAgent,
      'hudhudPercent': hudhudPercent,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class CurrencyModel {
  final int? id;
  final String? code;
  final String? description;
  final String? addedBy;
  final String? createdAt;
  final String? updatedAt;

  CurrencyModel({
    this.id,
    this.code,
    this.description,
    this.addedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory CurrencyModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return CurrencyModel();

    return CurrencyModel(
      id: json['id'] as int?,
      code: json['code'] as String?,
      description: json['description'] as String?,
      addedBy: json['addedBy'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
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
}

class CountryModel {
  final int? id;
  final String? name;
  final String? isoCode;
  final String? countryCode;
  final String? addedBy;
  final String? createdAt;
  final String? updatedAt;

  CountryModel({
    this.id,
    this.name,
    this.isoCode,
    this.countryCode,
    this.addedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory CountryModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return CountryModel();

    return CountryModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      isoCode: json['isoCode'] as String?,
      countryCode: json['countryCode'] as String?,
      addedBy: json['addedBy'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isoCode': isoCode,
      'countryCode': countryCode,
      'addedBy': addedBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
