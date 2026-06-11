import 'package:courier_app/features/track_order/model/statuses_model.dart';
import 'package:flutter/material.dart';

class ShipmentStatusHelper {
  static const pendingStatusCode = 'PAR';
  static const readyForPickupStatusCode = 'R4P';
  static const arrivedStatusCode = 'ARR';
  static const deliveredStatusCode = 'DEL';

  static StatusModel pendingStatus() {
    return StatusModel(
      id: 0,
      code: pendingStatusCode,
      description: 'Pending',
      name: 'Pending',
      addedBy: 0,
      createdAt: '',
    );
  }

  static StatusModel readyForPickupStatus() {
    return StatusModel(
      id: 0,
      code: readyForPickupStatusCode,
      description: 'Ready For Pickup',
      name: 'Ready For Pickup',
      addedBy: 0,
      createdAt: '',
    );
  }

  /// Normalizes PAR/R4P labels and ensures they exist in filters and modals.
  static List<StatusModel> withAppStatuses(List<StatusModel> statuses) {
    var result = statuses.map(_normalizeStatus).toList();

    if (!result.any((s) => s.code.toUpperCase() == pendingStatusCode)) {
      result = [...result, pendingStatus()];
    }
    if (!result.any((s) => s.code.toUpperCase() == readyForPickupStatusCode)) {
      result = [...result, readyForPickupStatus()];
    }

    return result;
  }

  static StatusModel _normalizeStatus(StatusModel status) {
    switch (status.code.toUpperCase()) {
      case pendingStatusCode:
        return status.copyWith(name: 'Pending', description: 'Pending');
      case readyForPickupStatusCode:
        return status.copyWith(
          name: 'Ready For Pickup',
          description: 'Ready For Pickup',
        );
      default:
        return status;
    }
  }

  static String displayLabelForCode(
    String code, [
    List<StatusModel>? statuses,
  ]) {
    switch (code.toUpperCase()) {
      case pendingStatusCode:
        return 'Pending';
      case readyForPickupStatusCode:
        return 'Ready For Pickup';
      default:
        break;
    }
    if (statuses != null) return labelForCode(code, statuses);
    return code;
  }

  /// Pay is shown when payment has not completed successfully.
  static bool needsPayment(String? paymentStatus) {
    if (paymentStatus == null || paymentStatus.trim().isEmpty) {
      return true;
    }
    return paymentStatus.trim().toUpperCase() != 'SUCCESS';
  }

  static bool isCashPayment(String? paymentMode) {
    if (paymentMode == null || paymentMode.trim().isEmpty) {
      return false;
    }

    final normalized = paymentMode.trim().toUpperCase();
    return normalized == 'CASH' ||
        normalized == 'COD' ||
        normalized.contains('CASH ON DELIVERY');
  }

  /// Whether the shipments table should show the Pay action for a row.
  static bool shouldShowPayAction({
    required String shipmentStatusCode,
    required String? paymentStatus,
    String? paymentMode,
  }) {
    if (isCashPayment(paymentMode)) {
      return false;
    }

    final code = shipmentStatusCode.trim().toUpperCase();

    // PAR: only show Pay when payment status is known and not successful.
    if (code == pendingStatusCode) {
      if (paymentStatus == null || paymentStatus.trim().isEmpty) {
        return false;
      }
      return needsPayment(paymentStatus);
    }

    return needsPayment(paymentStatus);
  }

  static bool isPaymentFulfilled(String? paymentStatus) {
    if (paymentStatus == null || paymentStatus.trim().isEmpty) {
      return false;
    }

    final normalized = paymentStatus.trim().toUpperCase();
    return normalized == 'SUCCESS' || normalized == 'PAID';
  }

  static bool isDeliveredStatusCode(String? statusCode) {
    if (statusCode == null || statusCode.trim().isEmpty) {
      return false;
    }

    final normalized = statusCode.trim().toUpperCase();
    return normalized == deliveredStatusCode ||
        normalized == 'DELIVERED' ||
        normalized == 'COMPLETED';
  }

  static bool isDeliveredStatusLabel(String? statusLabel) {
    if (statusLabel == null || statusLabel.trim().isEmpty) {
      return false;
    }

    final normalized = statusLabel.trim().toUpperCase();
    return normalized == 'DELIVERED' ||
        normalized == 'COMPLETED' ||
        normalized.contains('DELIVERED');
  }

