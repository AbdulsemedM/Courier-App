import 'package:courier_app/app/utils/dialog_utils.dart';
import 'package:courier_app/configuration/phone_number_manager.dart';
import 'package:courier_app/features/applications/presentation/widgets/application_widget.dart';
import 'package:courier_app/features/applications/presentation/widgets/shipment_type_modal.dart';
import 'package:courier_app/features/shelves_management/presentation/screen/shelves_screen.dart';
import 'package:courier_app/features/shelves_management/presentation/screen/shelf_transfer_screen.dart';
import 'package:courier_app/features/shelves_management/bloc/shelves_management_bloc.dart';
import 'package:courier_app/features/shelves_management/data/repository/shelves_repository.dart';
import 'package:courier_app/features/shelves_management/data/data_provider/shelves_data_provider.dart';
import 'package:courier_app/features/shipment/presentation/screens/shipments_screen.dart';
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
  List<MenuOption> _visibleOptions = [];

  @override
  void initState() {
    super.initState();
    fetchPermissions();
    context.read<TrackOrderBloc>().add(FetchStatuses());
  }

  void fetchPermissions() async {
    final permissions = await PermissionManager().getPermissionList();
    if (!mounted) return;
    setState(() {
      this.permissions = permissions;
      _visibleOptions = defaultMenuOptions
          .where((option) => option.isAllowed(permissions))
          .toList();
    });
  }

  void _handleOptionSelected(MenuOption option) {
    final allowed = option.isAllowed(permissions);
    if (!allowed) {
      displaySnack(
        context,
        'You do not have permission to access ${option.title}',
        Colors.red,
      );
      return;
    }

    final screen = option.screen;
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
    } else if (screen is ShelfTransferScreen) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => ShelvesManagementBloc(
              shelvesRepository: ShelvesRepository(
                shelvesDataProvider: ShelvesDataProvider(),
              ),
            ),
            child: const ShelfTransferScreen(),
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screen),
      );
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
      body: _visibleOptions.isEmpty
          ? ApplicationWidgets.buildEmptyState(
              isDarkMode: context.isDarkMode,
            )
          : ApplicationWidgets.buildApplicationsBody(
              context: context,
              isDarkMode: context.isDarkMode,
              options: _visibleOptions,
              onOptionSelected: _handleOptionSelected,
            ),
    );
  }
}
