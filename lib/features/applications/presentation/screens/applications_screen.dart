import 'package:courier_app/app/utils/dialog_utils.dart';
import 'package:courier_app/configuration/phone_number_manager.dart';
import 'package:courier_app/features/applications/presentation/widgets/application_widget.dart';
import 'package:courier_app/features/comming_soon/coming_soon_screen.dart';
import 'package:courier_app/features/miles_configuration/presentation/screens/miles_configuration_screen.dart';
import 'package:courier_app/features/pay_by_awb/presentation/screen/pay_by_awb_screen.dart';
import 'package:courier_app/features/roles/presentation/screen/roles_screen.dart';
import 'package:courier_app/features/shipment/presentation/screens/shipments_screen.dart';
import 'package:courier_app/features/shipment_invoice/presentation/screens/shipment_invoice_screen.dart';
import 'package:flutter/material.dart';
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
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screen),
      );
    } else {
      displaySnack(context, errorMessage, Colors.red);
    }
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
            permission = 'manage_miles';
            errorMessage =
                'You do not have permission to access Miles Configuration';
          } else if (screen is ShipmentInvoiceScreen) {
            permission = 'manage_shipment_invoice';
            errorMessage =
                'You do not have permission to access Shipment Invoice';
          } else if (screen is ShipmentsScreen) {
            permission = 'view_shipments';
            errorMessage = 'You do not have permission to view shipments';
          } else if (screen is RolesScreen) {
            permission = 'manage_roles';
            errorMessage = 'You do not have permission to manage roles';
          } else if (screen is ComingSoonScreen) {
            permission = 'manage_extra_fee';
            errorMessage = 'You do not have permission to manage extra fees';
          }

          _handleOptionSelected(context, screen, permission, errorMessage);
        },
      ),
    );
  }
}
