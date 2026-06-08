import 'package:courier_app/core/theme/app_palette.dart';
import 'package:courier_app/features/branches/model/country_model.dart';
import 'package:courier_app/features/countries/data/data_provider/countries_data_provider.dart';
import 'package:courier_app/features/countries/data/repository/countries_repository.dart';
import 'package:courier_app/features/public_tracking/bloc/public_tracking_bloc.dart';
import 'package:courier_app/features/public_tracking/presentation/widgets/phone_country_selector.dart';
import 'package:courier_app/features/public_tracking/presentation/widgets/public_tracking_widgets.dart';
import 'package:courier_app/features/public_tracking/utils/country_defaults.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

enum _SearchMode { awb, phone }

class PublicTrackingScreen extends StatefulWidget {
  const PublicTrackingScreen({super.key});

  @override
  State<PublicTrackingScreen> createState() => _PublicTrackingScreenState();
}

class _PublicTrackingScreenState extends State<PublicTrackingScreen> {
  final _awbController = TextEditingController();
  final _phoneController = TextEditingController();
  _SearchMode _searchMode = _SearchMode.awb;
  List<CountryModel> _countries = CountryDefaults.fallbackCountries();
  CountryModel _selectedCountry = CountryDefaults.defaultCountry();
  String? _phoneError;
  String? _awbError;
  bool _loadingCountries = true;

  @override
  void initState() {
    super.initState();
    _loadCountries();
  }

