import 'package:courier_app/features/shipment_types/models/shipment_types_models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search shipment types...',
          prefixIcon: Icon(
            Icons.search,
            color: isDarkMode ? Colors.grey : Colors.grey[600],
          ),
          filled: true,
          fillColor: isDarkMode ? Colors.white10 : Colors.grey[100],
          hintStyle: TextStyle(
            color: isDarkMode ? Colors.grey : Colors.grey[600],
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
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}

class ShipmentTypesTable extends StatelessWidget {
  final List<ShipmentTypesModels> shipmentTypes;
  final Function(ShipmentTypesModels)? onEdit;
  final Function(ShipmentTypesModels)? onDelete;

  const ShipmentTypesTable({
    super.key,
    required this.shipmentTypes,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          headingRowColor: MaterialStateProperty.all(
            isDarkMode ? Colors.grey[800] : Colors.grey[200],
          ),
          columns: [
            DataColumn(
              label: Text(
                'Type',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Description',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Created At',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (onEdit != null || onDelete != null)
              DataColumn(
                label: Text(
                  'Actions',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
          rows: shipmentTypes.map((type) {
            return DataRow(
              cells: [
                DataCell(Text(
                  type.type,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                )),
                DataCell(
                  Container(
                    constraints: const BoxConstraints(maxWidth: 200),
                    child: Tooltip(
                      message: type.description,
                      child: Text(
                        type.description,
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ),
                ),
                DataCell(Text(
                  DateFormat('MMM-dd-yyyy')
                      .format(DateTime.parse(type.createdAt)),
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
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
                          onPressed: () => onEdit!(type),
                        ),
                      if (onDelete != null)
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: isDarkMode ? Colors.red[300] : Colors.red,
                          ),
                          onPressed: () => onDelete!(type),
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
