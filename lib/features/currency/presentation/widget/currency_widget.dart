import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../model/currency_model.dart';

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
          hintText: 'Search currencies...',
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

class CurrencyTable extends StatelessWidget {
  final List<CurrencyModel> currencies;
  final Function(CurrencyModel)? onEdit;
  final Function(CurrencyModel)? onDelete;

  const CurrencyTable({
    super.key,
    required this.currencies,
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
                'Code',
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
                'Country',
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
          rows: currencies.map((currency) {
            return DataRow(
              cells: [
                DataCell(Text(
                  currency.code,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                )),
                DataCell(
                  Container(
                    constraints: const BoxConstraints(maxWidth: 200),
                    child: Tooltip(
                      message: currency.description,
                      child: Text(
                        currency.description,
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
                  currency.id.toString(),
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                )),
                DataCell(Text(
                  DateFormat('MMM-dd-yyyy')
                      .format(DateTime.parse(currency.createdAt)),
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
                //           onPressed: () => onEdit!(currency),
                //         ),
                //       if (onDelete != null)
                //         IconButton(
                //           icon: Icon(
                //             Icons.delete,
                //             color: isDarkMode ? Colors.red[300] : Colors.red,
                //           ),
                //           onPressed: () => onDelete!(currency),
                //         ),
                //     ],
                //   )
                // ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
