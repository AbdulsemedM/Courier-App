import 'package:courier_app/features/add_shipment/bloc/add_shipment_bloc.dart';
import 'package:courier_app/features/add_shipment/data/data_provider/add_shipment_data_provider.dart';
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
import 'package:courier_app/features/currency/bloc/currency_bloc.dart';
import 'package:courier_app/features/currency/data/data_provider/currency_data_provider.dart';
import 'package:courier_app/features/currency/data/repository/currency_repository.dart';
import 'package:courier_app/features/exchange_rate/bloc/exchange_rate_bloc.dart';
import 'package:courier_app/features/exchange_rate/data/data_provider/exchange_rate_data_provider.dart';
import 'package:courier_app/features/exchange_rate/data/repository/exchange_rate_repository.dart';
import 'package:courier_app/features/login/bloc/login_bloc.dart';
import 'package:courier_app/features/login/data/data_provider/login_data_provider.dart';
import 'package:courier_app/features/login/data/repository/login_repository.dart';
import 'package:courier_app/features/login/presentation/screen/login_screen.dart';
import 'package:courier_app/features/manage_agent/bloc/manage_agent_bloc.dart';
import 'package:courier_app/features/manage_agent/data/data_provider/manage_agent_data_provider.dart';
import 'package:courier_app/features/manage_agent/data/repository/manage_agent_repository.dart';
import 'package:courier_app/features/manage_customers/bloc/manage_customers_bloc.dart';
import 'package:courier_app/features/manage_customers/data/data_provider/manage_customers_data_provider.dart';
import 'package:courier_app/features/manage_customers/data/repository/manage_customers_repository.dart';
import 'package:courier_app/features/manage_user/bloc/manage_user_bloc.dart';
import 'package:courier_app/features/manage_user/data/data_provider/manage_user_data_provider.dart';
import 'package:courier_app/features/manage_user/data/repository/manage_user_repository.dart';
import 'package:courier_app/features/miles_configuration/bloc/miles_configuration_bloc.dart';
import 'package:courier_app/features/miles_configuration/data/data_provider/miles_configuration_data_provider.dart';
import 'package:courier_app/features/miles_configuration/data/repository/miles_configuration_repository.dart';
import 'package:courier_app/features/payment_method/bloc/payment_methods_bloc.dart';
import 'package:courier_app/features/payment_method/data/data_provider/payment_methods_data_provider.dart';
import 'package:courier_app/features/payment_method/data/repository/payment_methods_repository.dart';
import 'package:courier_app/features/analytics/bloc/analytics_bloc.dart';
import 'package:courier_app/features/analytics/data/data_provider/analytics_data_provider.dart';
import 'package:courier_app/features/analytics/data/repository/analytics_repository.dart';
import 'package:courier_app/features/roles/bloc/roles_bloc.dart';
import 'package:courier_app/features/roles/data/data_provider/roles_data_provider.dart';
import 'package:courier_app/features/roles/data/repository/roles_repository.dart';
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
import 'package:courier_app/features/tellers/bloc/tellers_bloc.dart';
import 'package:courier_app/features/tellers/data/data_provider/teller_data_provider.dart';
import 'package:courier_app/features/tellers/data/repository/teller_repository.dart';
import 'package:courier_app/features/track_order/bloc/track_order_bloc.dart';
import 'package:courier_app/features/track_order/data/data_provider/track_order_data_provider.dart';
import 'package:courier_app/features/track_order/data/repository/track_order_repository.dart';
import 'package:courier_app/features/track_shipment/bloc/track_shipment_bloc.dart';
import 'package:courier_app/features/track_shipment/data/data_provider/track_shipment_data_provider.dart';
import 'package:courier_app/features/track_shipment/data/repository/track_shipment_repository.dart';
import 'package:courier_app/features/transport_modes/bloc/transport_modes_bloc.dart';
import 'package:courier_app/features/transport_modes/data/data_provider/transport_modes_data_provider.dart';
import 'package:courier_app/features/transport_modes/data/repository/transport_modes_repository.dart';
import 'package:courier_app/features/accounts/bloc/account_bloc.dart';
import 'package:courier_app/features/accounts/data/data_provider/account_data_provider.dart';
import 'package:courier_app/features/accounts/data/repository/account_repository.dart';
import 'package:courier_app/features/balance_sheet/bloc/balance_sheet_bloc.dart';
import 'package:courier_app/features/balance_sheet/data/data_provider/balance_sheet_data_provider.dart';
import 'package:courier_app/features/balance_sheet/data/repository/balance_sheet_repository.dart';
import 'package:courier_app/features/income_statement/bloc/income_statement_bloc.dart';
import 'package:courier_app/features/income_statement/data/data_provider/income_statement_data_provider.dart';
import 'package:courier_app/features/income_statement/data/repository/income_statement_repository.dart';
import 'package:courier_app/features/teller_accounts/bloc/teller_account_bloc.dart';
import 'package:courier_app/features/teller_accounts/data/data_provider/teller_account_data_provider.dart';
import 'package:courier_app/features/teller_accounts/data/repository/teller_account_repository.dart';
import 'package:courier_app/features/teller_by_branch/bloc/teller_by_branch_bloc.dart';
import 'package:courier_app/features/teller_by_branch/data/data_provider/teller_by_branch_data_provider.dart';
import 'package:courier_app/features/teller_by_branch/data/repository/teller_by_branch_repository.dart';
import 'package:courier_app/features/transaction_branch_to_hq/bloc/transaction_branch_to_hq_bloc.dart';
import 'package:courier_app/features/transaction_branch_to_hq/data/data_provider/transaction_branch_to_hq_data_provider.dart';
import 'package:courier_app/features/transaction_branch_to_hq/data/repository/transaction_branch_to_hq_repository.dart';
import 'package:courier_app/providers/provider_setup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'core/theme/theme_provider.dart';
import 'package:courier_app/configuration/payment_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required for SharedPreferences
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => PaymentService()),
        BlocProvider(
          create: (context) =>
              TrackOrderBloc(TrackOrderRepository(TrackOrderDataProvider())),
        ),
        BlocProvider(
          create: (context) => AddShipmentBloc(AddShipmentRepository(
              addShipmentDataProvider: AddShipmentDataProvider(),
              cacheService: ProviderSetup.getCacheService())),
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
                ServicesModeRepository(ServicesModeDataProvider()))),
        BlocProvider(
            create: (context) =>
                CurrencyBloc(CurrencyRepository(CurrencyDataProvider()))),
        BlocProvider(
            create: (context) => TransportModesBloc(
                TransportModesRepository(TransportModesDataProvider()))),
        BlocProvider(
            create: (context) => ExchangeRateBloc(
                ExchangeRateRepository(ExchangeRateDataProvider()))),
        BlocProvider(
            create: (context) => ManageCustomersBloc(
                ManageCustomersRepository(ManageCustomersDataProvider()))),
        BlocProvider(
            create: (context) => ManageAgentBloc(
                ManageAgentRepository(ManageAgentDataProvider()))),
        BlocProvider(
            create: (context) => ManageUserBloc(
                ManageUsersRepository(ManageUsersDataProvider()))),
        BlocProvider(
            create: (context) =>
                TellersBloc(TellerRepository(TellerDataProvider()))),
        BlocProvider(
            create: (context) =>
                RolesBloc(RolesRepository(RolesDataProvider()))),
        BlocProvider(
            create: (context) => AnalyticsBloc(AnalyticsRepository(
                analyticsDataProvider: AnalyticsDataProvider()))),
        BlocProvider(
            create: (context) => AccountBloc(
                AccountRepository(accountDataProvider: AccountDataProvider()))),
        BlocProvider(
            create: (context) => BalanceSheetBloc(BalanceSheetRepository(
                balanceSheetDataProvider: BalanceSheetDataProvider()))),
        BlocProvider(
            create: (context) => IncomeStatementBloc(IncomeStatementRepository(
                incomeStatementDataProvider: IncomeStatementDataProvider()))),
        BlocProvider(
            create: (context) => TellerAccountBloc(TellerAccountRepository(
                tellerAccountDataProvider: TellerAccountDataProvider()))),
        BlocProvider(
            create: (context) => TellerByBranchBloc(TellerByBranchRepository(
                tellerByBranchDataProvider: TellerByBranchDataProvider()))),
        BlocProvider(
            create: (context) => TransactionBranchToHqBloc(
                TransactionBranchToHqRepository(
                    dataProvider: TransactionBranchToHqDataProvider()))),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Courier App',
          debugShowCheckedModeBanner: false,
          theme: themeProvider.currentTheme,
          home: const LoginScreen(),
        );
      },
    );
  }
}
