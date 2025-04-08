import 'package:courier_app/features/transport_modes/model/transport_modes_model.dart';
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
          hintText: 'Search transport modes...',
          prefixIcon: Icon(
            Icons.search,
            color: isDarkMode ? Colors.grey : Colors.grey[600],
          ),
          filled: true,
          fillColor: isDarkMode ? Colors.white10 : Colors.grey[100],
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

class TransportModesTable extends StatelessWidget {
  final List<TransportModesModel> transportModes;
  final Function(TransportModesModel)? onEdit;
  final Function(TransportModesModel)? onDelete;

  const TransportModesTable({
    super.key,
    required this.transportModes,
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
          columnSpacing: 24,
          columns: [
            DataColumn(
              label: Text(
                'Transport Mode',
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
            // if (onEdit != null || onDelete != null)
            //   DataColumn(
            //     label: Text(
            //       'Actions',
            //       style: TextStyle(
            //         color: isDarkMode ? Colors.white : Colors.black,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //   ),
          ],
          rows: transportModes.map((mode) {
            return DataRow(
              cells: [
                DataCell(Text(
                  mode.mode,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                )),
                DataCell(
                  Container(
                    constraints: const BoxConstraints(maxWidth: 200),
                    child: Tooltip(
                      message: mode.description,
                      child: Text(
                        mode.description,
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
                  mode.createdAt != null
                      ? DateFormat('MMM-dd-yyyy')
                          .format(DateTime.parse(mode.createdAt!))
                      : '',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                )),
                // if (onEdit != null || onDelete != null)
                //   DataCell(Row(
                //     mainAxisSize: MainAxisSize.min,
                //     children: [
                //       if (onEdit != null)
                //         IconButton(
                //           icon: Icon(
                //             Icons.edit,
                //             color: isDarkMode ? Colors.blue[300] : Colors.blue,
                //           ),
                //           onPressed: () => onEdit!(mode),
                //         ),
                //       if (onDelete != null)
                //         IconButton(
                //           icon: Icon(
                //             Icons.delete,
                //             color: isDarkMode ? Colors.red[300] : Colors.red,
                //           ),
                //           onPressed: () => onDelete!(mode),
                //         ),
                //     ],
                //   )),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
