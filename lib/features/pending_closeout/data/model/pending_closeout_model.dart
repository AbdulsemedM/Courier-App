// ignore_for_file: public_member_api_docs, sort_constructors_first

class PendingCloseoutModel {
  final int status;
  final String message;
  final List<PendingCloseout> data;
  final int count;

  PendingCloseoutModel({
    required this.status,
    required this.message,
    required this.data,
    required this.count,
  });

  factory PendingCloseoutModel.fromMap(Map<String, dynamic> map) {
    return PendingCloseoutModel(
      status: map['status'] as int? ?? 200,
      message: map['message'] as String? ?? '',
      data: (map['data'] as List<dynamic>?)
              ?.map((item) => PendingCloseout.fromMap(item as Map<String, dynamic>))
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

class PendingCloseout {
  final int liabilityId;
  final String status;
  final double expectedAmount;
  final double actualAmount;
  final double shortfallAmount;
  final String reason;
  final String transactionReference;
  final String createdAt;
  final int tellerId;
  final String tellerName;
  final String tellerStatus;
  final int branchId;
  final String branchName;
  final String branchCode;
  final int recordedById;
  final String recordedByName;
  final String recordedByEmail;
  final String recordedByRole;
  final int daysPending;

  PendingCloseout({
    required this.liabilityId,
    required this.status,
    required this.expectedAmount,
    required this.actualAmount,
    required this.shortfallAmount,
    required this.reason,
    required this.transactionReference,
    required this.createdAt,
    required this.tellerId,
    required this.tellerName,
    required this.tellerStatus,
    required this.branchId,
    required this.branchName,
    required this.branchCode,
    required this.recordedById,
    required this.recordedByName,
    required this.recordedByEmail,
    required this.recordedByRole,
    required this.daysPending,
  });

  factory PendingCloseout.fromMap(Map<String, dynamic> map) {
    return PendingCloseout(
      liabilityId: map['liabilityId'] as int? ?? 0,
      status: map['status'] as String? ?? '',
      expectedAmount: (map['expectedAmount'] as num?)?.toDouble() ?? 0.0,
      actualAmount: (map['actualAmount'] as num?)?.toDouble() ?? 0.0,
      shortfallAmount: (map['shortfallAmount'] as num?)?.toDouble() ?? 0.0,
      reason: map['reason'] as String? ?? '',
      transactionReference: map['transactionReference'] as String? ?? '',
      createdAt: map['createdAt'] as String? ?? '',
      tellerId: map['tellerId'] as int? ?? 0,
      tellerName: map['tellerName'] as String? ?? '',
      tellerStatus: map['tellerStatus'] as String? ?? '',
      branchId: map['branchId'] as int? ?? 0,
      branchName: map['branchName'] as String? ?? '',
      branchCode: map['branchCode'] as String? ?? '',
      recordedById: map['recordedById'] as int? ?? 0,
      recordedByName: map['recordedByName'] as String? ?? '',
      recordedByEmail: map['recordedByEmail'] as String? ?? '',
      recordedByRole: map['recordedByRole'] as String? ?? '',
      daysPending: map['daysPending'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'liabilityId': liabilityId,
      'status': status,
      'expectedAmount': expectedAmount,
      'actualAmount': actualAmount,
      'shortfallAmount': shortfallAmount,
      'reason': reason,
      'transactionReference': transactionReference,
      'createdAt': createdAt,
      'tellerId': tellerId,
      'tellerName': tellerName,
      'tellerStatus': tellerStatus,
      'branchId': branchId,
      'branchName': branchName,
      'branchCode': branchCode,
      'recordedById': recordedById,
      'recordedByName': recordedByName,
      'recordedByEmail': recordedByEmail,
      'recordedByRole': recordedByRole,
      'daysPending': daysPending,
    };
  }
}

