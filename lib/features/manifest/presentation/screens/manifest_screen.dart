import 'package:courier_app/configuration/auth_service.dart';
import 'package:courier_app/core/theme/app_palette.dart';
import 'package:courier_app/features/manifest/bloc/manifest_bloc.dart';
import 'package:courier_app/features/manifest/data/model/manifest_model.dart';
import 'package:courier_app/features/manifest/presentation/screens/create_manifest_screen.dart';
import 'package:courier_app/features/manifest/presentation/widgets/manifest_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ManifestScreen extends StatefulWidget {
  const ManifestScreen({super.key});

  @override
  State<ManifestScreen> createState() => _ManifestScreenState();
}

class _ManifestScreenState extends State<ManifestScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _searchController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  int? _branchId;
  int _currentPage = 0;
  int _itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() => _currentPage = 0));
    WidgetsBinding.instance.addPostFrameCallback((_) => _initialize());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _initialize() async {
    final branch = await _authService.getBranch();
    if (!mounted) return;

    if (branch == null) {
      setState(() => _branchId = null);
      return;
    }

    setState(() => _branchId = int.tryParse(branch));
    _fetchManifests();
  }

  void _fetchManifests() {
    if (_branchId == null) return;
    final date = DateFormat('yyyy-MM-dd').format(_selectedDate);
    context.read<ManifestBloc>().add(
          FetchManifests(branchId: _branchId!, date: date),
        );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2015),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: context.palette.accent,
              onPrimary: Colors.white,
              surface: context.palette.surface,
              onSurface: context.palette.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _currentPage = 0;
      });
      _fetchManifests();
    }
  }

  List<ManifestModel> _filterManifests(List<ManifestModel> manifests) {
    final query = _searchController.text.toLowerCase().trim();
    if (query.isEmpty) return manifests;

    return manifests.where((m) {
      return m.manifestId.toLowerCase().contains(query) ||
          m.branch.name.toLowerCase().contains(query) ||
          m.receiverBranch.name.toLowerCase().contains(query) ||
          m.creatorLabel.toLowerCase().contains(query) ||
          m.createdBy.email.toLowerCase().contains(query);
    }).toList();
  }

  List<ManifestModel> _paginate(List<ManifestModel> manifests) {
    final start = _currentPage * _itemsPerPage;
    if (start >= manifests.length) return [];
    final end = (start + _itemsPerPage).clamp(0, manifests.length);
    return manifests.sublist(start, end);
  }

  Future<void> _openCreateScreen() async {
    if (_branchId == null) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CreateManifestScreen(
          branchId: _branchId!,
          selectedDate: _selectedDate,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final dateLabel = DateFormat('MM/dd/yyyy').format(_selectedDate);

    return Scaffold(
      backgroundColor: palette.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: palette.appBarBackground,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Manifest List',
          style: TextStyle(
            color: palette.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: palette.accent,
        onPressed: _branchId == null ? null : _openCreateScreen,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: _branchId == null
          ? Center(
              child: Text(
                'Branch not found. Please log in again.',
                style: TextStyle(color: palette.textPrimary),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    'Filter Options',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: palette.textPrimary,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: _selectDate,
                          borderRadius: BorderRadius.circular(12),
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Starting Date',
                              filled: true,
                              fillColor: palette.surface,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              suffixIcon: Icon(
                                Icons.calendar_today,
                                color: palette.textSecondary,
                              ),
                            ),
                            child: Text(
                              dateLabel,
                              style: TextStyle(color: palette.textPrimary),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: _fetchManifests,
                        icon: Icon(Icons.refresh, color: palette.accent),
                        label: Text(
                          'Refresh',
                          style: TextStyle(color: palette.accent),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          style: TextStyle(color: palette.textPrimary),
                          decoration: InputDecoration(
                            hintText: 'Search Manifests',
                            hintStyle: TextStyle(color: palette.textSecondary),
                            prefixIcon: Icon(
                              Icons.search,
                              color: palette.textSecondary,
                            ),
                            filled: true,
                            fillColor: palette.surface,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      DropdownButton<int>(
                        value: _itemsPerPage,
                        dropdownColor: palette.surface,
                        style: TextStyle(color: palette.textPrimary),
                        items: const [
                          DropdownMenuItem(value: 10, child: Text('10 / page')),
                          DropdownMenuItem(value: 25, child: Text('25 / page')),
                          DropdownMenuItem(value: 50, child: Text('50 / page')),
                        ],
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            _itemsPerPage = value;
                            _currentPage = 0;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: BlocBuilder<ManifestBloc, ManifestState>(
                    builder: (context, state) {
                      if (state is FetchManifestsLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state is FetchManifestsFailure) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Error: ${state.message}',
                                style: TextStyle(color: palette.textPrimary),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _fetchManifests,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      }

                      if (state is FetchManifestsSuccess) {
                        final filtered = _filterManifests(state.manifests);

                        if (filtered.isEmpty) {
                          return Center(
                            child: Text(
                              'No manifests found for selected date',
                              style: TextStyle(color: palette.textPrimary),
                            ),
                          );
                        }

                        final totalPages =
                            (filtered.length / _itemsPerPage).ceil();
                        if (_currentPage >= totalPages) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted) {
                              setState(() {
                                _currentPage =
                                    totalPages > 0 ? totalPages - 1 : 0;
                              });
                            }
                          });
                        }

                        final pageItems = _paginate(filtered);

                        return Column(
                          children: [
                            Expanded(
                              child: ManifestTable(manifests: pageItems),
                            ),
                            _buildPagination(
                              palette: palette,
                              totalPages: totalPages,
                              totalItems: filtered.length,
                            ),
                          ],
                        );
                      }

                      return Center(
                        child: Text(
                          'Select a date to load manifests',
                          style: TextStyle(color: palette.textSecondary),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildPagination({
    required AppPalette palette,
    required int totalPages,
    required int totalItems,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.first_page, color: palette.textPrimary),
            onPressed: _currentPage > 0
                ? () => setState(() => _currentPage = 0)
                : null,
          ),
          IconButton(
            icon: Icon(Icons.chevron_left, color: palette.textPrimary),
            onPressed: _currentPage > 0
                ? () => setState(() => _currentPage--)
                : null,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: palette.accent.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_currentPage + 1}',
              style: TextStyle(
                color: palette.accent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.chevron_right, color: palette.textPrimary),
            onPressed: _currentPage < totalPages - 1
                ? () => setState(() => _currentPage++)
                : null,
          ),
          IconButton(
            icon: Icon(Icons.last_page, color: palette.textPrimary),
            onPressed: _currentPage < totalPages - 1
                ? () => setState(() => _currentPage = totalPages - 1)
                : null,
          ),
          const SizedBox(width: 12),
          Text(
            'Total: $totalItems',
            style: TextStyle(color: palette.textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
