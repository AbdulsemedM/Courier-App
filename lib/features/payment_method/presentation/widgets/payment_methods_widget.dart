import 'package:courier_app/features/payment_method/models/payemnt_methods_model.dart';
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
          hintText: 'Search payment methods...',
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

class PaymentMethodsTable extends StatelessWidget {
  final List<PaymentMethodModel> paymentMethods;
  final Function(PaymentMethodModel)? onEdit;
  final Function(PaymentMethodModel)? onDelete;

  const PaymentMethodsTable({
    super.key,
    required this.paymentMethods,
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
          headingRowColor: MaterialStateProperty.all(
            context.palette.border,
          ),
          columns: [
            DataColumn(
              label: Text(
                'Method',
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
          rows: paymentMethods.map((method) {
            return DataRow(
              cells: [
                DataCell(Text(
                  method.method ?? '',
                  style: TextStyle(
                    color: context.palette.textPrimary,
                  ),
                )),
                DataCell(Text(
                  method.description ?? '',
                  style: TextStyle(
                    color: context.palette.textPrimary,
                  ),
                )),
                DataCell(Text(
                  // ignore: unnecessary_null_comparison
                  method.createdAt != null
                      ? DateFormat('MMM-dd-yyyy')
                          .format(DateTime.parse(method.createdAt ?? ''))
                      : '',
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
                          onPressed: () => onEdit!(method),
                        ),
                      if (onDelete != null)
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: isDarkMode ? Colors.red[300] : Colors.red,
                          ),
                          onPressed: () => onDelete!(method),
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
