import 'package:courier_app/app/utils/dialog_utils.dart';
import 'package:courier_app/configuration/phone_number_manager.dart';
import 'package:courier_app/features/applications/presentation/widgets/application_widget.dart';
import 'package:courier_app/features/applications/presentation/widgets/shipment_type_modal.dart';
import 'package:courier_app/features/comming_soon/coming_soon_screen.dart';
import 'package:courier_app/features/miles_configuration/presentation/screens/miles_configuration_screen.dart';
import 'package:courier_app/features/pay_by_awb/presentation/screen/pay_by_awb_screen.dart';
import 'package:courier_app/features/roles/presentation/screen/roles_screen.dart';
import 'package:courier_app/features/shelves_management/presentation/screen/shelves_screen.dart';
import 'package:courier_app/features/shelves_management/bloc/shelves_management_bloc.dart';
import 'package:courier_app/features/shelves_management/data/repository/shelves_repository.dart';
import 'package:courier_app/features/shelves_management/data/data_provider/shelves_data_provider.dart';
import 'package:courier_app/features/shipment/presentation/screens/shipments_screen.dart';
import 'package:courier_app/features/shipment_invoice/presentation/screens/shipment_invoice_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme_provider.dart';

class ApplicationsScreen extends StatefulWidget {
  const ApplicationsScreen({super.key});

  @override
  State<ApplicationsScreen> createState() => _ApplicationsScreenState();
}

class _ApplicationsScreenState extends State<ApplicationsScreen> {
  List<String> permissions = [];

  @override
  void initState() {
    super.initState();
    fetchPermissions();
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
    if (permissions.contains(permission)) {
      // Show modal for ShipmentsScreen
      if (screen is ShipmentsScreen) {
        _showShipmentTypeModal(context);
      }
      // Wrap ShelvesScreen with required BLoC providers
      else if (screen is ShelvesScreen) {
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

  void _showShipmentTypeModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ShipmentTypeModal(
        onTypeSelected: (type) {
          _handleShipmentTypeSelection(context, type);
        },
      ),
    );
  }

  void _handleShipmentTypeSelection(BuildContext context, ShipmentType type) {
    String? status;
    if (type == ShipmentType.r4p) {
      status = 'R4P';
    } else if (type == ShipmentType.arrived) {
      status = 'ARR';
    } else if (type == ShipmentType.arriving) {
      status = 'OTW'; // On the way / Arriving shipments
    } else if (type == ShipmentType.delivered) {
      status = 'DEL';
    }
    // For 'all', status remains null
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShipmentsScreen(initialStatus: status),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor:
          isDarkMode ? const Color(0xFF5b3895) : const Color(0xFF5b3895),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Applications',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ApplicationWidgets.buildMenuGrid(
        isDarkMode: isDarkMode,
        options: defaultMenuOptions,
        onOptionSelected: (screen) {
          // Get the permission and error message based on the screen type
          String permission = '';
          String errorMessage = '';

          if (screen is PayByAwbScreen) {
            permission = 'pay_by_awb';
            errorMessage = 'You do not have permission to access Pay by AWB';
          } else if (screen is MilesConfigurationScreen) {
            permission = 'manage_miles_config';
            errorMessage =
                'You do not have permission to access Miles Configuration';
          } else if (screen is ShipmentInvoiceScreen) {
            permission = 'Shipment_Invoice';
            errorMessage =
                'You do not have permission to access Shipment Invoice';
          } else if (screen is ShipmentsScreen) {
            permission = 'manage_shipments';
            errorMessage = 'You do not have permission to view shipments';
          } else if (screen is RolesScreen) {
            permission = 'manage_permissions';
            errorMessage = 'You do not have permission to manage roles';
          } else if (screen is ComingSoonScreen) {
            permission = 'manage_extra_fee';
            errorMessage = 'You do not have permission to manage extra fees';
          } else if (screen is ShelvesScreen) {
            permission = 'Shelves_management';
            errorMessage = 'You do not have permission to manage shelves';
          }

          _handleOptionSelected(context, screen, permission, errorMessage);
        },
      ),
    );
  }
}
