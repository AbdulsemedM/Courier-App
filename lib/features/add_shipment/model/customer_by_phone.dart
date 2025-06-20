// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CustomerByPhone {
  final int? id;
  final String? fullname;
  final String? phone;
  final String? email;
  final String? status;
  CustomerByPhone({
    this.id,
    this.fullname,
    this.phone,
    this.email,
    this.status,
  });

  CustomerByPhone copyWith({
    int? id,
    String? fullname,
    String? phone,
    String? email,
    String? status,
  }) {
    return CustomerByPhone(
      id: id ?? this.id,
      fullname: fullname ?? this.fullname,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'fullname': fullname,
      'phone': phone,
      'email': email,
      'status': status,
    };
  }

  factory CustomerByPhone.fromMap(Map<String, dynamic> map) {
    return CustomerByPhone(
      id: map['id'] != null ? map['id'] as int : null,
      fullname: map['fullname'] != null ? map['fullname'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomerByPhone.fromJson(String source) =>
      CustomerByPhone.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CustomerByPhone(id: $id, fullname: $fullname, phone: $phone, email: $email, status: $status)';
  }

  @override
  bool operator ==(covariant CustomerByPhone other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.fullname == fullname &&
        other.phone == phone &&
        other.email == email &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        fullname.hashCode ^
        phone.hashCode ^
        email.hashCode ^
        status.hashCode;
  }
}
