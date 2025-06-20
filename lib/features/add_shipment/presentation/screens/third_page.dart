import 'package:courier_app/configuration/payment_service.dart';
import 'package:courier_app/features/add_shipment/bloc/add_shipment_bloc.dart';
import 'package:courier_app/features/add_shipment/model/delivery_types_model.dart';
import 'package:courier_app/features/add_shipment/model/payment_method_model.dart';
import 'package:courier_app/features/add_shipment/model/payment_mode_model.dart';
import 'package:courier_app/features/add_shipment/model/transport_mode_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme_provider.dart';

class ThirdPage extends StatefulWidget {
  final Map<String, dynamic> formData;
  final VoidCallback onPrevious;
  final VoidCallback onSubmit;
  final Map<String, dynamic> quantity;
  final List<PaymentModeModel> paymentModes;
  final List<PaymentMethodModel> paymentMethods;
  final List<DeliveryTypeModel> deliveryTypes;
  final List<TransportModeModel> transportModes;

  ThirdPage({
    super.key,
    required this.formData,
    required this.onPrevious,
    required this.onSubmit,
    required this.paymentModes,
    required this.paymentMethods,
    required this.deliveryTypes,
    required this.transportModes,
    required this.quantity,
  });
  @override
  State<ThirdPage> createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  var selectedPaymentMode;
  double? rate;

  @override
  Widget build(BuildContext context) {
    final paymentService = Provider.of<PaymentService>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    widget.formData['paymentMethodId'] = widget.paymentMethods[0].id;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total Fee Card
          BlocListener<AddShipmentBloc, AddShipmentState>(
            listenWhen: (previous, current) =>
                current is FetchEstimatedRateSuccess,
            listener: (context, state) {
              if (state is FetchEstimatedRateSuccess) {
                print("estimation received");
                // Optional: You can remove setState() and handle in BlocBuilder instead
              }
            },
            child: BlocBuilder<AddShipmentBloc, AddShipmentState>(
              builder: (context, state) {
                double totalFee = 0;

                if (state is FetchEstimatedRateSuccess) {
                  final rate = state.estimatedRate.rate;
                  final quantity =
                      (widget.quantity['quantity'] as num?)?.toDouble() ?? 1.0;
                  totalFee = rate * quantity;
                }

                return Center(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 5),
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple[600],
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Total Fee',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${totalFee.toStringAsFixed(2)} ETB",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
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
                color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
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
                            child: Text(mode.code ?? mode.description ?? ''),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        final selectedMode = widget.paymentModes.firstWhere(
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
                selectedPaymentMode == 'CASH' || selectedPaymentMode == 'CREDIT'
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
                            setState(() {
                              widget.formData['paymentMethodId'] =
                                  int.parse(value); // Store the ID
                              final selectedMethod = widget.paymentMethods
                                  .firstWhere(
                                      (method) =>
                                          method.id?.toString() == value,
                                      orElse: () => PaymentMethodModel());
                              paymentService
                                  .setPaymentMethod(selectedMethod.method!);
                              // print(selectedMethod.method);
                              // print(widget.formData['paymentMethodId']);
                              // selectedPaymentMethod = selectedMethod.description;
                            });
                          }
                        },
                        isDarkMode: isDarkMode,
                        icon: Icons.account_balance_wallet,
                      )
                    : const SizedBox(height: 0),
                selectedPaymentMode == 'CASH' || selectedPaymentMode == 'CREDIT'
                    ? const SizedBox(height: 24)
                    : const SizedBox(height: 0),
                _buildDropdownField(
                  label: 'Delivery Type',
                  value: widget.deliveryTypes[0].id?.toString(),
                  items: widget.deliveryTypes
                      .map((type) => DropdownMenuItem(
                            value: type.id?.toString(),
                            child: Text(type.type ?? ''),
                          ))
                      .toList(),
                  onChanged: (value) {
                    print(value);
                    if (value != null) {
                      setState(() {
                        widget.formData['deliveryTypeId'] =
                            int.parse(value); // Store the ID
                        // final selectedType = widget.deliveryTypes.firstWhere(
                        //   (type) => type.description?.toString() == value,
                        //   orElse: () => DeliveryTypeModel(),
                        // );
                      });
                    }
                  },
                  isDarkMode: isDarkMode,
                  icon: Icons.local_shipping,
                ),
                const SizedBox(height: 24),
                _buildDropdownField(
                  label: 'Transport Mode',
                  value: widget.transportModes[0].id?.toString(),
                  items: widget.transportModes
                      .map((mode) => DropdownMenuItem(
                            value: mode.id?.toString(),
                            child: Text(mode.description ?? ''),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        widget.formData['transportModeId'] =
                            int.parse(value); // Store the ID
                      });
                    }
                  },
                  isDarkMode: isDarkMode,
                  icon: Icons.directions_bus,
                ),
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
                      color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
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
                    backgroundColor:
                        isDarkMode ? Colors.grey[800] : Colors.grey[200],
                    foregroundColor: isDarkMode ? Colors.white : Colors.black87,
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
                child: ElevatedButton.icon(
                  onPressed: (widget.formData['paymentModeId'] == null ||
                          widget.formData['paymentModeId'] == '' ||
                          // widget.formData['deliveryTypeId'] == null ||
                          widget.formData['deliveryTypeId'] == '' ||
                          widget.formData['transportModeId'] == null ||
                          widget.formData['transportModeId'] == '')
                      ? null
                      :
                      // print(widget.quantity['quantity']);
                      widget.onSubmit,
                  icon: const Icon(Icons.check_circle),
                  label: const Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isDarkMode ? Colors.green[700] : Colors.green,
                    foregroundColor: Colors.white,
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
            ],
          ),
        ],
      ),
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
