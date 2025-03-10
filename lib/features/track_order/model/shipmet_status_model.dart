class ShipmentModel {
  final int id;
  final String awb;
  final String senderName;
  final String senderMobile;
  final Branch senderBranch;
  final String receiverName;
  final String receiverMobile;
  final Branch receiverBranch;
  final int qty;
  final String unit;
  final int numPcs;
  final int numBoxes;
  final double netFee;
  final double rate;
  final double extraFee;
  final String? extraFeeDescription;
  final String shipmentDescription;
  final ServiceMode serviceMode;
  final PaymentMethod paymentMethod;
  final TransportMode transportMode;
  final DeliveryType deliveryType;
  final ShipmentStatus shipmentStatus;
  final String creditAccount;
  final User addedBy;
  final User? updatedBy;
  final ShipmentType shipmentType;
  final String? deletedAt;
  final String createdAt;
  final String? barcodeUrl;
  final String updatedAt;
  final double hudhudPercent;
  final double hudhudNet;
  final User? deliveredBy;
  final String? deliveredAt;
  final bool softDelete;

  ShipmentModel({
    required this.id,
    required this.awb,
    required this.senderName,
    required this.senderMobile,
    required this.senderBranch,
    required this.receiverName,
    required this.receiverMobile,
    required this.receiverBranch,
    required this.qty,
    required this.unit,
    required this.numPcs,
    required this.numBoxes,
    required this.netFee,
    required this.rate,
    required this.extraFee,
    this.extraFeeDescription,
    required this.shipmentDescription,
    required this.serviceMode,
    required this.paymentMethod,
    required this.transportMode,
    required this.deliveryType,
    required this.shipmentStatus,
    required this.creditAccount,
    required this.addedBy,
    this.updatedBy,
    required this.shipmentType,
    this.deletedAt,
    required this.createdAt,
    this.barcodeUrl,
    required this.updatedAt,
    required this.hudhudPercent,
    required this.hudhudNet,
    this.deliveredBy,
    this.deliveredAt,
    required this.softDelete,
  });

  factory ShipmentModel.fromJson(Map<String, dynamic> json) {
    return ShipmentModel(
      id: json['id'] ?? 0,
      awb: json['awb'] ?? '',
      senderName: json['senderName'] ?? '',
      senderMobile: json['senderMobile'] ?? '',
      senderBranch: Branch.fromJson(json['senderBranch'] ?? {}),
      receiverName: json['receiverName'] ?? '',
      receiverMobile: json['receiverMobile'] ?? '',
      receiverBranch: Branch.fromJson(json['receiverBranch'] ?? {}),
      qty: json['qty'] ?? 0,
      unit: json['unit'] ?? '',
      numPcs: json['numPcs'] ?? 0,
      numBoxes: json['numBoxes'] ?? 0,
      netFee: (json['netFee'] ?? 0).toDouble(),
      rate: (json['rate'] ?? 0).toDouble(),
      extraFee: (json['extraFee'] ?? 0).toDouble(),
      extraFeeDescription: json['extraFeeDescription'],
      shipmentDescription: json['shipmentDescription'] ?? '',
      serviceMode: ServiceMode.fromJson(json['serviceMode'] ?? {}),
      paymentMethod: PaymentMethod.fromJson(json['paymentMethod'] ?? {}),
      transportMode: TransportMode.fromJson(json['transportMode'] ?? {}),
      deliveryType: DeliveryType.fromJson(json['deliveryType'] ?? {}),
      shipmentStatus: ShipmentStatus.fromJson(json['shipmentStatus'] ?? {}),
      creditAccount: json['creditAccount'] ?? '',
      addedBy: User.fromJson(json['addedBy'] ?? {}),
      updatedBy:
          json['updatedBy'] != null ? User.fromJson(json['updatedBy']) : null,
      shipmentType: ShipmentType.fromJson(json['shipmentType'] ?? {}),
      deletedAt: json['deletedAt'],
      createdAt: json['createdAt'] ?? '',
      barcodeUrl: json['barcodeUrl'],
      updatedAt: json['updatedAt'] ?? '',
      hudhudPercent: (json['hudhudPercent'] ?? 0).toDouble(),
      hudhudNet: (json['hudhudNet'] ?? 0).toDouble(),
      deliveredBy: json['deliveredBy'] != null
          ? User.fromJson(json['deliveredBy'])
          : null,
      deliveredAt: json['deliveredAt'],
      softDelete: json['softDelete'] ?? false,
    );
  }
}

class Branch {
  final int id;
  final String name;
  final String code;
  final User? addedBy;
  final Currency currency;
  final Country country;
  final String phone;
  final bool isAgent;
  final double hudhudPercent;
  final String createdAt;
  final String? updatedAt;

