import 'package:courier_app/app/utils/dialog_utils.dart';
import 'package:courier_app/configuration/auth_service.dart';
import 'package:courier_app/configuration/phone_number_manager.dart';
import 'package:courier_app/core/utils/manifest_access_helper.dart';
import 'package:courier_app/features/applications/presentation/widgets/application_widget.dart';
import 'package:courier_app/features/applications/presentation/widgets/shipment_type_modal.dart';
import 'package:courier_app/features/comming_soon/coming_soon_screen.dart';
import 'package:courier_app/features/manifest/presentation/screens/manifest_screen.dart';
// import 'package:courier_app/features/miles_configuration/presentation/screens/miles_configuration_screen.dart';
import 'package:courier_app/features/pay_by_awb/presentation/screen/pay_by_awb_screen.dart';
// import 'package:courier_app/features/roles/presentation/screen/roles_screen.dart';
import 'package:courier_app/features/shelves_management/presentation/screen/shelves_screen.dart';
import 'package:courier_app/features/shelves_management/bloc/shelves_management_bloc.dart';
import 'package:courier_app/features/shelves_management/data/repository/shelves_repository.dart';
import 'package:courier_app/features/shelves_management/data/data_provider/shelves_data_provider.dart';
import 'package:courier_app/features/shipment/presentation/screens/shipments_screen.dart';
import 'package:courier_app/features/shipment_invoice/presentation/screens/shipment_invoice_screen.dart';
import 'package:courier_app/features/track_order/bloc/track_order_bloc.dart';
import 'package:courier_app/features/track_order/model/statuses_model.dart';
import 'package:courier_app/core/theme/app_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ApplicationsScreen extends StatefulWidget {
  const ApplicationsScreen({super.key});

  @override
  State<ApplicationsScreen> createState() => _ApplicationsScreenState();
}

class _ApplicationsScreenState extends State<ApplicationsScreen> {
  List<String> permissions = [];
  List<String> _roles = [];

  @override
  void initState() {
    super.initState();
    fetchPermissions();
    _loadRoles();
    context.read<TrackOrderBloc>().add(FetchStatuses());
  }

  Future<void> _loadRoles() async {
    final authService = AuthService();
    final storedRoles = await authService.getRoleNames();
    final roleName = await authService.getRoleName();
    final roles = <String>[
      ...storedRoles,
      if (roleName != null && roleName.isNotEmpty) roleName,
    ];
    if (mounted) {
      setState(() => _roles = roles);
    }
  }

  void fetchPermissions() async {
    final permissions = await PermissionManager().getPermission();
    if (permissions != null) {
      setState(() {
        this.permissions = permissions;
      });
    }
  }

  void _handleOptionSelected(BuildContext context, Widget screen,
      String permission, String errorMessage) {
    if (screen is ManifestScreen) {
      if (ManifestAccessHelper.canAccessManifest(_roles)) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ManifestScreen()),
        );
      } else {
        displaySnack(
          context,
          'You do not have access to Manifest',
          Colors.red,
        );
      }
      return;
    }

    if (permissions.contains(permission)) {
      if (screen is ShipmentsScreen) {
        _showShipmentTypeModal(context);
      } else if (screen is ShelvesScreen) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => ShelvesManagementBloc(
                    shelvesRepository: ShelvesRepository(
                      shelvesDataProvider: ShelvesDataProvider(),
                    ),
                  ),
                ),
              ],
              child: const ShelvesScreen(),
            ),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      }
    } else if (screen is ComingSoonScreen) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screen),
      );
    } else {
      displaySnack(context, errorMessage, Colors.red);
    }
  }

  Future<void> _showShipmentTypeModal(BuildContext context) async {
    final bloc = context.read<TrackOrderBloc>();
    var state = bloc.state;

    if (state is! FetchStatusSuccess) {
      bloc.add(FetchStatuses());
      state = await bloc.stream.firstWhere(
        (s) => s is FetchStatusSuccess || s is FetchStatusFailure,
      );
    }

    if (!context.mounted) return;

    if (state is FetchStatusSuccess) {
      _openShipmentTypeModal(context, state.statuses);
    } else if (state is FetchStatusFailure) {
      displaySnack(context, state.errorMessage, Colors.red);
    }
  }

  void _openShipmentTypeModal(
    BuildContext context,
    List<StatusModel> statuses,
  ) {
    if (statuses.isEmpty) {
      displaySnack(context, 'No shipment statuses available', Colors.red);
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ShipmentTypeModal(
        statuses: statuses,
        onStatusSelected: (statusCode) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShipmentsScreen(initialStatus: statusCode),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Scaffold(
      backgroundColor: palette.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: palette.appBarBackground,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Applications',
          style: TextStyle(
            color: palette.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ApplicationWidgets.buildApplicationsBody(
        context: context,
        isDarkMode: context.isDarkMode,
        options: defaultMenuOptions,
        onOptionSelected: (screen) {
          String permission = '';
          String errorMessage = '';

          if (screen is PayByAwbScreen) {
            permission = 'pay_by_awb';
            errorMessage = 'You do not have permission to access Pay by AWB';
          // } else if (screen is MilesConfigurationScreen) {
          //   permission = 'manage_miles_config';
          //   errorMessage =
          //       'You do not have permission to access Miles Configuration';
          } else if (screen is ShipmentInvoiceScreen) {
            permission = 'Shipment_Invoice';
            errorMessage =
                'You do not have permission to access Shipment Invoice';
          } else if (screen is ShipmentsScreen) {
            permission = 'manage_shipments';
            errorMessage = 'You do not have permission to view shipments';
          // } else if (screen is RolesScreen) {
          //   permission = 'manage_permissions';
          //   errorMessage = 'You do not have permission to manage roles';
          } else if (screen is ComingSoonScreen) {
            permission = 'manage_extra_fee';
            errorMessage = 'You do not have permission to manage extra fees';
          } else if (screen is ShelvesScreen) {
            permission = 'Shelves_management';
            errorMessage = 'You do not have permission to manage shelves';
          } else if (screen is ManifestScreen) {
            _handleOptionSelected(context, screen, '', '');
            return;
          }

          _handleOptionSelected(context, screen, permission, errorMessage);
        },
      ),
    );
  }
}
