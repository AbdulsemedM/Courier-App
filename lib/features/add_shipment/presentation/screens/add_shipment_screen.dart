import 'package:courier_app/features/add_shipment/bloc/add_shipment_bloc.dart';
import 'package:courier_app/features/add_shipment/model/branch_model.dart';
import 'package:courier_app/features/add_shipment/model/delivery_types_model.dart';
import 'package:courier_app/features/add_shipment/model/payment_method_model.dart';
import 'package:courier_app/features/add_shipment/model/payment_mode_model.dart';
import 'package:courier_app/features/add_shipment/model/service_modes_model.dart';
import 'package:courier_app/features/add_shipment/model/shipment_type_model.dart';
import 'package:courier_app/features/add_shipment/model/transport_mode_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme_provider.dart';
import 'first_page.dart';
import 'second_page.dart';
import 'third_page.dart';

class AddShipmentScreen extends StatefulWidget {
  const AddShipmentScreen({super.key});

  @override
  State<AddShipmentScreen> createState() => _AddShipmentScreenState();
}

class _AddShipmentScreenState extends State<AddShipmentScreen> {
  final _pageController = PageController();
  int _currentPage = 0;
  final _formKey = GlobalKey<FormState>();
  List<BranchModel> branches = [];
  List<DeliveryTypeModel> deliveryTypes = [];
  List<PaymentMethodModel> paymentMethods = [];
  List<PaymentModeModel> paymentModes = [];
  List<ServiceModeModel> services = [];
  List<ShipmentTypeModel> shipmentTypes = [];
  List<TransportModeModel> transportModes = [];

