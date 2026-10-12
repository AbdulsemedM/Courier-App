import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:courier_app/core/theme/app_palette.dart';
import '../../model/shipmet_status_model.dart';

class TrackOrderWidgets {
  static Widget buildShimmerEffect(BuildContext context) {
    final isDarkMode = context.isDarkMode;
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      itemBuilder: (ctx, index) {
        return Shimmer.fromColors(
          baseColor: isDarkMode ? BrandColors.neutral800 : context.palette.border,
          highlightColor: isDarkMode ? BrandColors.neutral700 : context.palette.surfaceMuted,
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.palette.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 120,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      width: 80,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 60,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget buildShipmentCard({
    required BuildContext context,
    required bool isDarkMode,
    required ShipmentModel shipment,
    required bool isSelected,
    required VoidCallback onTap,
    required VoidCallback onLongPress,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isSelected
            ? context.palette.accentMuted
            : context.palette.surface,
        borderRadius: BorderRadius.circular(12),
        border: isSelected
            ? Border.all(
                color: isDarkMode ? BrandColors.info : BrandColors.infoDeep,
                width: 2,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'AWB: ${shipment.awb}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: context.palette.textPrimary,
                      ),
                    ),
                    Row(
                      children: [
                        if (isSelected)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Icon(
                              Icons.check_circle,
                              color: isDarkMode
                                  ? BrandColors.info
                                  : BrandColors.infoDeep,
                              size: 20,
                            ),
                          ),
                        buildStatusChip(
                          shipment.shipmentStatus?.code ?? '',
                          isDarkMode,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'From: ${shipment.senderBranch?.name}',
                  style: TextStyle(
                    color: context.palette.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'To: ${shipment.receiverBranch?.name}',
                  style: TextStyle(
                    color: context.palette.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Qty: ${shipment.qty} ${shipment.unit}',
                      style: TextStyle(
                        color: context.palette.textSecondary,
                      ),
                    ),
                    Text(
                      'Fee: ${shipment.netFee} ${shipment.senderBranch?.currency?.code}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? BrandColors.infoLight : BrandColors.infoDeep,
                      ),
                    ),
                  ],
                ),
                if (shipment.extraFee != null && shipment.extraFee! > 0) ...[
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Extra: ${shipment.extraFee} ${shipment.senderBranch?.currency?.code}',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode
                              ? BrandColors.orangeLight
                              : BrandColors.orangeDeep,
                        ),
                      ),
                      if (shipment.extraFeeDescription?.isNotEmpty == true) ...[
                        const SizedBox(width: 4),
                        Tooltip(
                          message: shipment.extraFeeDescription!,
                          child: Icon(
                            Icons.info_outline,
                            size: 14,
                            color: isDarkMode
                                ? BrandColors.orangeLight
                                : BrandColors.orangeDeep,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_shipping_outlined,
            size: 64,
            color: context.palette.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            'No shipments found',
            style: TextStyle(
              fontSize: 18,
              color: context.palette.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildShipmentList(
    bool isDarkMode,
    List<ShipmentModel> shipments,
    Function(ShipmentModel) onTapShipment,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: shipments.length,
      itemBuilder: (context, index) {
        final shipment = shipments[index];
        return ShipmentCard(
          shipment: shipment,
          isDarkMode: isDarkMode,
          onTap: () => onTapShipment(shipment),
        );
      },
    );
  }

  static Widget buildStatusChip(String status, bool isDarkMode) {
    Color chipColor;
    String statusText;

    switch (status.toUpperCase()) {
      case 'ARR':
        chipColor = BrandColors.success;
        statusText = 'Arrived';
        break;
      case 'TRA':
        chipColor = Colors.cyanAccent;
        statusText = 'In Transit';
        break;
      case 'OTW':
        chipColor = BrandColors.warning;
        statusText = 'On the way';
        break;
      case 'R4P':
        chipColor = BrandColors.orange;
        statusText = 'Ready for pickup';
        break;
      case 'MIS':
        chipColor = BrandColors.danger;
        statusText = 'Missing';
        break;
      case 'DEL':
        chipColor = BrandColors.success;
        statusText = 'Delivered';
      case 'CTM':
        chipColor = BrandColors.info;
        statusText = 'Customs';
        break;
      default:
        chipColor = BrandColors.neutral500;
        statusText = 'Unknown';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: chipColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class ShipmentCard extends StatelessWidget {
  final ShipmentModel shipment;
  final bool isDarkMode;
  final VoidCallback onTap;

  const ShipmentCard({
    super.key,
    required this.shipment,
    required this.isDarkMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'AWB: ${shipment.awb}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: context.palette.textPrimary,
                      ),
                    ),
                    TrackOrderWidgets.buildStatusChip(
                      shipment.shipmentStatus?.code ?? '',
                      isDarkMode,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'From: ${shipment.senderBranch?.name}',
                  style: TextStyle(
                    color: context.palette.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'To: ${shipment.receiverBranch?.name}',
                  style: TextStyle(
                    color: context.palette.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Qty: ${shipment.qty} ${shipment.unit}',
                      style: TextStyle(
                        color: context.palette.textSecondary,
                      ),
                    ),
                    Text(
                      'Fee: ${shipment.netFee} ${shipment.senderBranch?.currency?.code}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? BrandColors.infoLight : BrandColors.infoDeep,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
