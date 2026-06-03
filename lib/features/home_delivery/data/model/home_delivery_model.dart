class HomeDeliveryModel {
  final String? awb;
  final String? status;
  final String? receiverName;
  final String? receiverMobile;
  final String? receiverAddress;
  final int? messengerId;
  final String? messengerName;
  final String? estimatedDeliveryTime;
  final String? paymentStatus;
  final double? netFee;

  const HomeDeliveryModel({
    this.awb,
    this.status,
    this.receiverName,
    this.receiverMobile,
    this.receiverAddress,
    this.messengerId,
    this.messengerName,
    this.estimatedDeliveryTime,
    this.paymentStatus,
    this.netFee,
  });

  factory HomeDeliveryModel.fromJson(Map<String, dynamic> json) {
    final messenger = json['messenger'];
    int? parsedMessengerId;
    String? parsedMessengerName;

    if (messenger is Map) {
      parsedMessengerId = _toInt(messenger['id']);
      parsedMessengerName = messenger['name']?.toString();
    } else {
      parsedMessengerId = _toInt(json['messengerId']);
      parsedMessengerName = json['messengerName']?.toString();
    }

    return HomeDeliveryModel(
      awb: json['awb']?.toString(),
      status: json['status']?.toString() ??
          json['deliveryStatus']?.toString() ??
          (json['shipmentStatus'] is Map
              ? json['shipmentStatus']['code']?.toString()
              : null),
      receiverName: json['receiverName']?.toString(),
      receiverMobile: json['receiverMobile']?.toString(),
      receiverAddress: json['receiverAddress']?.toString() ??
          json['deliveryAddress']?.toString(),
      messengerId: parsedMessengerId,
      messengerName: parsedMessengerName,
      estimatedDeliveryTime: json['estimatedDeliveryTime']?.toString(),
      paymentStatus: json['paymentStatus']?.toString(),
      netFee: (json['netFee'] as num?)?.toDouble(),
    );
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  bool get canAssign => messengerId == null;
}
