import 'package:courier_app/configuration/auth_service.dart';
import 'package:courier_app/configuration/payment_service.dart';
import 'package:courier_app/features/add_shipment/bloc/add_shipment_bloc.dart';
import 'package:courier_app/features/add_shipment/model/branch_model.dart';
import 'package:courier_app/features/add_shipment/model/delivery_types_model.dart';
import 'package:courier_app/features/add_shipment/model/payment_method_model.dart';
import 'package:courier_app/features/add_shipment/model/payment_mode_model.dart';
import 'package:courier_app/features/add_shipment/model/service_modes_model.dart';
import 'package:courier_app/features/add_shipment/model/shipment_type_model.dart';
import 'package:courier_app/features/add_shipment/model/transport_mode_model.dart';
import 'package:courier_app/features/add_shipment/presentation/screens/payment_screen.dart';
import 'package:courier_app/features/home_screen/presentation/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme_provider.dart';
import 'first_page.dart';
import 'second_page.dart';
import 'third_page.dart';

//////////ETAA73844Shipment
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
    "senderName": null,
    "senderMobile": null,
    "receiverName": null,
    "receiverMobile": null,
    "senderBranchId": null,
    "receiverBranchId": null,
  };
  final Map<String, dynamic> formData2 = {
    "shipmentDescription": null,
    "shipmentTypeId": null,
    "quantity": 1,
    "unit": null,
    // "netFee": 1,
    "numPcs": 0,
    "numBoxes": 0,
    // "rate": 0,
    "rate": 0,
    "serviceModeId": null,
    "extraFee": 0,
    "extraFeeDescription": "null",
  };
  final authService = AuthService();
  final Map<String, dynamic> formData3 = {
    // "paymentMethodId": 1,
    "deliveryTypeId": "",
    "transportModeId": "",
    "hudhudPercent": 10.5,
    "hudhudNet": 95.75,
    "creditAccount": "",
    "paymentModeId": "",
    "paymentMethodId": "",
    "addedBy": "",
  };
  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
    if (_currentPage == 0) {
      final bloc = context.read<AddShipmentBloc>();
      bloc.add(FetchEstimatedRate(
          originId: formData1['senderBranchId'],
          destinationId: formData1['receiverBranchId']));
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
    _initializeUserId();
    _fetchAllData(false);
  }

  Future<void> _initializeUserId() async {
    final userId = await authService.getUserId();
    final branch = await authService.getBranch();
    setState(() {
      formData3['addedBy'] = int.parse(userId.toString());
      formData1['senderBranchId'] = int.parse(branch.toString());
    });
  }

  Future<void> _fetchAllData(bool sync) async {
    try {
      // Fetch data in batches to avoid overwhelming the server
      // Batch 1: Essential data
      final bloc = context.read<AddShipmentBloc>();
      bloc.add(FetchBranches(sync));
      bloc.add(FetchDeliveryTypes(sync));

      // Small delay between batches
      await Future.delayed(const Duration(milliseconds: 500));
      // Batch 2: Payment related data
      // final bloc = context.read<AddShipmentBloc>();
      bloc.add(FetchPaymentMethods(sync));
      bloc.add(FetchPaymentModes(sync));

      // Small delay between batches
      await Future.delayed(const Duration(milliseconds: 500));
      // Batch 3: Shipment related data
      bloc.add(FetchServices(sync));
      bloc.add(FetchShipmentTypes(sync));
      bloc.add(FetchTransportModes(sync));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading data: ${e.toString()}'),
          action: SnackBarAction(
            label: 'Retry',
            onPressed: () => _fetchAllData(false),
          ),
        ),
      );
    }
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
                  onPressed: () => _fetchAllData(false),
                ),
              ),
            );
          },
        ),
        BlocListener<AddShipmentBloc, AddShipmentState>(
          listenWhen: (previous, current) => current is AddShipmentSuccess,
          listener: (context, state) {
            if (state is AddShipmentSuccess) {
              final Map<String, dynamic> completeFormData = {
                ...formData1,
                ...formData2,
                ...formData3,
              };
              final paymentService =
                  Provider.of<PaymentService>(context, listen: false);
              String info = paymentService.paymentInfo;
              if (info != "CASH ON DELIVERY") {
                String method = paymentService.paymentMethod;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentScreen(
                      formData: completeFormData,
                      trackingNumber: state.trackingNumber,
                      paymentInfo: method,
                    ),
                  ),
                );
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              }
            } else if (state is AddShipmentFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage.toString())),
              );
            }
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
                actions: [
                  IconButton(
                    icon: Icon(Icons.sync),
                    onPressed: () => _fetchAllData(true),
                  ),
                ],
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
                            quantity: formData2,
                            onSubmit: () {
                              if (_formKey.currentState!.validate()) {
                                final Map<String, dynamic> completeFormData = {
                                  ...formData1,
                                  ...formData2,
                                  ...formData3,
                                };
                                print(completeFormData);
                                context
                                    .read<AddShipmentBloc>()
                                    .add(AddShipment(body: completeFormData));
                              } else {}
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

  void _handlePaymentInfo(String info) {
    // Use Provider.of with listen: false for event handlers
    Provider.of<PaymentService>(context, listen: false).setPaymentInfo(info);
  }

  void _handlePaymentMethod(String method) {
    // Use Provider.of with listen: false for event handlers
    Provider.of<PaymentService>(context, listen: false)
        .setPaymentMethod(method);
  }
}
