import 'package:courier_app/configuration/payment_service.dart';
import 'package:courier_app/features/add_shipment/bloc/add_shipment_bloc.dart';
import 'package:courier_app/features/add_shipment/model/estimated_rate_model.dart';
import 'package:courier_app/features/add_shipment/model/payment_method_model.dart';
import 'package:courier_app/features/add_shipment/model/payment_mode_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme_provider.dart';

class ThirdPage extends StatefulWidget {
  final Map<String, dynamic> formData;
  final VoidCallback onPrevious;
  final VoidCallback onSubmit;
  final Map<String, dynamic> quantity;
  final Map<String, dynamic> formData1;
  final List<PaymentModeModel> paymentModes;
  final List<PaymentMethodModel> paymentMethods;

  ThirdPage({
    super.key,
    required this.formData,
    required this.onPrevious,
    required this.onSubmit,
    required this.paymentModes,
    required this.paymentMethods,
    required this.quantity,
    required this.formData1,
  });
  @override
  State<ThirdPage> createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  var selectedPaymentMode;
  double? rate;
  EstimatedRateModel? cachedEstimatedRate;

  @override
  Widget build(BuildContext context) {
    final paymentService = Provider.of<PaymentService>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    // widget.formData['paymentMethodId'] = widget.paymentMethods[0].id;
    return BlocBuilder<AddShipmentBloc, AddShipmentState>(
      builder: (context, state) {
        final isLoading = state is AddShipmentLoading;
        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Total Fee Card with Discount
                  BlocListener<AddShipmentBloc, AddShipmentState>(
                    listenWhen: (previous, current) =>
                        current is FetchEstimatedRateSuccess,
                    listener: (context, state) {
                      if (state is FetchEstimatedRateSuccess) {
                        print("estimation received");
                        // Cache the estimated rate
                        setState(() {
                          cachedEstimatedRate = state.estimatedRate;
                        });
                        // Trigger discount check after rate is fetched
                        final bloc = context.read<AddShipmentBloc>();
                        final estimatedRate = state.estimatedRate;
                        final quantity =
                            (widget.quantity['quantity'] as num?)?.toDouble() ??
                                1.0;
                        final unit = (widget.quantity['unit'] as String?)
                                ?.toLowerCase() ??
                            'kg';

                        // Use discountPricePerKg from rate (could be silverPrice, goldPrice, or platinumPrice)
                        // For now, using the base rate as discountPricePerKg
                        // You can modify this to use silverPrice, goldPrice, or platinumPrice based on your logic
                        final discountPricePerKg = estimatedRate.rate;

                        bloc.add(CheckDiscount(
                          originId: widget.formData1['senderBranchId'] as int,
                          destinationId:
                              widget.formData1['receiverBranchId'] as int,
                          serviceModeId:
                              widget.quantity['serviceModeId'] as int,
                          shipmentTypeId:
                              widget.quantity['shipmentTypeId'] as int,
                          deliveryTypeId:
                              widget.quantity['deliveryTypeId'] as int,
                          unit: unit,
                          weightKg: quantity,
                          discountPricePerKg: discountPricePerKg,
                        ));
                      }
                    },
                    child: BlocBuilder<AddShipmentBloc, AddShipmentState>(
                      buildWhen: (previous, current) =>
                          current is FetchEstimatedRateSuccess ||
                          current is FetchEstimatedRateLoading ||
                          current is FetchEstimatedRateFailure ||
                          current is CheckDiscountSuccess ||
                          current is CheckDiscountLoading ||
                          current is CheckDiscountFailure,
                      builder: (context, state) {
                        double totalFee = 0;
                        double originalTotal = 0;
                        double discountAmount = 0;
                        double discountPercentage = 0;
                        bool hasDiscount = false;

                        // Get rate from state or cached value
                        EstimatedRateModel? estimatedRate;
                        if (state is FetchEstimatedRateSuccess) {
                          estimatedRate = state.estimatedRate;
                          // Update cache
                          cachedEstimatedRate = estimatedRate;
                        } else if (cachedEstimatedRate != null) {
                          // Use cached rate if state changed to discount check
                          estimatedRate = cachedEstimatedRate;
                        }

                        // Calculate base total from rate
                        if (estimatedRate != null) {
                          final rate = estimatedRate.rate;
                          final quantity = (widget.quantity['quantity'] as num?)
                                  ?.toDouble() ??
                              1.0;
                          totalFee = rate * quantity;
                          originalTotal = totalFee;
                        }

                        // Override with discount if available
                        if (state is CheckDiscountSuccess) {
                          hasDiscount = true;
                          originalTotal = state.discount.originalTotal;
                          discountAmount = state.discount.discountAmount;
                          discountPercentage =
                              state.discount.discountPercentage;
                          totalFee = state.discount.discountedTotal;
                        }

                        return Column(
                          children: [
                            // Discount Info Card (if discount exists)
                            if (hasDiscount)
                              Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.green[400]!,
                                      Colors.green[600]!,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.green.withOpacity(0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.local_offer,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Discount Applied!',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Original Total:',
                                          style: TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.9),
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          "${originalTotal.toStringAsFixed(2)} ETB",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Discount:',
                                          style: TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.9),
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          "-${discountAmount.toStringAsFixed(2)} ETB (${discountPercentage.toStringAsFixed(1)}%)",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            // Total Fee Card
                            Center(
                              child: Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(bottom: 5),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 16),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.deepPurple[600]!,
                                      Colors.deepPurple[800]!,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.15),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      hasDiscount ? 'Final Total' : 'Total Fee',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    if (state is FetchEstimatedRateLoading)
                                      const SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Colors.white,
                                          ),
                                          strokeWidth: 3,
                                        ),
                                      )
                                    else
                                      Text(
                                        "${totalFee.toStringAsFixed(2)} ETB",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 2,
                                        ),
                                      ),
                                    if (hasDiscount)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          "You saved ${discountAmount.toStringAsFixed(2)} ETB!",
                                          style: TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.9),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
// Shipment Information Section
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? const Color(0xFF1A1F37).withOpacity(0.5)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color:
                            isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.local_shipping_outlined,
                              color: Colors.red[400],
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'SHIPMENT INFORMATION',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.red[400],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildDropdownField(
                          label: 'Payment Mode',
                          value: widget.paymentModes[0].id?.toString(),
                          items: widget.paymentModes
                              .map((mode) => DropdownMenuItem(
                                    value: mode.code?.toString(),
                                    child: Text(
                                        mode.code ?? mode.description ?? ''),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                final selectedMode =
                                    widget.paymentModes.firstWhere(
                                  (mode) => mode.code?.toString() == value,
                                  orElse: () => PaymentModeModel(),
                                );
                                selectedPaymentMode = selectedMode.code;
                                widget.formData['paymentModeId'] =
                                    selectedMode.id; // Store the ID
                                print(selectedMode.description);
                                paymentService
                                    .setPaymentInfo(selectedMode.description!);
                              });
                            }
                          },
                          isDarkMode: isDarkMode,
                          icon: Icons.payment,
                        ),
                        const SizedBox(height: 24),
                        // Show payment method selector only for CASH mode
                        selectedPaymentMode == 'CASH'
                            ? _buildDropdownField(
                                label: 'Payment Method',
                                value: null,
                                items: widget.paymentMethods
                                    .map((method) => DropdownMenuItem(
                                          value: method.id?.toString(),
                                          child: Text(method.method ?? ''),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    print(value);
                                    setState(() {
                                      widget.formData['paymentMethodId'] =
                                          int.parse(value); // Store the ID
                                      final selectedMethod =
                                          widget.paymentMethods.firstWhere(
                                              (method) =>
                                                  method.id?.toString() ==
                                                  value,
                                              orElse: () =>
                                                  PaymentMethodModel());
                                      paymentService.setPaymentMethod(
                                          selectedMethod.method!);
                                      print(selectedMethod.id);
                                      // print(widget.formData['paymentMethodId']);
                                      // selectedPaymentMethod = selectedMethod.description;
                                    });
                                  }
                                },
                                isDarkMode: isDarkMode,
                                icon: Icons.account_balance_wallet,
                              )
                            : const SizedBox(height: 0),
                        // Show credit amount field for CREDIT mode
                        selectedPaymentMode == 'CREDIT'
                            ? _buildTextField(
                                label: 'Credit Amount',
                                value: widget.formData['creditAmount']
                                        ?.toString() ??
                                    '',
                                onChanged: (value) {
                                  setState(() {
                                    widget.formData['creditAmount'] =
                                        double.tryParse(value) ?? 0.0;
                                  });
                                },
                                isDarkMode: isDarkMode,
                                keyboardType: TextInputType.number,
                                hintText: 'Enter credit amount',
                                icon: Icons.attach_money,
                              )
                            : const SizedBox(height: 0),
                        // Add spacing only if CASH or CREDIT mode is selected
                        (selectedPaymentMode == 'CASH' ||
                                selectedPaymentMode == 'CREDIT')
                            ? const SizedBox(height: 24)
                            : const SizedBox(height: 0),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Credit Account Section
                  selectedPaymentMode == 'CREDIT'
                      ? Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? const Color(0xFF1A1F37).withOpacity(0.5)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDarkMode
                                  ? Colors.grey[800]!
                                  : Colors.grey[200]!,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.account_balance,
                                    color: isDarkMode
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
                                    size: 24,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Credit Account',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: isDarkMode
                                          ? Colors.grey[400]
                                          : Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              _buildTextField(
                                label: 'Credit Account',
                                value: widget.formData['creditAccount'] ?? '',
                                onChanged: (value) => setState(() {
                                  widget.formData['creditAccount'] = value;
                                }),
                                isDarkMode: isDarkMode,
                                hintText: 'Type something...',
                                icon: Icons.credit_card,
                              ),
                              const SizedBox(height: 24),
                              //     _buildTextField(
                              //       label: 'Hudhud Percent',
                              //       value: formData['hudhudPercent']?.toString() ?? '',
                              //       onChanged: (value) =>
                              //           formData['hudhudPercent'] = double.tryParse(value) ?? 0.0,
                              // isDarkMode: isDarkMode,
                              //       keyboardType: TextInputType.number,
                              //       icon: Icons.percent,
                              //     ),
                              //     const SizedBox(height: 24),
                              //     _buildTextField(
                              //       label: 'HudHudNet',
                              //       value: formData['hudHudNet']?.toString() ?? '',
                              //       onChanged: (value) =>
                              //           formData['hudHudNet'] = double.tryParse(value) ?? 0.0,
                              // isDarkMode: isDarkMode,
                              //       keyboardType: TextInputType.number,
                              //       icon: Icons.attach_money,
                              //     ),
                            ],
                          ))
                      : const SizedBox(height: 0),
                  const SizedBox(height: 40),
                  // Navigation Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: widget.onPrevious,
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Previous'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDarkMode
                                ? Colors.grey[800]
                                : Colors.grey[200],
                            foregroundColor:
                                isDarkMode ? Colors.white : Colors.black87,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: BlocBuilder<AddShipmentBloc, AddShipmentState>(
                          builder: (context, state) {
                            final isLoading = state is AddShipmentLoading;
                            final isDisabled =
                                widget.formData['paymentModeId'] == null ||
                                    widget.formData['paymentModeId'] == '' ||
                                    isLoading;

                            return ElevatedButton.icon(
                              onPressed: isDisabled ? null : widget.onSubmit,
                              icon: isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    )
                                  : const Icon(Icons.check_circle),
                              label:
                                  Text(isLoading ? 'Submitting...' : 'Submit'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isDarkMode
                                    ? Colors.green[700]
                                    : Colors.green,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildTextField({
    required String label,
    required String value,
    required Function(String) onChanged,
    required bool isDarkMode,
    TextInputType? keyboardType,
    String? hintText,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: value,
          onChanged: onChanged,
          keyboardType: keyboardType,
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black87,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
            ),
            filled: true,
            fillColor: isDarkMode ? const Color(0xFF1A1F37) : Colors.white,
            prefixIcon: icon != null
                ? Icon(
                    icon,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDarkMode ? Colors.blue[400]! : Colors.blue[700]!,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required Function(String?) onChanged,
    required bool isDarkMode,
    IconData? icon,
  }) {
    // Ensure value is null if it's empty or not in the valid items list
    // final validValue =
    //     value?.isNotEmpty == true && items.any((item) => item.value == value)
    //         ? value
    //         : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          // value: validValue, // Use validated value
          items: items,
          onChanged: onChanged,
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black87,
            fontSize: 16,
          ),
          icon: const Icon(Icons.arrow_drop_down_circle_outlined),
          dropdownColor: isDarkMode ? const Color(0xFF1A1F37) : Colors.white,
          decoration: InputDecoration(
            filled: true,
            fillColor: isDarkMode ? const Color(0xFF1A1F37) : Colors.white,
            prefixIcon: icon != null
                ? Icon(
                    icon,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDarkMode ? Colors.blue[400]! : Colors.blue[700]!,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