  static bool isAlreadyDelivered({
    String? shipmentStatusCode,
    String? shipmentStatusLabel,
  }) {
    return isDeliveredStatusCode(shipmentStatusCode) ||
        isDeliveredStatusLabel(shipmentStatusLabel);
  }

  static bool isDeliverableStatusCode(String? statusCode) {
    if (statusCode == null || statusCode.trim().isEmpty) {
      return false;
    }

    if (isDeliveredStatusCode(statusCode)) {
      return false;
    }

    final normalized = statusCode.trim().toUpperCase();
    return normalized == arrivedStatusCode || normalized == readyForPickupStatusCode;
  }

  static bool isDeliverableStatusLabel(String? statusLabel) {
    if (statusLabel == null || statusLabel.trim().isEmpty) {
      return false;
    }

    if (isDeliveredStatusLabel(statusLabel)) {
      return false;
    }

    final normalized = statusLabel.trim().toUpperCase();
    return normalized == 'ARRIVED' || normalized == 'READY FOR PICKUP';
  }

  static bool shouldShowDeliverAction({
    required String? shipmentStatusCode,
    required String? shipmentStatusLabel,
    required String? paymentStatus,
    String? paymentMode,
  }) {
    if (isAlreadyDelivered(
      shipmentStatusCode: shipmentStatusCode,
      shipmentStatusLabel: shipmentStatusLabel,
    )) {
      return false;
    }

    final isDeliverable = isDeliverableStatusCode(shipmentStatusCode) ||
        isDeliverableStatusLabel(shipmentStatusLabel);
    if (!isDeliverable) {
      return false;
    }

    if (isCashPayment(paymentMode)) {
      return true;
    }

    return isPaymentFulfilled(paymentStatus);
  }

  static bool shouldShowPayBeforeDeliverAction({
    required String? shipmentStatusCode,
    required String? shipmentStatusLabel,
    required String? paymentStatus,
    String? paymentMode,
  }) {
    if (isCashPayment(paymentMode)) {
      return false;
    }

    if (isAlreadyDelivered(
      shipmentStatusCode: shipmentStatusCode,
      shipmentStatusLabel: shipmentStatusLabel,
    )) {
      return false;
    }

    final isDeliverable = isDeliverableStatusCode(shipmentStatusCode) ||
        isDeliverableStatusLabel(shipmentStatusLabel);
    return isDeliverable && needsPayment(paymentStatus);
  }

  static String displayLabel(StatusModel status) {
    final name = status.name?.trim();
    if (name != null && name.isNotEmpty) return name;

    final description = status.description.trim();
    if (description.isNotEmpty) return description;

    return status.code;
  }

  static String labelForCode(String code, List<StatusModel> statuses) {
    switch (code.toUpperCase()) {
      case pendingStatusCode:
        return 'Pending';
      case readyForPickupStatusCode:
        return 'Ready For Pickup';
      default:
        break;
    }
    for (final status in statuses) {
      if (status.code == code) return displayLabel(status);
    }
    return code;
  }

  static IconData iconForCode(String code) {
    switch (code.toUpperCase()) {
      case 'OTW':
        return Icons.directions_transit_outlined;
      case 'ARR':
        return Icons.local_shipping_outlined;
      case 'MIS':
        return Icons.help_outline;
      case 'TRA':
        return Icons.swap_horiz;
      case 'CTM':
        return Icons.gavel_outlined;
      case 'DEL':
        return Icons.check_circle_outline;
      case 'R4P':
        return Icons.inventory_2_outlined;
      case 'PAR':
        return Icons.pending_actions_outlined;
      default:
        return Icons.local_shipping_outlined;
    }
  }

  static Color colorForCode(String code) {
    switch (code.toUpperCase()) {
      case 'OTW':
        return Colors.blue;
      case 'ARR':
        return Colors.green;
      case 'MIS':
        return Colors.red;
      case 'TRA':
        return Colors.orange;
      case 'CTM':
        return Colors.brown;
      case 'DEL':
        return Colors.teal;
      case 'R4P':
        return Colors.deepOrange;
      case 'PAR':
        return Colors.amber;
      default:
        return Colors.purple;
    }
  }
}
