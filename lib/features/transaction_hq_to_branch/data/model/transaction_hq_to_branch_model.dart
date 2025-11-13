// ignore_for_file: public_member_api_docs, sort_constructors_first

class TransactionHqToBranchModel {
  final int status;
  final String message;
  final List<TransactionItem> data;
  final String? startDate;
  final String? endDate;

  TransactionHqToBranchModel({
    required this.status,
    required this.message,
    required this.data,
    this.startDate,
    this.endDate,
  });

  factory TransactionHqToBranchModel.fromMap(Map<String, dynamic> map) {
    return TransactionHqToBranchModel(
      status: map['status'] as int? ?? 200,
      message: map['message'] as String? ?? '',
      data: (map['data'] as List<dynamic>?)
              ?.map((item) => TransactionItem.fromMap(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'message': message,
      'data': data.map((item) => item.toMap()).toList(),
      'startDate': startDate,
      'endDate': endDate,
    };
  }
}

class TransactionItem {
  final int id;
  final String description;
  final String reference;
  final double amount;
  final String fromAccount;
  final String toAccount;
  final String transactionCategory;
  final String narration;
  final UserInfo? byUser;
  final TransactionType? transactionType;
  final dynamic branch; // Can be int or Branch object
  final TellerInfo? teller;
  final ShipmentInfo? shipment;
  final double previousBalance;
  final double newBalance;
  final String createdAt;
  final String? updatedAt;
  final String status;
  final String? paymentMode;
  final String? paymentMethod;

  TransactionItem({
    required this.id,
    required this.description,
    required this.reference,
    required this.amount,
    required this.fromAccount,
    required this.toAccount,
    required this.transactionCategory,
    required this.narration,
    this.byUser,
    this.transactionType,
    this.branch,
    this.teller,
    this.shipment,
    required this.previousBalance,
    required this.newBalance,
    required this.createdAt,
    this.updatedAt,
    required this.status,
    this.paymentMode,
    this.paymentMethod,
  });

  factory TransactionItem.fromMap(Map<String, dynamic> map) {
    return TransactionItem(
      id: map['id'] as int? ?? 0,
      description: map['description'] as String? ?? '',
      reference: map['reference'] as String? ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      fromAccount: map['fromAccount'] as String? ?? '',
      toAccount: map['toAccount'] as String? ?? '',
      transactionCategory: map['transactionCategory'] as String? ?? '',
      narration: map['narration'] as String? ?? '',
      byUser: map['byUser'] != null
          ? UserInfo.fromMap(map['byUser'] as Map<String, dynamic>)
          : null,
      transactionType: map['transactionType'] != null
          ? TransactionType.fromMap(
              map['transactionType'] as Map<String, dynamic>)
          : null,
      branch: map['branch'],
      teller: map['teller'] != null
          ? TellerInfo.fromMap(map['teller'] as Map<String, dynamic>)
          : null,
      shipment: map['shipment'] != null
          ? ShipmentInfo.fromMap(map['shipment'] as Map<String, dynamic>)
          : null,
      previousBalance: (map['previousBalance'] as num?)?.toDouble() ?? 0.0,
      newBalance: (map['newBalance'] as num?)?.toDouble() ?? 0.0,
      createdAt: map['createdAt'] as String? ?? '',
      updatedAt: map['updatedAt'] as String?,
      status: map['status'] as String? ?? '',
      paymentMode: map['paymentMode'] as String?,
      paymentMethod: map['paymentMethod'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'reference': reference,
      'amount': amount,
      'fromAccount': fromAccount,
      'toAccount': toAccount,
      'transactionCategory': transactionCategory,
      'narration': narration,
      'byUser': byUser?.toMap(),
      'transactionType': transactionType?.toMap(),
      'branch': branch,
      'teller': teller?.toMap(),
      'shipment': shipment?.toMap(),
      'previousBalance': previousBalance,
      'newBalance': newBalance,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'status': status,
      'paymentMode': paymentMode,
      'paymentMethod': paymentMethod,
    };
  }
}

class UserInfo {
  final int id;
  final String firstName;
  final String? secondName;
  final String? lastName;
  final String email;
  final String phone;

  UserInfo({
    required this.id,
    required this.firstName,
    this.secondName,
    this.lastName,
    required this.email,
    required this.phone,
  });

  factory UserInfo.fromMap(Map<String, dynamic> map) {
    return UserInfo(
      id: map['id'] as int? ?? 0,
      firstName: map['firstName'] as String? ?? '',
      secondName: map['secondName'] as String?,
      lastName: map['lastName'] as String?,
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'secondName': secondName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
    };
  }

  String get fullName {
    final parts = [firstName, secondName, lastName].where((p) => p != null && p.isNotEmpty).toList();
    return parts.join(' ');
  }
}

class TransactionType {
  final int id;
  final String transactionType;
  final String description;

  TransactionType({
    required this.id,
    required this.transactionType,
    required this.description,
  });

  factory TransactionType.fromMap(Map<String, dynamic> map) {
    return TransactionType(
      id: map['id'] as int? ?? 0,
      transactionType: map['transactionType'] as String? ?? '',
      description: map['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'transactionType': transactionType,
      'description': description,
    };
  }
}

class TellerInfo {
  final int id;
  final String tellerName;
  final int branch;
  final String status;

  TellerInfo({
    required this.id,
    required this.tellerName,
    required this.branch,
    required this.status,
  });

  factory TellerInfo.fromMap(Map<String, dynamic> map) {
    // Handle branch - can be int or Map (Branch object)
    int branchId = 0;
    final branchData = map['branch'];
    if (branchData is int) {
      branchId = branchData;
    } else if (branchData is Map<String, dynamic>) {
      branchId = branchData['id'] as int? ?? 0;
    }

    return TellerInfo(
      id: map['id'] as int? ?? 0,
      tellerName: map['tellerName'] as String? ?? '',
      branch: branchId,
      status: map['status'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tellerName': tellerName,
      'branch': branch,
      'status': status,
    };
  }
}

class ShipmentInfo {
  final int id;
  final String awb;
  final String senderName;
  final String senderMobile;
  final String receiverName;
  final String receiverMobile;
  final double? totalAmount;
  final String? paymentStatus;
  final String? transactionReference;

  ShipmentInfo({
    required this.id,
    required this.awb,
    required this.senderName,
    required this.senderMobile,
    required this.receiverName,
    required this.receiverMobile,
    this.totalAmount,
    this.paymentStatus,
    this.transactionReference,
  });

  factory ShipmentInfo.fromMap(Map<String, dynamic> map) {
    return ShipmentInfo(
      id: map['id'] as int? ?? 0,
      awb: map['awb'] as String? ?? '',
      senderName: map['senderName'] as String? ?? '',
      senderMobile: map['senderMobile'] as String? ?? '',
      receiverName: map['receiverName'] as String? ?? '',
      receiverMobile: map['receiverMobile'] as String? ?? '',
      totalAmount: (map['totalAmount'] as num?)?.toDouble(),
      paymentStatus: map['paymentStatus'] as String?,
      transactionReference: map['transactionReference'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'awb': awb,
      'senderName': senderName,
      'senderMobile': senderMobile,
      'receiverName': receiverName,
      'receiverMobile': receiverMobile,
      'totalAmount': totalAmount,
      'paymentStatus': paymentStatus,
      'transactionReference': transactionReference,
    };
  }
}

