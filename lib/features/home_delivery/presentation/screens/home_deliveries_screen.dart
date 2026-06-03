import 'package:courier_app/configuration/auth_service.dart';
import 'package:courier_app/core/theme/app_palette.dart';
import 'package:courier_app/features/home_delivery/bloc/home_delivery_bloc.dart';
import 'package:courier_app/features/home_delivery/data/model/home_delivery_model.dart';
import 'package:courier_app/features/home_delivery/data/repository/home_delivery_repository.dart';
import 'package:courier_app/features/home_delivery/presentation/widgets/assign_messenger_modal.dart';
import 'package:courier_app/features/home_delivery/presentation/widgets/home_delivery_table.dart';
import 'package:courier_app/features/pay_by_awb/presentation/screen/pay_by_awb_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class HomeDeliveriesScreen extends StatefulWidget {
  const HomeDeliveriesScreen({super.key});

  @override
  State<HomeDeliveriesScreen> createState() => _HomeDeliveriesScreenState();
}

class _HomeDeliveriesScreenState extends State<HomeDeliveriesScreen> {
  final _searchController = TextEditingController();
  final _authService = AuthService();

  int? _branchId;
  HomeDeliveryView _view = HomeDeliveryView.all;
  String? _statusFilter;
  List<HomeDeliveryModel> _filtered = [];

  static const _statusOptions = [
    'PENDING',
    'ASSIGNED',
    'DELIVERED',
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_applySearchFilter);
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
    _fetch();
  }

  void _fetch() {
    if (_branchId == null) return;
    context.read<HomeDeliveryBloc>().add(
          FetchHomeDeliveries(
            branchId: _branchId!,
            view: _view,
            status: _view == HomeDeliveryView.all ? _statusFilter : null,
          ),
        );
  }

  void _applySearchFilter() {
    final state = context.read<HomeDeliveryBloc>().state;
    if (state is FetchHomeDeliveriesSuccess) {
      _filterDeliveries(state.deliveries);
    }
  }

  void _filterDeliveries(List<HomeDeliveryModel> deliveries) {
    final term = _searchController.text.toLowerCase().trim();
    setState(() {
      _filtered = deliveries.where((d) {
        if (term.isEmpty) return true;
        return d.awb?.toLowerCase().contains(term) ?? false;
      }).toList();
    });
  }

  void _onViewChanged(HomeDeliveryView view) {
    setState(() {
      _view = view;
      if (view != HomeDeliveryView.all) {
        _statusFilter = null;
      }
    });
    _fetch();
  }

  void _openAssign(HomeDeliveryModel delivery) {
    if (_branchId == null || delivery.awb == null || delivery.awb!.isEmpty) {
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AssignMessengerModal(
        branchId: _branchId!,
        awb: delivery.awb!,
      ),
    );
  }

  void _handlePay(HomeDeliveryModel delivery) {
    if (delivery.awb == null || delivery.awb!.isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PayByAwbScreen(initialAwb: delivery.awb),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isDarkMode = context.isDarkMode;

    return Scaffold(
      backgroundColor: palette.appBarBackground,
      appBar: AppBar(
        backgroundColor: palette.appBarBackground,
        title: const Text('Home Deliveries'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _branchId != null ? _fetch : null,
          ),
        ],
      ),
      body: _branchId == null
          ? Center(
              child: Text(
                'Branch not found. Please sign in again.',
                style: TextStyle(color: palette.textPrimary),
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(color: palette.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Search by AWB',
                      hintStyle: TextStyle(color: palette.textSecondary),
                      prefixIcon: Icon(
                        Icons.search,
                        color: palette.textSecondary,
                      ),
                      filled: true,
                      fillColor: palette.surfaceMuted,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _viewChip('All', HomeDeliveryView.all, palette),
                      const SizedBox(width: 8),
                      _viewChip(
                        'Unassigned',
                        HomeDeliveryView.unassigned,
                        palette,
                      ),
                      const SizedBox(width: 8),
                      _viewChip(
                        'Overdue',
                        HomeDeliveryView.overdue,
                        palette,
                      ),
                    ],
                  ),
                ),
                if (_view == HomeDeliveryView.all) ...[
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: DropdownButtonFormField<String>(
                      value: _statusFilter,
                      decoration: InputDecoration(
                        labelText: 'Status filter',
                        filled: true,
                        fillColor: palette.surfaceMuted,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      dropdownColor: palette.surface,
                      items: [
                        const DropdownMenuItem<String>(
                          value: null,
                          child: Text('All statuses'),
                        ),
                        ..._statusOptions.map(
                          (s) => DropdownMenuItem(
                            value: s,
                            child: Text(s),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() => _statusFilter = value);
                        _fetch();
                      },
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Expanded(
                  child: BlocConsumer<HomeDeliveryBloc, HomeDeliveryState>(
                    listener: (context, state) {
                      if (state is FetchHomeDeliveriesSuccess) {
                        _filterDeliveries(state.deliveries);
                      }
                    },
                    builder: (context, state) {
                      if (state is FetchHomeDeliveriesLoading) {
                        return _buildShimmer(isDarkMode);
                      }
                      if (state is FetchHomeDeliveriesFailure) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              state.message,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: palette.textPrimary),
                            ),
                          ),
                        );
                      }
                      if (state is FetchHomeDeliveriesSuccess) {
                        if (_filtered.isEmpty) {
                          return Center(
                            child: Text(
                              'No home deliveries found',
                              style: TextStyle(color: palette.textSecondary),
                            ),
                          );
                        }
                        return HomeDeliveryTable(
                          deliveries: _filtered,
                          onAssign: _openAssign,
                          onPay: _handlePay,
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _viewChip(
    String label,
    HomeDeliveryView view,
    AppPalette palette,
  ) {
    final selected = _view == view;
    return Expanded(
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => _onViewChanged(view),
        selectedColor: palette.accent.withOpacity(0.2),
        checkmarkColor: palette.accent,
        labelStyle: TextStyle(
          color: selected ? palette.accent : palette.textPrimary,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildShimmer(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Shimmer.fromColors(
        baseColor: isDarkMode ? Colors.grey[850]! : Colors.grey[300]!,
        highlightColor: isDarkMode ? Colors.grey[700]! : Colors.grey[100]!,
        child: Container(
          height: 300,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