  @override
  void dispose() {
    _awbController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadCountries() async {
    try {
      final repo = CountriesRepository(CountriesDataProvider());
      final countries = await repo.fetchCountry();
      if (!mounted) return;
      setState(() {
        _countries = countries.isNotEmpty
            ? countries
            : CountryDefaults.fallbackCountries();
        _selectedCountry = _countries.firstWhere(
          (c) => c.isoCode?.toUpperCase() == 'SO',
          orElse: () => _countries.first,
        );
        _loadingCountries = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _countries = CountryDefaults.fallbackCountries();
        _selectedCountry = CountryDefaults.defaultCountry();
        _loadingCountries = false;
      });
    }
  }

  void _search() {
    HapticFeedback.lightImpact();
    setState(() {
      _awbError = null;
      _phoneError = null;
    });

    final bloc = context.read<PublicTrackingBloc>();

    if (_searchMode == _SearchMode.awb) {
      final awb = _awbController.text.trim();
      if (awb.isEmpty) {
        setState(() => _awbError = 'Please enter an AWB or tracking number');
        return;
      }
      bloc.add(PublicTrackingSearchByAwb(awb));
      return;
    }

    final local = _phoneController.text.trim();
    if (local.length < 7) {
      setState(() => _phoneError = 'Enter at least 7 digits');
      return;
    }
    bloc.add(PublicTrackingSearchByPhone(
      countryDialCode: _selectedCountry.countryCode ?? '+252',
      localNumber: local,
    ));
  }

  Future<void> _scanBarcode() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => const _PublicBarcodeScanner(),
      ),
    );
    if (result != null && result.isNotEmpty && mounted) {
      setState(() {
        _searchMode = _SearchMode.awb;
        _awbController.text = result;
      });
      _search();
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isDark = context.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A1931) : palette.background,
      body: Column(
        children: [
          _buildHero(context, palette),
          Expanded(
            child: BlocBuilder<PublicTrackingBloc, PublicTrackingState>(
              builder: (context, state) {
                if (state is PublicTrackingLoading) {
                  return PublicTrackingWidgets.buildShimmer(context);
                }
                if (state is PublicTrackingSingleResult) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: PublicTrackingWidgets.buildTrackingDetails(
                      context: context,
                      events: state.events,
                    ),
                  );
                }
                if (state is PublicTrackingMultipleResults) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                          child: Text(
                            '${state.summaries.length} shipments found',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: palette.textPrimary,
                            ),
                          ),
                        ),
                        PublicTrackingWidgets.buildShipmentList(
                          context: context,
                          summaries: state.summaries,
                          onSelect: (awb) => context
                              .read<PublicTrackingBloc>()
                              .add(PublicTrackingShipmentSelected(awb)),
                        ),
                      ],
                    ),
                  );
                }
                if (state is PublicTrackingFailure) {
                  return PublicTrackingWidgets.buildErrorState(
                    context: context,
                    message: state.message,
                    onRetry: _search,
                  );
                }
                return _buildEmptyState(palette);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHero(BuildContext context, AppPalette palette) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFF7A33), Color(0xFFFF5A00)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                  ),
                  const Expanded(
                    child: Text(
                      'Track Shipment',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'No login required',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Find your package by AWB or phone',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildModeToggle(),
                    const SizedBox(height: 14),
                    if (_searchMode == _SearchMode.awb) _buildAwbField(palette),
                    if (_searchMode == _SearchMode.phone)
                      _loadingCountries
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          : PhoneCountrySelector(
                              countries: _countries,
                              selectedCountry: _selectedCountry,
                              phoneController: _phoneController,
                              errorText: _phoneError,
                              onCountryChanged: (c) {
                                setState(() => _selectedCountry = c);
                              },
                            ),
                    const SizedBox(height: 14),
                    _buildSearchButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _modeChip('AWB', _SearchMode.awb, Icons.qr_code_2_rounded),
          _modeChip('Phone', _SearchMode.phone, Icons.phone_rounded),
        ],
      ),
    );
  }

  Widget _modeChip(String label, _SearchMode mode, IconData icon) {
    final isSelected = _searchMode == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _searchMode = mode),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.white
                : Colors.white.withValues(alpha: 0.0),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected
                    ? const Color(0xFFFF5A00)
                    : Colors.white.withValues(alpha: 0.85),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: isSelected
                      ? const Color(0xFFFF5A00)
                      : Colors.white.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAwbField(AppPalette palette) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _awbError != null ? Colors.red : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _awbController,
                  style: TextStyle(
                    color: palette.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: 'AWB123 or AWB123-1',
                    hintStyle: TextStyle(
                      color: palette.textSecondary.withValues(alpha: 0.7),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 16,
                    ),
                  ),
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) => _search(),
                ),
              ),
              IconButton(
                onPressed: _scanBarcode,
                icon: Icon(Icons.qr_code_scanner_rounded, color: palette.accent),
                tooltip: 'Scan barcode',
              ),
            ],
          ),
        ),
        if (_awbError != null) ...[
          const SizedBox(height: 6),
          Text(
            _awbError!,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ],
    );
  }

  Widget _buildSearchButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _search,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.radar_rounded, color: Color(0xFFFF5A00), size: 22),
              SizedBox(width: 8),
              Text(
                'Track now',
                style: TextStyle(
                  color: Color(0xFFFF5A00),
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppPalette palette) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_shipping_outlined,
              size: 72,
              color: palette.textSecondary.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              'Enter your AWB or phone number\nto see shipment status',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: palette.textSecondary,
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PublicBarcodeScanner extends StatefulWidget {
  const _PublicBarcodeScanner();

  @override
  State<_PublicBarcodeScanner> createState() => _PublicBarcodeScannerState();
}

class _PublicBarcodeScannerState extends State<_PublicBarcodeScanner> {
  final MobileScannerController _controller = MobileScannerController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan AWB'),
        backgroundColor: const Color(0xFFFF5A00),
        foregroundColor: Colors.white,
      ),
      body: MobileScanner(
        controller: _controller,
        onDetect: (capture) {
          final barcodes = capture.barcodes;
          if (barcodes.isEmpty) return;
          final raw = barcodes.first.rawValue;
          if (raw != null && raw.isNotEmpty) {
            Navigator.pop(context, raw);
          }
        },
      ),
    );
  }
}
