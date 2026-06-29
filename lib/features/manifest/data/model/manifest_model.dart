class ManifestBranch {
  final int id;
  final String name;
  final String code;

  const ManifestBranch({
    required this.id,
    required this.name,
    required this.code,
  });

  factory ManifestBranch.fromJson(Map<String, dynamic> json) {
    return ManifestBranch(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      code: json['code'] as String? ?? '',
    );
  }

  String get initials {
    final trimmedCode = code.trim();
    if (trimmedCode.isNotEmpty) {
      return trimmedCode
          .substring(0, trimmedCode.length.clamp(0, 2))
          .toUpperCase();
    }
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) return '?';
    return trimmedName.substring(0, 1).toUpperCase();
  }
}

class ManifestUser {
  final int id;
  final String fullName;
  final String email;

  const ManifestUser({
    required this.id,
    required this.fullName,
    required this.email,
  });

  factory ManifestUser.fromJson(Map<String, dynamic> json) {
    final firstName = json['firstName'] as String? ?? '';
    final secondName = json['secondName'] as String? ?? '';
    final lastName = json['lastName'] as String? ?? '';
    final fullName = json['fullName'] as String? ??
        [firstName, secondName, lastName].where((s) => s.isNotEmpty).join(' ');

    return ManifestUser(
      id: json['id'] as int? ?? 0,
      fullName: fullName,
      email: json['email'] as String? ?? '',
    );
  }
}

class ManifestStatus {
  final int id;
  final String code;
  final String description;
  final String name;

  const ManifestStatus({
    required this.id,
    required this.code,
    required this.description,
    required this.name,
  });

  factory ManifestStatus.fromJson(Map<String, dynamic> json) {
    return ManifestStatus(
      id: json['id'] as int? ?? 0,
      code: json['code'] as String? ?? '',
      description: json['description'] as String? ?? '',
      name: json['name'] as String? ?? json['description'] as String? ?? '',
    );
  }
}

class ManifestModel {
  final int id;
  final String manifestId;
  final ManifestBranch branch;
  final int senderBranch;
  final ManifestBranch receiverBranch;
  final ManifestUser createdBy;
  final ManifestStatus fromStatus;
  final ManifestStatus toStatus;
  final String manifestDate;
  final String fileType;
  final String? downloadUrl;
  final String? barcodeUrl;
  final int totalShipments;
  final double totalWeight;
  final double totalValue;
  final String createdAt;
  final String updatedAt;
  final List<String> awbList;

  const ManifestModel({
    required this.id,
    required this.manifestId,
    required this.branch,
    required this.senderBranch,
    required this.receiverBranch,
    required this.createdBy,
    required this.fromStatus,
    required this.toStatus,
    required this.manifestDate,
    required this.fileType,
    this.downloadUrl,
    this.barcodeUrl,
    required this.totalShipments,
    required this.totalWeight,
    required this.totalValue,
    required this.createdAt,
    required this.updatedAt,
    this.awbList = const [],
  });

  factory ManifestModel.fromJson(Map<String, dynamic> json) {
    final isSimplified = !json.containsKey('manifestId') &&
        (json.containsKey('date') || json.containsKey('branchId'));

    if (isSimplified) {
      final awbList = _parseAwbList(json);
      final id = json['id'] as int? ?? 0;
      final branchId = json['branchId'] as int? ?? 0;
      return ManifestModel(
        id: id,
        manifestId: id.toString(),
        branch: ManifestBranch(id: branchId, name: '', code: ''),
        senderBranch: branchId,
        receiverBranch: const ManifestBranch(id: 0, name: '', code: ''),
        createdBy: const ManifestUser(id: 0, fullName: '', email: ''),
        fromStatus:
            const ManifestStatus(id: 0, code: '', description: '', name: ''),
        toStatus:
            const ManifestStatus(id: 0, code: '', description: '', name: ''),
        manifestDate: json['date'] as String? ?? '',
        fileType: '',
        totalShipments: json['totalShipments'] as int? ?? awbList.length,
        totalWeight: 0,
        totalValue: 0,
        createdAt: json['date'] as String? ?? '',
        updatedAt: '',
        awbList: awbList,
      );
    }

    return ManifestModel(
      id: json['id'] as int? ?? 0,
      manifestId: json['manifestId'] as String? ?? '',
      branch: _parseBranch(json['branch']),
      senderBranch: json['senderBranch'] as int? ?? 0,
      receiverBranch: _parseBranch(json['receiverBranch']),
      createdBy: json['createdBy'] is Map<String, dynamic>
          ? ManifestUser.fromJson(json['createdBy'] as Map<String, dynamic>)
          : const ManifestUser(id: 0, fullName: '', email: ''),
      fromStatus: json['fromStatus'] is Map<String, dynamic>
          ? ManifestStatus.fromJson(json['fromStatus'] as Map<String, dynamic>)
          : const ManifestStatus(id: 0, code: '', description: '', name: ''),
      toStatus: json['toStatus'] is Map<String, dynamic>
          ? ManifestStatus.fromJson(json['toStatus'] as Map<String, dynamic>)
          : const ManifestStatus(id: 0, code: '', description: '', name: ''),
      manifestDate: json['manifestDate'] as String? ?? '',
      fileType: json['fileType'] as String? ?? '',
      downloadUrl: json['downloadUrl'] as String?,
      barcodeUrl: json['barcodeUrl'] as String?,
      totalShipments: json['totalShipments'] as int? ?? 0,
      totalWeight: (json['totalWeight'] as num?)?.toDouble() ?? 0,
      totalValue: (json['totalValue'] as num?)?.toDouble() ?? 0,
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
      awbList: _parseAwbList(json),
    );
  }

  static ManifestBranch _parseBranch(dynamic value) {
    if (value is Map<String, dynamic>) {
      return ManifestBranch.fromJson(value);
    }
    if (value is int) {
      return ManifestBranch(id: value, name: '', code: '');
    }
    return const ManifestBranch(id: 0, name: '', code: '');
  }

  static List<String> _parseAwbList(Map<String, dynamic> json) {
    final raw = json['awbList'] ?? json['awbs'];
    if (raw is List) {
      return raw
          .map((e) {
            if (e is Map) return (e['awb'] ?? '').toString();
            return e.toString();
          })
          .where((s) => s.isNotEmpty)
          .toList();
    }
    return const [];
  }

  String get routeLabel =>
      '${branch.name.trim()} → ${receiverBranch.name.trim()}';

  String get creatorLabel => createdBy.fullName;

  String get creatorInitials {
    final parts = createdBy.fullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
        .toUpperCase();
  }

  String get displayDateTime => manifestDate.isNotEmpty ? manifestDate : createdAt;
}

class ManifestListResponse {
  final int status;
  final String message;
  final List<ManifestModel> data;
  final int count;

  const ManifestListResponse({
    required this.status,
    required this.message,
    required this.data,
    required this.count,
  });

  factory ManifestListResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    List<ManifestModel> manifests = [];

    if (rawData is List) {
      manifests = rawData
          .whereType<Map<String, dynamic>>()
          .map(ManifestModel.fromJson)
          .toList();
    }

    return ManifestListResponse(
      status: json['status'] as int? ?? 200,
      message: json['message'] as String? ?? '',
      data: manifests,
      count: json['count'] as int? ?? manifests.length,
    );
  }
}
