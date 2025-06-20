class ShipmentModel {
  final int? id;
  final String? awb;
  final String? senderName;
  final String? senderMobile;
  final Branch? senderBranch;
  final String? receiverName;
  final String? receiverMobile;
  final Branch? receiverBranch;
  final int? qty;
  final String? unit;
  final int? numPcs;
  final int? numBoxes;
  final double? netFee;
  final double? rate;
  final double? extraFee;
  final String? extraFeeDescription;
  final String? shipmentDescription;
  final ServiceMode? serviceMode;
  final PaymentMethod? paymentMethod;
  final TransportMode? transportMode;
  final DeliveryType? deliveryType;
  final ShipmentStatus? shipmentStatus;
  final String? creditAccount;
  final User? addedBy;
  final User? updatedBy;
  final ShipmentType? shipmentType;
  final String? deletedAt;
  final String? createdAt;
  final String? barcodeUrl;
  final String? updatedAt;
  final double? hudhudPercent;
  final double? hudhudNet;
  final User? deliveredBy;
  final String? deliveredAt;
  final bool? softDelete;

  ShipmentModel({
    this.id,
    this.awb,
    this.senderName,
    this.senderMobile,
    this.senderBranch,
    this.receiverName,
    this.receiverMobile,
    this.receiverBranch,
    this.qty,
    this.unit,
    this.numPcs,
    this.numBoxes,
    this.netFee,
    this.rate,
    this.extraFee,
    this.extraFeeDescription,
    this.shipmentDescription,
    this.serviceMode,
    this.paymentMethod,
    this.transportMode,
    this.deliveryType,
    this.shipmentStatus,
    this.creditAccount,
    this.addedBy,
    this.updatedBy,
    this.shipmentType,
    this.deletedAt,
    this.createdAt,
    this.barcodeUrl,
    this.updatedAt,
    this.hudhudPercent,
    this.hudhudNet,
    this.deliveredBy,
    this.deliveredAt,
    this.softDelete,
  });

  factory ShipmentModel.fromJson(Map<String, dynamic> json) {
    return ShipmentModel(
      id: json['id'],
      awb: json['awb'],
      senderName: json['senderName'],
      senderMobile: json['senderMobile'],
      senderBranch: json['senderBranch'] != null
          ? Branch.fromJson(json['senderBranch'])
          : null,
      receiverName: json['receiverName'],
      receiverMobile: json['receiverMobile'],
      receiverBranch: json['receiverBranch'] != null
          ? Branch.fromJson(json['receiverBranch'])
          : null,
      qty: json['qty'],
      unit: json['unit'],
      numPcs: json['numPcs'],
      numBoxes: json['numBoxes'],
      netFee: (json['netFee'] as num?)?.toDouble(),
      rate: (json['rate'] as num?)?.toDouble(),
      extraFee: (json['extraFee'] as num?)?.toDouble(),
      extraFeeDescription: json['extraFeeDescription'],
      shipmentDescription: json['shipmentDescription'],
      serviceMode: json['serviceMode'] != null
          ? ServiceMode.fromJson(json['serviceMode'])
          : null,
      paymentMethod: json['paymentMethod'] != null
          ? PaymentMethod.fromJson(json['paymentMethod'])
          : null,
      transportMode: json['transportMode'] != null
          ? TransportMode.fromJson(json['transportMode'])
          : null,
      deliveryType: json['deliveryType'] != null
          ? DeliveryType.fromJson(json['deliveryType'])
          : null,
      shipmentStatus: json['shipmentStatus'] != null
          ? ShipmentStatus.fromJson(json['shipmentStatus'])
          : null,
      creditAccount: json['creditAccount'],
      addedBy: json['addedBy'] != null ? User.fromJson(json['addedBy']) : null,
      updatedBy:
          json['updatedBy'] != null ? User.fromJson(json['updatedBy']) : null,
      shipmentType: json['shipmentType'] != null
          ? ShipmentType.fromJson(json['shipmentType'])
          : null,
      deletedAt: json['deletedAt'],
      createdAt: json['createdAt'],
      barcodeUrl: json['barcodeUrl'],
      updatedAt: json['updatedAt'],
      hudhudPercent: (json['hudhudPercent'] as num?)?.toDouble(),
      hudhudNet: (json['hudhudNet'] as num?)?.toDouble(),
      deliveredBy: json['deliveredBy'] != null
          ? User.fromJson(json['deliveredBy'])
          : null,
      deliveredAt: json['deliveredAt'],
      softDelete: json['softDelete'],
    );
  }
}

class Branch {
  final int? id;
  final String? name;
  final String? code;
  final User? addedBy;
  final Currency? currency;
  final Country? country;
  final String? phone;
  final bool? isAgent;
  final double? hudhudPercent;
  final String? createdAt;
  final String? updatedAt;

