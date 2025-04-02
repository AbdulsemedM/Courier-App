import 'package:courier_app/features/branches/model/branches_model.dart';
import 'package:flutter/material.dart';

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
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search branches...',
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
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
      ),
    );
  }
}

class BranchesTable extends StatelessWidget {
  final List<BranchesModel> branches;
  final Function(BranchesModel) onEdit;
  final Function(BranchesModel) onDelete;

  const BranchesTable({
    super.key,
    required this.branches,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
          columns: const [
            DataColumn(label: Text('Branch Name')),
            DataColumn(label: Text('Code')),
            DataColumn(label: Text('Phone')),
            DataColumn(label: Text('Balance')),
            DataColumn(label: Text('Currency')),
            DataColumn(label: Text('Type')),
            DataColumn(label: Text('Actions')),
          ],
          rows: branches.map((branch) {
            return DataRow(
              cells: [
                DataCell(Text(branch.name)),
                DataCell(Text(branch.code)),
                DataCell(Text(branch.phone)),
                DataCell(Text(branch.balance.toStringAsFixed(2))),
                DataCell(Text(branch.currency)),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          branch.isAgent ? Colors.blue[100] : Colors.green[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      branch.isAgent ? 'Agent' : 'Branch',
                      style: TextStyle(
                        color: branch.isAgent
                            ? Colors.blue[900]
                            : Colors.green[900],
                      ),
                    ),
                  ),
                ),
                DataCell(Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => onEdit(branch),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => onDelete(branch),
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
