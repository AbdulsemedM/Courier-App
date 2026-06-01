import 'package:courier_app/features/branches/model/branches_model.dart';
import 'package:flutter/material.dart';
import 'package:courier_app/core/theme/app_palette.dart';

class BranchesWidget extends StatefulWidget {
  const BranchesWidget({super.key});

  @override
  State<BranchesWidget> createState() => _BranchesWidgetState();
}

class _BranchesWidgetState extends State<BranchesWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

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
          hintText: 'Search branches...',
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
            borderSide: BorderSide(color: Colors.blue, width: 2),
          ),
        ),
        style: TextStyle(
          color: context.palette.textPrimary,
        ),
      ),
    );
  }
}

class BranchesTable extends StatelessWidget {
  final List<BranchesModel> branches;

  const BranchesTable({
    super.key,
    required this.branches,
    // required this.onEdit,
    // required this.onDelete,
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
                'Branch Name',
                style: TextStyle(
                  color: context.palette.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Code',
                style: TextStyle(
                  color: context.palette.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Phone',
                style: TextStyle(
                  color: context.palette.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Balance',
                style: TextStyle(
                  color: context.palette.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Currency',
                style: TextStyle(
                  color: context.palette.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Type',
                style: TextStyle(
                  color: context.palette.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // DataColumn(
            //   label: Text(
            //     'Actions',
            //     style: TextStyle(
            //       color: context.palette.textPrimary,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),
          ],
          rows: branches.map((branch) {
            return DataRow(
              cells: [
                DataCell(Text(
                  branch.name,
                  style: TextStyle(
                    color: context.palette.textPrimary,
                  ),
                )),
                DataCell(Text(
                  branch.code,
                  style: TextStyle(
                    color: context.palette.textPrimary,
                  ),
                )),
                DataCell(Text(
                  branch.phone,
                  style: TextStyle(
                    color: context.palette.textPrimary,
                  ),
                )),
                DataCell(Text(
                  branch.balance.toStringAsFixed(2),
                  style: TextStyle(
                    color: context.palette.textPrimary,
                  ),
                )),
                DataCell(Text(
                  branch.currency,
                  style: TextStyle(
                    color: context.palette.textPrimary,
                  ),
                )),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: branch.isAgent
                          ? (isDarkMode ? Colors.blue[900] : Colors.blue[100])
                          : (isDarkMode ? Colors.green[900] : Colors.green[100]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      branch.isAgent ? 'Agent' : 'Branch',
                      style: TextStyle(
                        color: branch.isAgent
                            ? (isDarkMode ? Colors.blue[100] : Colors.blue[900])
                            : (isDarkMode ? Colors.green[100] : Colors.green[900]),
                      ),
                    ),
                  ),
                ),
                // DataCell(Row(
                //   mainAxisSize: MainAxisSize.min,
                //   children: [
                //     IconButton(
                //       icon: const Icon(Icons.edit, color: Colors.blue),
                //       onPressed: () => onEdit(branch),
                //     ),
                //     IconButton(
                //       icon: const Icon(Icons.delete, color: Colors.red),
                //       onPressed: () => onDelete(branch),
                //     ),
                //   ],
                // )
                // ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

