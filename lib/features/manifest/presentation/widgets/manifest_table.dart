import 'package:courier_app/core/theme/app_palette.dart';
import 'package:courier_app/core/utils/shipment_status_helper.dart';
import 'package:courier_app/features/manifest/data/model/manifest_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ManifestTable extends StatelessWidget {
  final List<ManifestModel> manifests;
  final void Function(ManifestModel manifest)? onManageAwbs;
  final void Function(ManifestModel manifest)? onDownload;
  final void Function(ManifestModel manifest)? onShowQr;

  const ManifestTable({
    super.key,
    required this.manifests,
    this.onManageAwbs,
    this.onDownload,
    this.onShowQr,
  });

  String _formatWeight(double value) {
    return NumberFormat('#,##0.##').format(value);
  }

  String _formatValue(double value) {
    return NumberFormat('#,##0.00').format(value);
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: DataTable(
            columnSpacing: 20,
            headingRowHeight: 48,
            dataRowMinHeight: 72,
            headingRowColor: WidgetStateProperty.all(palette.surfaceMuted),
            columns: [
              _column('Route', palette),
              _column('Status Change', palette),
              _column('Totals', palette),
              _column('AWB List', palette),
              _column('Created By', palette),
              _column('Actions', palette),
            ],
            rows: manifests.map((manifest) {
              return DataRow(
                cells: [
                  DataCell(_routeCell(manifest, palette)),
                  DataCell(_statusCell(manifest, palette)),
                  DataCell(_totalsCell(manifest, palette)),
                  DataCell(_awbListCell(manifest, palette)),
                  DataCell(_creatorCell(manifest, palette)),
                  DataCell(_actionsCell(manifest, palette)),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _routeCell(ManifestModel manifest, AppPalette palette) {
    final origin = manifest.branch.name.trim();
    final destination = manifest.receiverBranch.name.trim();

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 180, maxWidth: 260),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (origin.isNotEmpty) ...[
            Flexible(
              child: Text(
                origin,
                style: TextStyle(color: palette.textPrimary),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Icon(
                Icons.arrow_forward,
                size: 14,
                color: palette.textSecondary,
              ),
            ),
          ],
          CircleAvatar(
            radius: 14,
            backgroundColor: Colors.deepPurple,
            child: Text(
              manifest.receiverBranch.initials,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              destination.isNotEmpty ? destination : '-',
              style: TextStyle(
                color: palette.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusCell(ManifestModel manifest, AppPalette palette) {
    final fromLabel =
        ShipmentStatusHelper.displayLabelForCode(manifest.fromStatus.code);
    final toLabel =
        ShipmentStatusHelper.displayLabelForCode(manifest.toStatus.code);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _statusCodeBadge(manifest.fromStatus.code),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Icon(
                Icons.arrow_forward,
                size: 14,
                color: palette.textSecondary,
              ),
            ),
            _statusCodeBadge(manifest.toStatus.code),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '$fromLabel → $toLabel',
          style: TextStyle(
            fontSize: 11,
            color: palette.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _statusCodeBadge(String code) {
    if (code.trim().isEmpty) {
      return const SizedBox.shrink();
    }
    final color = ShipmentStatusHelper.colorForCode(code);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        code.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _totalsCell(ManifestModel manifest, AppPalette palette) {
    final shipmentLabel = manifest.totalShipments == 1
        ? '1 shipment'
        : '${manifest.totalShipments} shipments';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          shipmentLabel,
          style: TextStyle(
            color: palette.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text.rich(
          TextSpan(
            style: TextStyle(fontSize: 12, color: palette.textSecondary),
            children: [
              const TextSpan(text: 'Weight: '),
              TextSpan(
                text: '${_formatWeight(manifest.totalWeight)} kg',
                style: TextStyle(
                  color: palette.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Text.rich(
          TextSpan(
            style: TextStyle(fontSize: 12, color: palette.textSecondary),
            children: [
              const TextSpan(text: 'Value: '),
              TextSpan(
                text: '${_formatValue(manifest.totalValue)} ETB',
                style: TextStyle(
                  color: palette.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _awbListCell(ManifestModel manifest, AppPalette palette) {
    final awbs = manifest.awbList;
    final count = awbs.isNotEmpty ? awbs.length : manifest.totalShipments;
    final countLabel = count == 1 ? '1 AWB' : '$count AWBs';

    if (awbs.isEmpty) {
      return SizedBox(
        width: 220,
        child: Text(
          countLabel,
          style: TextStyle(
            color: palette.accent,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      );
    }

    final visible = awbs.take(3).toList();
    final overflow = awbs.length - visible.length;

    return SizedBox(
      width: 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            countLabel,
            style: TextStyle(
              color: palette.accent,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              ...visible.map((awb) => _awbChip(awb, palette)),
              if (overflow > 0)
                GestureDetector(
                  onTap: onManageAwbs != null
                      ? () => onManageAwbs!(manifest)
                      : null,
                  child: _overflowChip('+$overflow', palette),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _awbChip(String awb, AppPalette palette) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: palette.accentMuted,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: palette.border),
      ),
      child: Text(
        awb,
        style: TextStyle(
          fontSize: 11,
          color: palette.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _overflowChip(String label, AppPalette palette) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.deepPurple.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          color: Colors.deepPurple,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _creatorCell(ManifestModel manifest, AppPalette palette) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: palette.accent.withOpacity(0.15),
          child: Text(
            manifest.creatorInitials,
            style: TextStyle(
              color: palette.accent,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              manifest.creatorLabel,
              style: TextStyle(
                color: palette.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (manifest.createdBy.email.isNotEmpty)
              Text(
                manifest.createdBy.email,
                style: TextStyle(
                  fontSize: 12,
                  color: palette.textSecondary,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _actionsCell(ManifestModel manifest, AppPalette palette) {
    final hasDownload =
        manifest.downloadUrl != null && manifest.downloadUrl!.isNotEmpty;
    final hasQr =
        manifest.barcodeUrl != null && manifest.barcodeUrl!.isNotEmpty;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.edit_outlined, color: palette.accent, size: 20),
          tooltip: 'Manage AWBs',
          onPressed:
              onManageAwbs != null ? () => onManageAwbs!(manifest) : null,
        ),
        IconButton(
          icon: Icon(
            Icons.download_outlined,
            color: hasDownload ? palette.accent : palette.textSecondary,
            size: 20,
          ),
          tooltip: 'Download',
          onPressed: hasDownload && onDownload != null
              ? () => onDownload!(manifest)
              : null,
        ),
        IconButton(
          icon: Icon(
            Icons.qr_code_2_outlined,
            color: hasQr ? Colors.deepPurple : palette.textSecondary,
            size: 20,
          ),
          tooltip: 'QR Code',
          onPressed:
              hasQr && onShowQr != null ? () => onShowQr!(manifest) : null,
        ),
      ],
    );
  }

  DataColumn _column(String label, AppPalette palette) {
    return DataColumn(
      label: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: palette.textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