  final Map<String, dynamic> formData1 = {
    "senderName": "",
    "senderMobile": "",
    "receiverName": "",
    "receiverMobile": "",
    "senderBranchId": 1,
    "receiverBranchId": 1,
  };
  final Map<String, dynamic> formData2 = {
    "extraFeeDescription": "",
    "shipmentTypeId": 1,
    "quantity": 1,
    "unit": "",
    "netFee": 1,
    "numPcs": 0,
    "numBoxes": 0,
    "rate": 50.75,
    "serviceModeId": 1,
  };
  final Map<String, dynamic> formData3 = {
    "paymentMethodId": 1,
    "deliveryTypeId": 1,
    "transportModeId": 1,
    "hudhudPercent": 0,
    "hudhudNet": 0,
    "creditAccount": "",
    // "paymentModeId": 1,
    "addedBy": 1,
  };
  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAllData();
  }

  void _fetchAllData() {
    context.read<AddShipmentBloc>().add(FetchBranches());
    context.read<AddShipmentBloc>().add(FetchDeliveryTypes());
    context.read<AddShipmentBloc>().add(FetchPaymentMethods());
    context.read<AddShipmentBloc>().add(FetchPaymentModes());
    context.read<AddShipmentBloc>().add(FetchServices());
    context.read<AddShipmentBloc>().add(FetchShipmentTypes());
    context.read<AddShipmentBloc>().add(FetchTransportModes());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildStepIndicator(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: List.generate(3, (index) {
          bool isActive = index <= _currentPage;
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 4,
              decoration: BoxDecoration(
                color: isActive
                    ? (isDarkMode ? Colors.blue[400] : Colors.blue)
                    : (isDarkMode ? Colors.grey[700] : Colors.grey[300]),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF0A1931) : Colors.grey[100],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF1A1F37) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isDarkMode ? Colors.blue[400]! : Colors.blue,
                      ),
                      strokeWidth: 4,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Loading Shipment Data...',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return MultiBlocListener(
      listeners: [
        BlocListener<AddShipmentBloc, AddShipmentState>(
          listenWhen: (previous, current) => current is FetchBranchesSuccess,
          listener: (context, state) {
            if (state is FetchBranchesSuccess) {
              setState(() => branches = state.branches);
            }
          },
        ),
        BlocListener<AddShipmentBloc, AddShipmentState>(
          listenWhen: (previous, current) =>
              current is FetchDeliveryTypesSuccess,
          listener: (context, state) {
            if (state is FetchDeliveryTypesSuccess) {
              setState(() => deliveryTypes = state.deliveryTypes);
            }
          },
        ),
        BlocListener<AddShipmentBloc, AddShipmentState>(
          listenWhen: (previous, current) =>
              current is FetchPaymentMethodsSuccess,
          listener: (context, state) {
            if (state is FetchPaymentMethodsSuccess) {
              setState(() => paymentMethods = state.paymentMethods);
            }
          },
        ),
        BlocListener<AddShipmentBloc, AddShipmentState>(
          listenWhen: (previous, current) =>
              current is FetchPaymentModesSuccess,
          listener: (context, state) {
            if (state is FetchPaymentModesSuccess) {
              setState(() => paymentModes = state.paymentModes);
            }
          },
        ),
        BlocListener<AddShipmentBloc, AddShipmentState>(
          listenWhen: (previous, current) => current is FetchServicesSuccess,
          listener: (context, state) {
            if (state is FetchServicesSuccess) {
              setState(() => services = state.services);
            }
          },
        ),
        BlocListener<AddShipmentBloc, AddShipmentState>(
          listenWhen: (previous, current) =>
              current is FetchShipmentTypesSuccess,
          listener: (context, state) {
            if (state is FetchShipmentTypesSuccess) {
              setState(() => shipmentTypes = state.shipmentTypes);
            }
          },
        ),
        BlocListener<AddShipmentBloc, AddShipmentState>(
          listenWhen: (previous, current) =>
              current is FetchTransportModesSuccess,
          listener: (context, state) {
            if (state is FetchTransportModesSuccess) {
              setState(() => transportModes = state.transportModes);
            }
          },
        ),
        BlocListener<AddShipmentBloc, AddShipmentState>(
          listenWhen: (previous, current) =>
              current is FetchBranchesFailure ||
              current is FetchDeliveryTypesFailure ||
              current is FetchPaymentMethodsFailure ||
              current is FetchPaymentModesFailure ||
              current is FetchServicesFailure ||
              current is FetchShipmentTypesFailure ||
              current is FetchTransportModesFailure,
          listener: (context, state) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${(state as dynamic).error}'),
                action: SnackBarAction(
                  label: 'Retry',
                  onPressed: _fetchAllData,
                ),
              ),
            );
          },
        ),
      ],
      child: BlocBuilder<AddShipmentBloc, AddShipmentState>(
        builder: (context, state) {
          if (state is FetchBranchesLoading ||
              state is FetchDeliveryTypesLoading ||
              state is FetchPaymentMethodsLoading ||
              state is FetchPaymentModesLoading ||
              state is FetchServicesLoading ||
              state is FetchShipmentTypesLoading ||
              state is FetchTransportModesLoading) {
            return _buildLoadingWidget();
          }

          final bool hasAllData = branches.isNotEmpty &&
              deliveryTypes.isNotEmpty &&
              paymentMethods.isNotEmpty &&
              paymentModes.isNotEmpty &&
              services.isNotEmpty &&
              shipmentTypes.isNotEmpty &&
              transportModes.isNotEmpty;

          if (hasAllData) {
            return Scaffold(
              backgroundColor: isDarkMode
                  ? const Color(0xFF5b3895)
                  : const Color(0xFF5b3895),
              appBar: AppBar(
                elevation: 0,
                backgroundColor: isDarkMode
                    ? const Color.fromARGB(255, 75, 23, 160)
                    : const Color.fromARGB(255, 75, 23, 160),
                title: Text(
                  'Add Shipment',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                  onPressed: () {
                    if (_currentPage == 0) {
                      Navigator.pop(context);
                    } else {
                      _previousPage();
                    }
                  },
                ),
              ),
              body: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildStepIndicator(isDarkMode),
                    Expanded(
                      child: PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        onPageChanged: (page) {
                          setState(() => _currentPage = page);
                        },
                        children: [
                          FirstPage(
                            formData: formData1,
                            onNext: _nextPage,
                            branch: branches,
                          ),
                          SecondPage(
                            formData: formData2,
                            onNext: _nextPage,
                            onPrevious: _previousPage,
                            serviceModes: services,
                            shipmentTypes: shipmentTypes,
                          ),
                          ThirdPage(
                            formData: formData3,
                            onPrevious: _previousPage,
                            paymentModes: paymentModes,
                            paymentMethods: paymentMethods,
                            deliveryTypes: deliveryTypes,
                            transportModes: transportModes,
                            onSubmit: () {
                              if (_formKey.currentState!.validate()) {
                                print(formData3);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return _buildLoadingWidget();
        },
      ),
    );
  }
}
