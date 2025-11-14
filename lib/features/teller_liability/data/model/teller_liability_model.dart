// ignore_for_file: public_member_api_docs, sort_constructors_first

class TellerLiabilityModel {
  final int status;
  final String message;
  final List<TellerLiability> data;
  final int count;

  TellerLiabilityModel({
    required this.status,
    required this.message,
    required this.data,
    required this.count,
  });

  factory TellerLiabilityModel.fromMap(Map<String, dynamic> map) {
    return TellerLiabilityModel(
      status: map['status'] as int? ?? 200,
      message: map['message'] as String? ?? '',
      data: (map['data'] as List<dynamic>?)
              ?.map((item) => TellerLiability.fromMap(item as Map<String, dynamic>))
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

class TellerLiability {
  final int id;
  final TellerInfo? teller;
  final int branch;
  final double expectedAmount;
  final double actualAmount;
  final double shortfallAmount;
  final String reason;
  final String transactionReference;
  final int recordedBy;
  final String status;
  final String createdAt;

  TellerLiability({
    required this.id,
    this.teller,
    required this.branch,
    required this.expectedAmount,
    required this.actualAmount,
    required this.shortfallAmount,
    required this.reason,
    required this.transactionReference,
    required this.recordedBy,
    required this.status,
    required this.createdAt,
  });

  factory TellerLiability.fromMap(Map<String, dynamic> map) {
    return TellerLiability(
      id: map['id'] as int? ?? 0,
      teller: map['teller'] != null
          ? TellerInfo.fromMap(map['teller'] as Map<String, dynamic>)
          : null,
      branch: map['branch'] is int
          ? map['branch'] as int
          : (map['branch'] is Map
              ? (map['branch'] as Map)['id'] as int? ?? 0
              : 0),
      expectedAmount: (map['expectedAmount'] as num?)?.toDouble() ?? 0.0,
      actualAmount: (map['actualAmount'] as num?)?.toDouble() ?? 0.0,
      shortfallAmount: (map['shortfallAmount'] as num?)?.toDouble() ?? 0.0,
      reason: map['reason'] as String? ?? '',
      transactionReference: map['transactionReference'] as String? ?? '',
      recordedBy: map['recordedBy'] is int
          ? map['recordedBy'] as int
          : (map['recordedBy'] is Map
              ? (map['recordedBy'] as Map)['id'] as int? ?? 0
              : 0),
      status: map['status'] as String? ?? '',
      createdAt: map['createdAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'teller': teller?.toMap(),
      'branch': branch,
      'expectedAmount': expectedAmount,
      'actualAmount': actualAmount,
      'shortfallAmount': shortfallAmount,
      'reason': reason,
      'transactionReference': transactionReference,
      'recordedBy': recordedBy,
      'status': status,
      'createdAt': createdAt,
    };
  }

  String get tellerName => teller?.tellerName ?? 'N/A';
  String get branchName => 'N/A'; // Will be populated from branch lookup if needed
}

class TellerInfo {
  final int id;
  final String tellerName;
  final int branch;
  final String? status;

  TellerInfo({
    required this.id,
    required this.tellerName,
    required this.branch,
    this.status,
  });

  factory TellerInfo.fromMap(Map<String, dynamic> map) {
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
      status: map['status'] as String?,
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

