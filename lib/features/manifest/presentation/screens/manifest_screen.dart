import 'dart:async';

import 'package:courier_app/app/utils/dialog_utils.dart';
import 'package:courier_app/configuration/auth_service.dart';
import 'package:courier_app/core/services/scanner_service.dart';
import 'package:courier_app/core/theme/app_palette.dart';
import 'package:courier_app/features/branches/bloc/branches_bloc.dart';
import 'package:courier_app/features/branches/model/branches_model.dart';
import 'package:courier_app/features/manifest/bloc/manifest_bloc.dart';
import 'package:courier_app/features/manifest/data/model/manifest_model.dart';
import 'package:courier_app/features/manifest/presentation/screens/create_manifest_screen.dart';
import 'package:courier_app/features/manifest/presentation/widgets/manifest_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

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
  Map<int, BranchesModel> _branchLookup = const {};

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
    context.read<BranchesBloc>().add(FetchBranches());
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

  DateTime _manifestSortKey(ManifestModel manifest) {
    return DateTime.tryParse(manifest.displayDateTime) ??
        DateTime.fromMillisecondsSinceEpoch(0);
  }

  List<ManifestModel> _filterManifests(List<ManifestModel> manifests) {
    final query = _searchController.text.toLowerCase().trim();

    final filtered = query.isEmpty
        ? List<ManifestModel>.from(manifests)
        : manifests.where((m) {
            return m.manifestId.toLowerCase().contains(query) ||
                m.branch.name.toLowerCase().contains(query) ||
                m.receiverBranch.name.toLowerCase().contains(query) ||
                m.creatorLabel.toLowerCase().contains(query) ||
                m.createdBy.email.toLowerCase().contains(query) ||
                m.awbList.any((awb) => awb.toLowerCase().contains(query));
          }).toList();

    filtered.sort((a, b) => _manifestSortKey(b).compareTo(_manifestSortKey(a)));
    return filtered;
  }

  List<ManifestModel> _paginate(List<ManifestModel> manifests) {
    final start = _currentPage * _itemsPerPage;
    if (start >= manifests.length) return [];
    final end = (start + _itemsPerPage).clamp(0, manifests.length);
    return manifests.sublist(start, end);
  }

  void _openManageAwbs(ManifestModel manifest) {
    if (_branchId == null) return;
    final date = DateFormat('yyyy-MM-dd').format(_selectedDate);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _ManageManifestAwbsSheet(
        manifest: manifest,
        branchId: _branchId!,
        date: date,
      ),
    );
  }

  Future<void> _downloadManifest(ManifestModel manifest) async {
    final url = manifest.downloadUrl;
    if (url == null || url.isEmpty) {
      displaySnack(context, 'Download link not available', Colors.orange);
      return;
    }

    final uri = Uri.tryParse(url);
    if (uri == null) {
      displaySnack(context, 'Invalid download link', Colors.red);
      return;
    }

    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && mounted) {
      displaySnack(context, 'Unable to open download link', Colors.red);
    }
  }

  void _showManifestQr(ManifestModel manifest) {
    final url = manifest.barcodeUrl;
    if (url == null || url.isEmpty) {
      displaySnack(context, 'QR code not available', Colors.orange);
      return;
    }

    final palette = context.palette;
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: palette.surface,
          title: Text(
            'Manifest #${manifest.id}',
            style: TextStyle(color: palette.textPrimary),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  url,
                  height: 200,
                  width: 200,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Text(
                    'Failed to load QR code',
                    style: TextStyle(color: palette.textSecondary),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('Close', style: TextStyle(color: palette.accent)),
            ),
          ],
        );
      },
    );
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

    return MultiBlocListener(
      listeners: [
        BlocListener<ManifestBloc, ManifestState>(
          listenWhen: (prev, curr) =>
              curr is ManifestAwbActionSuccess ||
              curr is ManifestAwbActionFailure,
          listener: (context, state) {
            if (state is ManifestAwbActionSuccess) {
              displaySnack(context, state.message, Colors.green);
            } else if (state is ManifestAwbActionFailure) {
              displaySnack(context, state.message, Colors.red);
            }
          },
        ),
        BlocListener<BranchesBloc, BranchesState>(
          listenWhen: (prev, curr) => curr is FetchBranchesLoaded,
          listener: (context, state) {
            if (state is FetchBranchesLoaded) {
              setState(() {
                _branchLookup = {
                  for (final branch in state.branches) branch.id: branch,
                };
              });
            }
          },
        ),
      ],
      child: Scaffold(
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
                              child: ManifestTable(
                                manifests: pageItems,
                                branchLookup: _branchLookup,
                                onManageAwbs: _openManageAwbs,
                                onDownload: _downloadManifest,
                                onShowQr: _showManifestQr,
                              ),
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

class _ManageManifestAwbsSheet extends StatefulWidget {
  final ManifestModel manifest;
  final int branchId;
  final String date;

  const _ManageManifestAwbsSheet({
    required this.manifest,
    required this.branchId,
    required this.date,
  });

  @override
  State<_ManageManifestAwbsSheet> createState() =>
      _ManageManifestAwbsSheetState();
}

class _ManageManifestAwbsSheetState extends State<_ManageManifestAwbsSheet> {
  final AuthService _authService = AuthService();
  final TextEditingController _addController = TextEditingController();
  final FocusNode _awbFocusNode = FocusNode();
  final ScannerService _scannerService = ScannerService();
  StreamSubscription<String>? _barcodeStreamSubscription;
  ScannerType? _scannerType;
  bool _isHardwareScanner = false;
  bool _handlingHidScan = false;
  final List<String> _incomingAwbs = [];
  List<String> _loadedAwbs = [];
  bool _loadingAwbs = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadedAwbs = List<String>.from(widget.manifest.awbList);
    _loadExistingAwbs();
    _initializeScanner();
  }

  Future<void> _loadExistingAwbs() async {
    final awbs =
        await context.read<ManifestBloc>().resolveManifestAwbs(widget.manifest);
    if (!mounted) return;
    setState(() {
      _loadedAwbs = awbs;
      _loadingAwbs = false;
    });
  }

  List<String> _currentAwbs(ManifestModel manifest) {
    if (_loadedAwbs.isNotEmpty) return _loadedAwbs;
    return manifest.awbList;
  }

  @override
  void dispose() {
    _addController.removeListener(_onAwbControllerChanged);
    _addController.dispose();
    _awbFocusNode.dispose();
    _barcodeStreamSubscription?.cancel();
    _scannerService.release();
    super.dispose();
  }

  Future<void> _initializeScanner() async {
    try {
      _scannerType = await _scannerService.detectScannerType();

      if (!mounted) return;
      setState(() {
        _isHardwareScanner = _scannerType == ScannerType.sunmi ||
            _scannerType == ScannerType.urovo;
      });

      if (_scannerType == ScannerType.sunmi ||
          _scannerType == ScannerType.urovo) {
        _addController.addListener(_onAwbControllerChanged);

        final stream = _scannerService.initializeScanner();
        _barcodeStreamSubscription = stream.listen(
          (barcode) {
            if (barcode.isEmpty || !mounted) return;
            final state = context.read<ManifestBloc>().state;
            final currentAwbs = _currentAwbs(_manifestFromState(state));
            _queueIncomingAwb(barcode, currentAwbs);
          },
          onError: (error) {
            print('Edit manifest scanner error: $error');
          },
          cancelOnError: false,
        );

        await Future.delayed(const Duration(milliseconds: 100));

        if (_scannerType == ScannerType.sunmi) {
          await _scannerService.startScanner();
        } else if (_scannerType == ScannerType.urovo) {
          await _scannerService.startUrovoScanner();
        }

        if (mounted) {
          _awbFocusNode.requestFocus();
        }
      }
    } catch (e) {
      print('Error initializing edit manifest scanner: $e');
      if (mounted) {
        setState(() {
          _scannerType = ScannerType.camera;
          _isHardwareScanner = false;
        });
      }
    }
  }

  void _onAwbControllerChanged() {
    if (_handlingHidScan ||
        (_scannerType != ScannerType.sunmi &&
            _scannerType != ScannerType.urovo)) {
      return;
    }

    final value = _addController.text;
    if (!value.contains('\n') && !value.contains('\r')) return;

    _handlingHidScan = true;
    final cleaned = value.replaceAll(RegExp(r'[\r\n]+'), '').trim();
    _addController.value = TextEditingValue(
      text: '',
      selection: const TextSelection.collapsed(offset: 0),
    );
    _handlingHidScan = false;

    if (cleaned.isNotEmpty && mounted) {
      final currentAwbs = _currentAwbs(
        _manifestFromState(context.read<ManifestBloc>().state),
      );
      _queueIncomingAwb(cleaned, currentAwbs);
    }
  }

  ManifestModel _manifestFromState(ManifestState state) {
    if (state is FetchManifestsSuccess) {
      for (final manifest in state.manifests) {
        if (manifest.id == widget.manifest.id) return manifest;
      }
    }
    return widget.manifest;
  }

  bool _isDuplicateAwb(String awb, List<String> currentAwbs) {
    return currentAwbs.contains(awb) || _incomingAwbs.contains(awb);
  }

  void _queueIncomingAwb(String raw, List<String> currentAwbs) {
    final awb = raw.replaceAll(' ', '').toUpperCase();
    if (awb.isEmpty) return;

    if (_isDuplicateAwb(awb, currentAwbs)) {
      displaySnack(
        context,
        'AWB already on manifest or in incoming list',
        Colors.orange,
      );
      return;
    }

    setState(() => _incomingAwbs.add(awb));
  }

  void _addAwbsFromField(List<String> currentAwbs) {
    final values = _addController.text
        .split(',')
        .map((s) => s.trim().toUpperCase())
        .where((s) => s.isNotEmpty)
        .toList();

    if (values.isEmpty) {
      displaySnack(context, 'Enter an AWB number', Colors.orange);
      return;
    }

    var added = 0;
    for (final awb in values) {
      if (!_isDuplicateAwb(awb, currentAwbs)) {
        _incomingAwbs.add(awb);
        added++;
      }
    }

    setState(() {});
    _addController.clear();

    if (added == 0) {
      displaySnack(
        context,
        'AWB already on manifest or in incoming list',
        Colors.orange,
      );
    }
  }

  void _removeIncomingAwb(String awb) {
    setState(() => _incomingAwbs.remove(awb));
  }

  Future<void> _editManifest(List<String> currentAwbs) async {
    if (_incomingAwbs.isEmpty) {
      displaySnack(
        context,
        'Add at least one new AWB before updating the manifest',
        Colors.orange,
      );
      return;
    }

    final newAwbs = _incomingAwbs
        .where((awb) => !currentAwbs.contains(awb))
        .toList();

    if (newAwbs.isEmpty) {
      displaySnack(context, 'No new AWBs to add', Colors.orange);
      return;
    }

    final allAwbs = <String>[
      ...currentAwbs,
      ...newAwbs.where((awb) => !currentAwbs.contains(awb)),
    ];

    final userIdRaw = await _authService.getUserId();
    final userId = int.tryParse(userIdRaw ?? '');
    if (!mounted) return;
    if (userId == null) {
      displaySnack(context, 'User not found. Please log in again.', Colors.red);
      return;
    }

    final fileType = widget.manifest.fileType.isNotEmpty
        ? widget.manifest.fileType
        : 'EXCEL';

    setState(() => _isSubmitting = true);
    context.read<ManifestBloc>().add(
          UpdateManifest(
            manifestId: widget.manifest.id,
            awbs: allAwbs,
            fileType: fileType,
            userId: userId,
            branchId: widget.branchId,
            date: widget.date,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return BlocListener<ManifestBloc, ManifestState>(
      listenWhen: (previous, current) =>
          current is ManifestAwbActionSuccess ||
          current is ManifestAwbActionFailure,
      listener: (context, state) {
        if (state is ManifestAwbActionSuccess) {
          setState(() {
            _isSubmitting = false;
            _loadedAwbs = [
              ..._loadedAwbs,
              ..._incomingAwbs.where((awb) => !_loadedAwbs.contains(awb)),
            ];
            _incomingAwbs.clear();
            _addController.clear();
          });
        } else if (state is ManifestAwbActionFailure) {
          setState(() => _isSubmitting = false);
        }
      },
      child: BlocBuilder<ManifestBloc, ManifestState>(
        builder: (context, state) {
          final manifest = _manifestFromState(state);
          final currentAwbs = _currentAwbs(manifest);

          return Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            decoration: BoxDecoration(
              color: palette.surface,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Row(
                    children: [
                      Icon(Icons.edit_outlined,
                          color: palette.accent, size: 22),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Edit Manifest',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: palette.textPrimary,
                              ),
                            ),
                            Text(
                              widget.manifest.manifestId.isNotEmpty
                                  ? widget.manifest.manifestId
                                  : '#${widget.manifest.id}',
                              style: TextStyle(
                                fontSize: 13,
                                color: palette.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (_isHardwareScanner)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                    child: Row(
                      children: [
                        Icon(
                          _scannerType == ScannerType.sunmi
                              ? Icons.qr_code_scanner
                              : Icons.scanner,
                          size: 18,
                          color: palette.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Scanner ready — scan to queue new AWBs',
                            style: TextStyle(
                              color: palette.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                Flexible(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      20,
                      12,
                      20,
                      20 + MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Current AWBs',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: palette.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (_loadingAwbs)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Center(
                              child: SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                          )
                        else if (currentAwbs.isEmpty)
                          Text(
                            'No AWBs on this manifest yet',
                            style: TextStyle(color: palette.textSecondary),
                          )
                        else
                          ...currentAwbs.map(
                            (awb) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                awb,
                                style: TextStyle(color: palette.textPrimary),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() => _loadedAwbs.remove(awb));
                                  context.read<ManifestBloc>().add(
                                        RemoveAwbFromManifest(
                                          manifestId: manifest.id,
                                          awb: awb,
                                          branchId: widget.branchId,
                                          date: widget.date,
                                        ),
                                      );
                                },
                              ),
                            ),
                          ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Text(
                              'New incoming AWBs',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: palette.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: palette.accent.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${_incomingAwbs.length}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: palette.accent,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (_incomingAwbs.isEmpty)
                          Text(
                            'Scan or enter AWBs below, then tap Add AWB',
                            style: TextStyle(
                              color: palette.textSecondary,
                              fontSize: 13,
                            ),
                          )
                        else
                          ..._incomingAwbs.map(
                            (awb) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(
                                Icons.fiber_new_rounded,
                                color: palette.accent,
                                size: 20,
                              ),
                              title: Text(
                                awb,
                                style: TextStyle(
                                  color: palette.textPrimary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                onPressed: () => _removeIncomingAwb(awb),
                              ),
                            ),
                          ),
                        const SizedBox(height: 16),
                        Text(
                          'Add AWB',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: palette.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _addController,
                          focusNode: _awbFocusNode,
                          textCapitalization: TextCapitalization.characters,
                          style: TextStyle(color: palette.textPrimary),
                          decoration: InputDecoration(
                            hintText: _isHardwareScanner
                                ? 'Scan or type AWB (comma-separated)'
                                : 'Enter AWB (comma-separated)',
                            hintStyle: TextStyle(color: palette.textSecondary),
                            filled: true,
                            fillColor: palette.surfaceMuted,
                            suffixIcon: _isHardwareScanner
                                ? Icon(
                                    _scannerType == ScannerType.sunmi
                                        ? Icons.qr_code_scanner
                                        : Icons.scanner,
                                    color: palette.textSecondary,
                                  )
                                : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onSubmitted: (_) => _addAwbsFromField(currentAwbs),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _isSubmitting
                                    ? null
                                    : () => _addAwbsFromField(currentAwbs),
                                icon: const Icon(Icons.add),
                                label: const Text('Add AWB'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: palette.accent,
                                  side: BorderSide(color: palette.accent),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _isSubmitting
                                    ? null
                                    : () => _editManifest(currentAwbs),
                                icon: _isSubmitting
                                    ? const SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Icon(Icons.edit_outlined),
                                label: const Text('Edit Manifest'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: palette.accent,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
