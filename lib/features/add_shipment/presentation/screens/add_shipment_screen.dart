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
import 'package:courier_app/features/add_shipment/presentation/screens/payment_waiting_screen.dart';
import 'package:courier_app/features/add_shipment/presentation/screens/print_shipment_screen.dart';
// import 'package:courier_app/features/home_screen/presentation/screen/home_screen.dart';
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
    "deliveryTypeId": null,
    "transportModeId": null,
  };
  final authService = AuthService();
  final Map<String, dynamic> formData3 = {
    // "paymentMethodId": 1,
    "hudhudPercent": 10.5,
    "hudhudNet": 95.75,
    "creditAccount": "",
    "creditAmount": 0.0,
    "paymentModeId": "",
    "paymentMethodId": "",
    "payerAccount": "",
    "addedBy": "",
  };
  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onPageChanged(int page) {
    setState(() => _currentPage = page);
    // Fetch rate when user moves to step 3 (page 2) after completing all fields in step 2
    if (page == 2) {
      final bloc = context.read<AddShipmentBloc>();
      // Get unit from formData2 and convert to lowercase
      final unit = (formData2['unit'] as String?)?.toLowerCase() ?? 'kg';
      bloc.add(FetchEstimatedRate(
        originId: formData1['senderBranchId'] as int,
        destinationId: formData1['receiverBranchId'] as int,
        serviceModeId: formData2['serviceModeId'] as int,
        shipmentTypeId: formData2['shipmentTypeId'] as int,
        deliveryTypeId: formData2['deliveryTypeId'] as int,
        unit: unit,
      ));
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
    final steps = [
      'Sender & Receiver',
      'Shipment Details',
      'Payment',
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      color: isDarkMode ? const Color(0xFF5b3895) : Colors.white,
      child: Row(
        children: List.generate(3, (index) {
          final isActive = index == _currentPage;
          final isCompleted = index < _currentPage;

          return Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Step Circle
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.blue
                        : (isCompleted
                            ? const Color(0xFFFF5A00)
                            : Colors.grey[300]),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                // Step Label - Flexible to prevent overflow
                Flexible(
                  child: Text(
                    steps[index],
                    style: TextStyle(
                      color: isActive
                          ? (isDarkMode ? Colors.white : Colors.black87)
                          : (isCompleted
                              ? const Color(0xFFFF5A00)
                              : (isDarkMode
                                  ? Colors.grey[400]
                                  : Colors.grey[600])),
                      fontSize: 12,
                      fontWeight:
                          isActive ? FontWeight.w600 : FontWeight.normal,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                // Connecting Line
                if (index < 2)
                  Expanded(
                    child: Container(
                      height: 2,
                      margin: const EdgeInsets.only(left: 6, right: 6, top: 16),
                      decoration: BoxDecoration(
                        color: isCompleted || (index < _currentPage)
                            ? const Color(0xFFFF5A00)
                            : Colors.grey[300],
                      ),
                    ),
                  ),
              ],
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
            String errorMessage = '';
            if (state is FetchBranchesFailure) {
              errorMessage = state.errorMessage;
            } else if (state is FetchDeliveryTypesFailure) {
              errorMessage = state.errorMessage;
            } else if (state is FetchPaymentMethodsFailure) {
              errorMessage = state.errorMessage;
            } else if (state is FetchPaymentModesFailure) {
              errorMessage = state.errorMessage;
            } else if (state is FetchServicesFailure) {
              errorMessage = state.errorMessage;
            } else if (state is FetchShipmentTypesFailure) {
              errorMessage = state.errorMessage;
            } else if (state is FetchTransportModesFailure) {
              errorMessage = state.errorMessage;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: $errorMessage'),
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

              // Use Future.microtask to ensure navigation happens after the current frame
              Future.microtask(() async {
                // Check if the widget is still mounted before navigating
                if (!mounted) return;

                if (info == "CASH") {
                  final paymentMethod = paymentService.paymentMethod;

                  // Check if both payment mode and payment method are CASH
                  final isPaymentMethodCash = paymentMethod.isNotEmpty &&
                      paymentMethod.toUpperCase() == "CASH";

                  // If both are CASH, skip waiting screen and go directly to print screen
                  if (isPaymentMethodCash) {
                    if (!mounted) return;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PrintShipmentScreen(
                          trackingNumber: state.trackingNumber,
                        ),
                      ),
                    );
                    return;
                  }

                  // Get payerAccount with fallback priority: payerAccount -> creditAccount -> senderMobile
                  // Use completeFormData to ensure we have the merged data
                  String payerAccount = '';
                  if (completeFormData['payerAccount']?.toString().isNotEmpty ==
                      true) {
                    payerAccount = completeFormData['payerAccount']!.toString();
                  } else if (completeFormData['senderMobile']
                          ?.toString()
                          .isNotEmpty ==
                      true) {
                    payerAccount = completeFormData['senderMobile']!.toString();
                  }

                  final userId = await authService.getUserId();
                  final addedBy = formData3['addedBy'] as int? ??
                      int.parse(userId.toString());

                  if (!mounted) return;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentWaitingScreen(
                        trackingNumber: state.trackingNumber,
                        branches: branches,
                        paymentMethod: paymentMethod.isNotEmpty
                            ? paymentMethod
                            : 'EBIRRCOOP',
                        payerAccount: payerAccount,
                        addedBy: addedBy,
                      ),
                    ),
                  );
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PrintShipmentScreen(
                        trackingNumber: state.trackingNumber,
                      ),
                    ),
                  );
                }
              });
            } else if (state is AddShipmentFailure) {
              if (!mounted) return;
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
                        onPageChanged: _onPageChanged,
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
                            deliveryTypes: deliveryTypes,
                            transportModes: transportModes,
                          ),
                          ThirdPage(
                            formData: formData3,
                            onPrevious: _previousPage,
                            paymentModes: paymentModes,
                            paymentMethods: paymentMethods,
                            quantity: formData2,
                            formData1: formData1,
                            onSubmit: () {
                              print('[UI] Submit button pressed on step 3');
                              print('[UI] Form validation started');
                              if (_formKey.currentState!.validate()) {
                                print('[UI] Form validation passed');
                                print('[UI] formData1: $formData1');
                                print('[UI] formData2: $formData2');
                                print('[UI] formData3: $formData3');
                                final Map<String, dynamic> completeFormData = {
                                  ...formData1,
                                  ...formData2,
                                  ...formData3,
                                };
                                print(
                                    '[UI] Complete form data: $completeFormData');
                                print(
                                    '[UI] Dispatching AddShipment event to bloc');
                                context
                                    .read<AddShipmentBloc>()
                                    .add(AddShipment(body: completeFormData));
                                print('[UI] AddShipment event dispatched');
                              } else {
                                print('[UI] Form validation failed');
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
