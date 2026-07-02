import 'package:courier_app/configuration/auth_service.dart';
import 'package:courier_app/core/theme/app_palette.dart';
import 'package:courier_app/features/shelves_management/data/data_provider/shelves_data_provider.dart';
import 'package:courier_app/features/shelves_management/data/repository/shelves_repository.dart';
import 'package:courier_app/features/shelves_management/model/shelves_mdoel.dart';
import 'package:flutter/material.dart';

class ShelfPicker extends StatefulWidget {
  final int? selectedShelfId;
  final ValueChanged<int?> onChanged;

  const ShelfPicker({
    super.key,
    required this.selectedShelfId,
    required this.onChanged,
  });

  @override
  State<ShelfPicker> createState() => _ShelfPickerState();
}

class _ShelfPickerState extends State<ShelfPicker> {
  final _searchController = TextEditingController();
  final _repository = ShelvesRepository(
    shelvesDataProvider: ShelvesDataProvider(),
  );

  List<ShelvesModel> _shelves = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadShelves();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadShelves() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final branchRaw = await AuthService().getBranch();
      final branchId = int.tryParse(branchRaw ?? '');
      if (branchId == null) {
        throw 'No branch assigned to your account';
      }

      final shelves = await _repository.fetchShelvesByBranch(branchId);
      if (!mounted) return;
      setState(() {
        _shelves = shelves;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  String _label(ShelvesModel shelf) {
    final bin = shelf.binCode ?? '';
    final desc = shelf.description ?? '';
    if (bin.isNotEmpty && desc.isNotEmpty) return '$bin — $desc';
    if (bin.isNotEmpty) return bin;
    return desc;
  }

  List<ShelvesModel> get _filteredShelves {
    final query = _searchController.text.toLowerCase().trim();
    if (query.isEmpty) return _shelves;

    return _shelves.where((shelf) {
      final bin = shelf.binCode?.toLowerCase() ?? '';
      final code = shelf.shelfCode?.toLowerCase() ?? '';
      final desc = shelf.description?.toLowerCase() ?? '';
      return bin.contains(query) ||
          code.contains(query) ||
          desc.contains(query);
    }).toList();
  }

  ShelvesModel? get _selectedShelf {
    if (widget.selectedShelfId == null) return null;
    for (final shelf in _shelves) {
      if (shelf.id == widget.selectedShelfId) return shelf;
    }
    return null;
  }

  void _showPickerSheet() {
    final palette = context.palette;
    final searchController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final query = searchController.text.toLowerCase().trim();
            final filtered = _shelves.where((shelf) {
              if (query.isEmpty) return true;
              final bin = shelf.binCode?.toLowerCase() ?? '';
              final code = shelf.shelfCode?.toLowerCase() ?? '';
              final desc = shelf.description?.toLowerCase() ?? '';
              return bin.contains(query) ||
                  code.contains(query) ||
                  desc.contains(query);
            }).toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.65,
              decoration: BoxDecoration(
                color: palette.surface,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: palette.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                    child: Text(
                      'Select shelf',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: palette.textPrimary,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: searchController,
                      onChanged: (_) => setModalState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Search bin code or description',
                        prefixIcon:
                            Icon(Icons.search, color: palette.accent, size: 22),
                        filled: true,
                        fillColor: palette.surfaceMuted,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: filtered.isEmpty
                        ? Center(
                            child: Text(
                              'No shelves found',
                              style: TextStyle(color: palette.textSecondary),
                            ),
                          )
                        : ListView.builder(
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final shelf = filtered[index];
                              final isSelected =
                                  shelf.id == widget.selectedShelfId;
                              return ListTile(
                                title: Text(
                                  _label(shelf),
                                  style: TextStyle(
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: palette.textPrimary,
                                  ),
                                ),
                                subtitle: shelf.shelfCode != null
                                    ? Text(
                                        shelf.shelfCode!,
                                        style: TextStyle(
                                          color: palette.textSecondary,
                                          fontSize: 12,
                                        ),
                                      )
                                    : null,
                                trailing: isSelected
                                    ? Icon(Icons.check, color: palette.accent)
                                    : null,
                                onTap: () {
                                  widget.onChanged(shelf.id);
                                  Navigator.pop(context);
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).whenComplete(searchController.dispose);
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isDarkMode = context.isDarkMode;

    if (_loading) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: palette.accent,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Loading shelves...',
              style: TextStyle(color: palette.textSecondary, fontSize: 14),
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _error!,
                style: TextStyle(
                  color: isDarkMode ? Colors.red[300] : Colors.red[700],
                  fontSize: 13,
                ),
              ),
            ),
            TextButton(
              onPressed: _loadShelves,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_shelves.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(
          'No shelves available for your branch',
          style: TextStyle(color: palette.textSecondary, fontSize: 13),
        ),
      );
    }

    final selected = _selectedShelf;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Shelf',
          style: TextStyle(
            color: palette.textSecondary,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _showPickerSheet,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: palette.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: palette.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selected != null ? _label(selected) : 'Select shelf',
                    style: TextStyle(
                      color: selected != null
                          ? palette.textPrimary
                          : palette.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(Icons.arrow_drop_down, color: palette.textSecondary),
              ],
            ),
          ),
        ),
        if (_filteredShelves.isNotEmpty && _searchController.text.isNotEmpty)
          const SizedBox.shrink(),
      ],
    );
  }
}
