import 'package:courier_app/features/services_mode/models/services_mode_models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:courier_app/core/theme/app_palette.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.isDarkMode;

    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search services mode...',
          prefixIcon: Icon(
            Icons.search,
            color: context.palette.textSecondary,
          ),
          filled: true,
          fillColor: context.palette.surfaceMuted,
          hintStyle: TextStyle(
            color: context.palette.textSecondary,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
        ),
        style: TextStyle(
          color: context.palette.textPrimary,
        ),
      ),
    );
  }
}

class ServicesModeTable extends StatelessWidget {
  final List<ServicesModeModels> servicesModes;
  final Function(ServicesModeModels)? onEdit;
  final Function(ServicesModeModels)? onDelete;

  const ServicesModeTable({
    super.key,
    required this.servicesModes,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.isDarkMode;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          columnSpacing: 24,
          columns: [
            DataColumn(
              label: Text(
                'Type',
                style: TextStyle(
                  color: context.palette.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Description',
                style: TextStyle(
                  color: context.palette.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Created At',
                style: TextStyle(
                  color: context.palette.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (onEdit != null || onDelete != null)
              DataColumn(
                label: Text(
                  'Actions',
                  style: TextStyle(
                    color: context.palette.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
          rows: servicesModes.map((service) {
            return DataRow(
              cells: [
                DataCell(Text(
                  service.code,
                  style: TextStyle(
                    color: context.palette.textPrimary,
                  ),
                )),
                DataCell(
                  Container(
                    constraints: const BoxConstraints(maxWidth: 300),
                    child: Tooltip(
                      message: service.description,
                      child: Text(
                        service.description,
                        style: TextStyle(
                          color: context.palette.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ),
                ),
                DataCell(Text(
                  DateFormat('MMM-dd-yyyy').format(
                      DateTime.parse(service.createdAt)),
                  style: TextStyle(
                    color: context.palette.textPrimary,
                  ),
                )),
                if (onEdit != null || onDelete != null)
                  DataCell(Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (onEdit != null)
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: isDarkMode ? Colors.blue[300] : Colors.blue,
                          ),
                          onPressed: () => onEdit!(service),
                        ),
                      if (onDelete != null)
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: isDarkMode ? Colors.red[300] : Colors.red,
                          ),
                          onPressed: () => onDelete!(service),
                        ),
                    ],
                  )),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
