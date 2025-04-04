import 'package:courier_app/features/add_shipment/bloc/add_shipment_bloc.dart';
import 'package:courier_app/features/add_shipment/data/repository/add_shipment_repository.dart';
import 'package:courier_app/features/barcode_reader/bloc/barcode_reader_bloc.dart';
import 'package:courier_app/features/barcode_reader/data/data_provider/barcode_data_provider.dart';
import 'package:courier_app/features/barcode_reader/data/repository/barcode_repository.dart';
import 'package:courier_app/features/branches/bloc/branches_bloc.dart';
import 'package:courier_app/features/branches/data/data_provider/branches_data_provider.dart';
import 'package:courier_app/features/branches/data/repository/branches_repository.dart';
import 'package:courier_app/features/countries/bloc/countries_bloc.dart';
import 'package:courier_app/features/countries/data/data_provider/countries_data_provider.dart';
import 'package:courier_app/features/countries/data/repository/countries_repository.dart';
import 'package:courier_app/features/login/bloc/login_bloc.dart';
import 'package:courier_app/features/login/data/data_provider/login_data_provider.dart';
import 'package:courier_app/features/login/data/repository/login_repository.dart';
import 'package:courier_app/features/login/presentation/screen/login_screen.dart';
import 'package:courier_app/features/miles_configuration/bloc/miles_configuration_bloc.dart';
import 'package:courier_app/features/miles_configuration/data/data_provider/miles_configuration_data_provider.dart';
import 'package:courier_app/features/miles_configuration/data/repository/miles_configuration_repository.dart';
import 'package:courier_app/features/payment_method/bloc/payment_methods_bloc.dart';
import 'package:courier_app/features/payment_method/data/data_provider/payment_methods_data_provider.dart';
import 'package:courier_app/features/payment_method/data/repository/payment_methods_repository.dart';
import 'package:courier_app/features/services_mode/bloc/services_mode_bloc.dart';
import 'package:courier_app/features/services_mode/data/data_provider/services_mode_data_provider.dart';
import 'package:courier_app/features/services_mode/data/repository/services_mode_repository.dart';
import 'package:courier_app/features/shipment/bloc/shipments_bloc.dart';
import 'package:courier_app/features/shipment/data/data_provider/shipment_data_provider.dart';
import 'package:courier_app/features/shipment/data/repository/shipment_repository.dart';
import 'package:courier_app/features/shipment_invoice/bloc/shipment_invoice_bloc.dart';
import 'package:courier_app/features/shipment_invoice/data/data_provider/shipment_invoice_data_provider.dart';
import 'package:courier_app/features/shipment_invoice/data/repository/shipment_invoice_repository.dart';
import 'package:courier_app/features/shipment_types/bloc/shipment_types_bloc.dart';
import 'package:courier_app/features/shipment_types/data/data_provider/shipment_types_data_provider.dart';
import 'package:courier_app/features/shipment_types/data/repository/shipment_types_repository.dart';
import 'package:courier_app/features/track_order/bloc/track_order_bloc.dart';
import 'package:courier_app/features/track_order/data/data_provider/track_order_data_provider.dart';
import 'package:courier_app/features/track_order/data/repository/track_order_repository.dart';
import 'package:courier_app/features/track_shipment/bloc/track_shipment_bloc.dart';
import 'package:courier_app/features/track_shipment/data/data_provider/track_shipment_data_provider.dart';
import 'package:courier_app/features/track_shipment/data/repository/track_shipment_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'core/theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required for SharedPreferences
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              TrackOrderBloc(TrackOrderRepository(TrackOrderDataProvider())),
        ),
        BlocProvider(
          create: (context) => AddShipmentBloc(AddShipmentRepository()),
        ),
        BlocProvider(
          create: (context) => BarcodeReaderBloc(
            BarcodeRepository(BarcodeDataProvider()),
          ),
        ),
        BlocProvider(
          create: (context) => TrackShipmentBloc(
            TrackShipmentRepository(TrackShipmentDataProvider()),
          ),
        ),
        BlocProvider(
          create: (context) => MilesConfigurationBloc(
            MilesConfigurationRepository(MilesConfigurationDataProvider()),
          ),
        ),
        BlocProvider(
            create: (context) => ShipmentInvoiceBloc(ShipmentInvoiceRepository(
                shipmentInvoiceDataProvider: ShipmentInvoiceDataProvider()))),
        BlocProvider(
            create: (context) => ShipmentsBloc(ShipmentRepository(
                shipmentDataProvider: ShipmentDataProvider()))),
        BlocProvider(
            create: (context) =>
                LoginBloc(LoginRepository(LoginDataProvider()))),
        BlocProvider(
            create: (context) => BranchesBloc(BranchesRepository(
                branchesDataProvider: BranchesDataProvider()))),
        BlocProvider(
            create: (context) =>
                CountriesBloc(CountriesRepository(CountriesDataProvider()))),
        BlocProvider(
            create: (context) => PaymentMethodsBloc(
                PaymentMethodsRepository(PaymentMethodsDataProvider()))),
        BlocProvider(
            create: (context) => ShipmentTypesBloc(
                ShipmentTypesRepository(ShipmentTypesDataProvider()))),
        BlocProvider(
            create: (context) => ServicesModeBloc(
                ServicesModeRepository(ServicesModeDataProvider())))
      ],
      child: ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Courier App',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.currentTheme,
            home: const LoginScreen(),
          );
        },
      ),
    );
  }
}
