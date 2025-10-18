import 'package:flutter/material.dart';
import 'package:courier_app/features/shelves_management/model/shelves_mdoel.dart';
import 'package:courier_app/features/branches/model/branches_model.dart';

class ShelvesTable extends StatelessWidget {
  final List<ShelvesModel> shelves;
  final int? selectedBranchId;
  final Function(ShelvesModel) onEdit;

  const ShelvesTable({
    Key? key,
    required this.shelves,
    required this.onEdit,
    this.selectedBranchId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filteredShelves = selectedBranchId != null
        ? shelves.where((shelf) => shelf.branchId == selectedBranchId).toList()
        : shelves;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Shelf Code')),
          DataColumn(label: Text('Bin Code')),
          DataColumn(label: Text('Branch')),
          DataColumn(label: Text('Description')),
          DataColumn(label: Text('Actions')),
        ],
        rows: filteredShelves.map((shelf) {
          return DataRow(cells: [
            DataCell(Text(shelf.shelfCode ?? '')),
            DataCell(Text(shelf.binCode ?? '')),
            DataCell(Text(shelf.branchName ?? '')),
            DataCell(Text(shelf.description ?? '')),
            DataCell(IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => onEdit(shelf),
            )),
          ]);
        }).toList(),
      ),
    );
  }
}

class BranchFilter extends StatelessWidget {
  final List<BranchesModel> branches;
  final int? selectedBranchId;
  final Function(int?) onBranchSelected;

  const BranchFilter({
    Key? key,
    required this.branches,
    required this.selectedBranchId,
    required this.onBranchSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButton<int?>(
        value: selectedBranchId,
        hint: const Text('Filter by Branch'),
        isExpanded: true,
        items: [
          const DropdownMenuItem<int?>(
            value: null,
            child: Text('All Branches'),
          ),
          ...branches.map((branch) {
            return DropdownMenuItem<int?>(
              value: branch.id,
              child: Text(branch.name ?? ''),
            );
          }),
        ],
        onChanged: onBranchSelected,
      ),
    );
  }
}
