// ignore_for_file: public_member_api_docs, sort_constructors_first

class CloseoutTransactionModel {
  final int status;
  final String message;
  final List<CloseoutTransactionItem> data;
  final int count;

  CloseoutTransactionModel({
    required this.status,
    required this.message,
    required this.data,
    required this.count,
  });

  factory CloseoutTransactionModel.fromMap(Map<String, dynamic> map) {
    return CloseoutTransactionModel(
      status: map['status'] as int? ?? 200,
      message: map['message'] as String? ?? '',
      data: (map['data'] as List<dynamic>?)
              ?.map((item) => CloseoutTransactionItem.fromMap(item as Map<String, dynamic>))
              .toList() ??
          [],
      count: map['count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'message': message,
      'data': data.map((item) => item.toMap()).toList(),
      'count': count,
    };
  }
}

class CloseoutTransactionItem {
  final int id;
  final String description;
  final String reference;
  final double amount;
  final String fromAccount;
  final String toAccount;
  final String transactionCategory;
  final String narration;
  final CloseoutUserInfo? byUser;
  final CloseoutTransactionType? transactionType;
  final dynamic branch; // Can be int or Branch object
  final CloseoutTellerInfo? teller;
  final CloseoutShipmentInfo? shipment;
  final double previousBalance;
  final double newBalance;
  final String createdAt;
  final String? updatedAt;
  final String status;
  final String? paymentMode;

  CloseoutTransactionItem({
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
  });

  factory CloseoutTransactionItem.fromMap(Map<String, dynamic> map) {
    return CloseoutTransactionItem(
      id: map['id'] as int? ?? 0,
      description: map['description'] as String? ?? '',
      reference: map['reference'] as String? ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      fromAccount: map['fromAccount'] as String? ?? '',
      toAccount: map['toAccount'] as String? ?? '',
      transactionCategory: map['transactionCategory'] as String? ?? '',
      narration: map['narration'] as String? ?? '',
      byUser: map['byUser'] != null
          ? CloseoutUserInfo.fromMap(map['byUser'] as Map<String, dynamic>)
          : null,
      transactionType: map['transactionType'] != null
          ? CloseoutTransactionType.fromMap(
              map['transactionType'] as Map<String, dynamic>)
          : null,
      branch: map['branch'],
      teller: map['teller'] != null
          ? CloseoutTellerInfo.fromMap(map['teller'] as Map<String, dynamic>)
          : null,
      shipment: map['shipment'] != null
          ? CloseoutShipmentInfo.fromMap(map['shipment'] as Map<String, dynamic>)
          : null,
      previousBalance: (map['previousBalance'] as num?)?.toDouble() ?? 0.0,
      newBalance: (map['newBalance'] as num?)?.toDouble() ?? 0.0,
      createdAt: map['createdAt'] as String? ?? '',
      updatedAt: map['updatedAt'] as String?,
      status: map['status'] as String? ?? '',
      paymentMode: map['paymentMode'] as String?,
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
    };
  }

  String getBranchName() {
    if (branch is Map) {
      return (branch as Map)['name'] as String? ?? 'N/A';
    }
    return 'N/A';
  }

  int getBranchId() {
    if (branch is Map) {
      return (branch as Map)['id'] as int? ?? 0;
    }
    return branch is int ? branch as int : 0;
  }
}

class CloseoutUserInfo {
  final int id;
  final String firstName;
  final String? secondName;
  final String? lastName;
  final String email;
  final String phone;

  CloseoutUserInfo({
    required this.id,
    required this.firstName,
    this.secondName,
    this.lastName,
    required this.email,
    required this.phone,
  });

  factory CloseoutUserInfo.fromMap(Map<String, dynamic> map) {
    return CloseoutUserInfo(
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

class CloseoutTransactionType {
  final int id;
  final String transactionType;
  final String description;

  CloseoutTransactionType({
    required this.id,
    required this.transactionType,
    required this.description,
  });

  factory CloseoutTransactionType.fromMap(Map<String, dynamic> map) {
    return CloseoutTransactionType(
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

class CloseoutTellerInfo {
  final int id;
  final String tellerName;
  final int branch;
  final String status;

  CloseoutTellerInfo({
    required this.id,
    required this.tellerName,
    required this.branch,
    required this.status,
  });

  factory CloseoutTellerInfo.fromMap(Map<String, dynamic> map) {
    // Handle branch - can be int or Map (Branch object)
    int branchId = 0;
    final branchData = map['branch'];
    if (branchData is int) {
      branchId = branchData;
    } else if (branchData is Map<String, dynamic>) {
      branchId = branchData['id'] as int? ?? 0;
    }

    return CloseoutTellerInfo(
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

class CloseoutShipmentInfo {
  final int id;
  final String awb;
  final String senderName;
  final String senderMobile;
  final String receiverName;
  final String receiverMobile;
  final double? totalAmount;
  final String? paymentStatus;
  final String? transactionReference;

  CloseoutShipmentInfo({
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

  factory CloseoutShipmentInfo.fromMap(Map<String, dynamic> map) {
    return CloseoutShipmentInfo(
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