  Branch({
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

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      addedBy: json['addedBy'] != null ? User.fromJson(json['addedBy']) : null,
      currency:
          json['currency'] != null ? Currency.fromJson(json['currency']) : null,
      country:
          json['country'] != null ? Country.fromJson(json['country']) : null,
      phone: json['phone'],
      isAgent: json['isAgent'],
      hudhudPercent: (json['hudhudPercent'] as num?)?.toDouble(),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class Currency {
  final int? id;
  final String? code;
  final String? description;
  final User? addedBy;
  final String? createdAt;
  final String? updatedAt;

  Currency({
    this.id,
    this.code,
    this.description,
    this.addedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      id: json['id'],
      code: json['code'],
      description: json['description'],
      addedBy: json['addedBy'] != null ? User.fromJson(json['addedBy']) : null,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class Country {
  final int? id;
  final String? name;
  final String? isoCode;
  final String? countryCode;
  final User? addedBy;
  final String? createdAt;
  final String? updatedAt;

  Country({
    this.id,
    this.name,
    this.isoCode,
    this.countryCode,
    this.addedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'],
      name: json['name'],
      isoCode: json['isoCode'],
      countryCode: json['countryCode'],
      addedBy: json['addedBy'] != null ? User.fromJson(json['addedBy']) : null,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class User {
  final int? id;
  final String? firstName;
  final String? secondName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? password;
  final bool? isPasswordChanged;
  final Branch? branch;
  final int? status;
  final ServiceMode? serviceMode;
  final User? createdBy;
  final String? createdAt;
  final String? updatedAt;
  final Role? role;

  User({
    this.id,
    this.firstName,
    this.secondName,
    this.lastName,
    this.email,
    this.phone,
    this.password,
    this.isPasswordChanged,
    this.branch,
    this.status,
    this.serviceMode,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'],
      secondName: json['secondName'],
      lastName: json['lastName'],
      email: json['email'],
      phone: json['phone'],
      password: json['password'],
      isPasswordChanged: json['isPasswordChanged'],
      branch: json['branch'] != null ? Branch.fromJson(json['branch']) : null,
      status: json['status'],
      serviceMode: json['serviceMode'] != null
          ? ServiceMode.fromJson(json['serviceMode'])
          : null,
      createdBy:
          json['createdBy'] != null ? User.fromJson(json['createdBy']) : null,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      role: json['role'] != null ? Role.fromJson(json['role']) : null,
    );
  }
}

class ServiceMode {
  final int? id;
  final String? code;
  final String? description;
  final User? addedBy;
  final String? createdAt;
  final String? updatedAt;

  ServiceMode({
    this.id,
    this.code,
    this.description,
    this.addedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory ServiceMode.fromJson(Map<String, dynamic> json) {
    return ServiceMode(
      id: json['id'],
      code: json['code'],
      description: json['description'],
      addedBy: json['addedBy'] != null ? User.fromJson(json['addedBy']) : null,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class Role {
  final int? id;
  final String? role;
  final String? description;
  final User? addedBy;
  final String? createdAt;
  final String? updatedAt;

  Role({
    this.id,
    this.role,
    this.description,
    this.addedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      role: json['role'],
      description: json['description'],
      addedBy: json['addedBy'] != null ? User.fromJson(json['addedBy']) : null,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class PaymentMethod {
  final int? id;
  final String? method;
  final String? description;
  final User? addedBy;
  final String? deletedAt;
  final String? createdAt;
  final String? updatedAt;

  PaymentMethod({
    this.id,
    this.method,
    this.description,
    this.addedBy,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'],
      method: json['method'],
      description: json['description'],
      addedBy: json['addedBy'] != null ? User.fromJson(json['addedBy']) : null,
      deletedAt: json['deletedAt'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class TransportMode {
  final int? id;
  final String? mode;
  final String? description;
  final User? addedBy;
  final String? createdAt;
  final String? updatedAt;

  TransportMode({
    this.id,
    this.mode,
    this.description,
    this.addedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory TransportMode.fromJson(Map<String, dynamic> json) {
    return TransportMode(
      id: json['id'],
      mode: json['mode'],
      description: json['description'],
      addedBy: json['addedBy'] != null ? User.fromJson(json['addedBy']) : null,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class DeliveryType {
  final int? id;
  final String? type;
  final String? description;
  final User? addedBy;
  final String? createdAt;
  final String? updatedAt;

  DeliveryType({
    this.id,
    this.type,
    this.description,
    this.addedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory DeliveryType.fromJson(Map<String, dynamic> json) {
    return DeliveryType(
      id: json['id'],
      type: json['type'],
      description: json['description'],
      addedBy: json['addedBy'] != null ? User.fromJson(json['addedBy']) : null,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class ShipmentStatus {
  final int? id;
  final String? code;
  final String? description;
  final int? addedBy;
  final String? createdAt;
  final String? updatedAt;

  ShipmentStatus({
    this.id,
    this.code,
    this.description,
    this.addedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory ShipmentStatus.fromJson(Map<String, dynamic> json) {
    return ShipmentStatus(
      id: json['id'],
      code: json['code'],
      description: json['description'],
      addedBy: json['addedBy'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class ShipmentType {
  final int? id;
  final String? type;
  final String? description;
  final User? addedBy;
  final String? createdAt;
  final String? updatedAt;

  ShipmentType({
    this.id,
    this.type,
    this.description,
    this.addedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory ShipmentType.fromJson(Map<String, dynamic> json) {
    return ShipmentType(
      id: json['id'],
      type: json['type'],
      description: json['description'],
      addedBy: json['addedBy'] != null ? User.fromJson(json['addedBy']) : null,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