  Branch({
    required this.id,
    required this.name,
    required this.code,
    this.addedBy,
    required this.currency,
    required this.country,
    required this.phone,
    required this.isAgent,
    required this.hudhudPercent,
    required this.createdAt,
    this.updatedAt,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      addedBy: json['addedBy'] != null ? User.fromJson(json['addedBy']) : null,
      currency: Currency.fromJson(json['currency']),
      country: Country.fromJson(json['country']),
      phone: json['phone'],
      isAgent: json['isAgent'],
      hudhudPercent: json['hudhudPercent'].toDouble(),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class Currency {
  final int id;
  final String code;
  final String description;
  final User? addedBy;
  final String createdAt;
  final String? updatedAt;

  Currency({
    required this.id,
    required this.code,
    required this.description,
    this.addedBy,
    required this.createdAt,
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
  final int id;
  final String name;
  final String isoCode;
  final String countryCode;
  final User? addedBy;
  final String createdAt;
  final String? updatedAt;

  Country({
    required this.id,
    required this.name,
    required this.isoCode,
    required this.countryCode,
    this.addedBy,
    required this.createdAt,
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
  final int id;
  final String firstName;
  final String secondName;
  final String lastName;
  final String email;
  final String phone;
  final String password;
  final bool isPasswordChanged;
  final Branch branch;
  final int status;
  final ServiceMode serviceMode;
  final User? createdBy;
  final String createdAt;
  final String? updatedAt;
  final Role role;

  User({
    required this.id,
    required this.firstName,
    required this.secondName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.password,
    required this.isPasswordChanged,
    required this.branch,
    required this.status,
    required this.serviceMode,
    this.createdBy,
    required this.createdAt,
    this.updatedAt,
    required this.role,
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
      branch: Branch.fromJson(json['branch']),
      status: json['status'],
      serviceMode: ServiceMode.fromJson(json['serviceMode']),
      createdBy:
          json['createdBy'] != null ? User.fromJson(json['createdBy']) : null,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      role: Role.fromJson(json['role']),
    );
  }
}

class ServiceMode {
  final int id;
  final String code;
  final String description;
  final User? addedBy;
  final String createdAt;
  final String? updatedAt;

  ServiceMode({
    required this.id,
    required this.code,
    required this.description,
    this.addedBy,
    required this.createdAt,
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
  final int id;
  final String role;
  final String description;
  final User? addedBy;
  final String createdAt;
  final String? updatedAt;

  Role({
    required this.id,
    required this.role,
    required this.description,
    this.addedBy,
    required this.createdAt,
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
  final int id;
  final String method;
  final String description;
  final User addedBy;
  final String? deletedAt;
  final String createdAt;
  final String? updatedAt;

  PaymentMethod({
    required this.id,
    required this.method,
    required this.description,
    required this.addedBy,
    this.deletedAt,
    required this.createdAt,
    this.updatedAt,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'],
      method: json['method'],
      description: json['description'],
      addedBy: User.fromJson(json['addedBy']),
      deletedAt: json['deletedAt'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class TransportMode {
  final int id;
  final String mode;
  final String description;
  final User addedBy;
  final String createdAt;
  final String? updatedAt;

  TransportMode({
    required this.id,
    required this.mode,
    required this.description,
    required this.addedBy,
    required this.createdAt,
    this.updatedAt,
  });

  factory TransportMode.fromJson(Map<String, dynamic> json) {
    return TransportMode(
      id: json['id'],
      mode: json['mode'],
      description: json['description'],
      addedBy: User.fromJson(json['addedBy']),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class DeliveryType {
  final int id;
  final String type;
  final String description;
  final User addedBy;
  final String createdAt;
  final String? updatedAt;

  DeliveryType({
    required this.id,
    required this.type,
    required this.description,
    required this.addedBy,
    required this.createdAt,
    this.updatedAt,
  });

  factory DeliveryType.fromJson(Map<String, dynamic> json) {
    return DeliveryType(
      id: json['id'],
      type: json['type'],
      description: json['description'],
      addedBy: User.fromJson(json['addedBy']),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class ShipmentStatus {
  final int id;
  final String code;
  final String description;
  final int addedBy;
  final String createdAt;
  final String? updatedAt;

  ShipmentStatus({
    required this.id,
    required this.code,
    required this.description,
    required this.addedBy,
    required this.createdAt,
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
  final int id;
  final String type;
  final String description;
  final User addedBy;
  final String createdAt;
  final String? updatedAt;

  ShipmentType({
    required this.id,
    required this.type,
    required this.description,
    required this.addedBy,
    required this.createdAt,
    this.updatedAt,
  });

  factory ShipmentType.fromJson(Map<String, dynamic> json) {
    return ShipmentType(
      id: json['id'],
      type: json['type'],
      description: json['description'],
      addedBy: User.fromJson(json['addedBy']),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
