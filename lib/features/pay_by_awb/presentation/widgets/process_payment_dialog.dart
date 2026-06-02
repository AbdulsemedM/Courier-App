import 'package:courier_app/core/theme/app_palette.dart';
import 'package:courier_app/features/add_shipment/bloc/add_shipment_bloc.dart';
import 'package:courier_app/features/add_shipment/model/payment_method_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProcessPaymentResult {
  final String paymentMethod;
  final String payerAccount;

  const ProcessPaymentResult({
    required this.paymentMethod,
    required this.payerAccount,
  });
}

bool processPaymentRequiresPayerAccount(String method) {
  return method.trim().toUpperCase() != 'CASH';
}

Future<ProcessPaymentResult?> showProcessPaymentDialog({
  required BuildContext context,
  required String awb,
}) {
  return showDialog<ProcessPaymentResult>(
    context: context,
    barrierDismissible: false,
    builder: (_) => ProcessPaymentDialog(awb: awb),
  );
}

class ProcessPaymentDialog extends StatefulWidget {
  final String awb;

  const ProcessPaymentDialog({super.key, required this.awb});

  @override
  State<ProcessPaymentDialog> createState() => _ProcessPaymentDialogState();
}

class _ProcessPaymentDialogState extends State<ProcessPaymentDialog> {
  static final _palette = AppPalette.light;
  static const _accent = Color(0xFF5B3895);
  static const _fieldFill = Color(0xFFF3F4F6);

  final TextEditingController _payerPhoneController = TextEditingController();
  List<PaymentMethodModel> _methods = [];
  String? _selectedMethod;
  bool _requestedMethods = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _ensurePaymentMethods());
  }

  @override
  void dispose() {
    _payerPhoneController.dispose();
    super.dispose();
  }

  void _ensurePaymentMethods() {
    if (_requestedMethods) return;
    _requestedMethods = true;

    final bloc = context.read<AddShipmentBloc>();
    final state = bloc.state;
    if (state is FetchPaymentMethodsSuccess &&
        state.paymentMethods.isNotEmpty) {
      _applyMethods(state.paymentMethods);
      return;
    }

    bloc.add(FetchPaymentMethods(false));
  }

  void _applyMethods(List<PaymentMethodModel> methods) {
    final usable = methods
        .where((m) => m.method != null && m.method!.trim().isNotEmpty)
        .toList();
    if (usable.isEmpty) return;

    setState(() {
      _methods = usable;
      _selectedMethod ??= _defaultMethod(usable);
    });
  }

  String _defaultMethod(List<PaymentMethodModel> methods) {
    for (final method in methods) {
      if (method.method?.trim().toUpperCase() == 'CASH') {
        return method.method!.trim();
      }
    }
    return methods.first.method!.trim();
  }

  InputDecoration _fieldDecoration({required String label}) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: _palette.textSecondary,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      floatingLabelStyle: TextStyle(
        color: _palette.textSecondary,
        fontSize: 13,
      ),
      filled: true,
      fillColor: _fieldFill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _palette.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _palette.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _accent, width: 1.5),
      ),
    );
  }

  void _onPayNow() {
    final method = _selectedMethod?.trim();
    if (method == null || method.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a payment method.')),
      );
      return;
    }

    var payerAccount = '';
    if (processPaymentRequiresPayerAccount(method)) {
      payerAccount = _payerPhoneController.text.trim();
      if (payerAccount.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter payer phone number.'),
          ),
        );
        return;
      }
    }

    Navigator.of(context).pop(
      ProcessPaymentResult(
        paymentMethod: method,
        payerAccount: payerAccount,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddShipmentBloc, AddShipmentState>(
      listenWhen: (previous, current) =>
          current is FetchPaymentMethodsSuccess ||
          current is FetchPaymentMethodsFailure,
      listener: (context, state) {
        if (state is FetchPaymentMethodsSuccess) {
          _applyMethods(state.paymentMethods);
        } else if (state is FetchPaymentMethodsFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        }
      },
      child: Dialog(
        backgroundColor: _palette.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Process Payment',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: _palette.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'AWB: ${widget.awb}',
                  style: TextStyle(
                    fontSize: 14,
                    color: _palette.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                BlocBuilder<AddShipmentBloc, AddShipmentState>(
                  buildWhen: (previous, current) =>
                      current is FetchPaymentMethodsLoading ||
                      current is FetchPaymentMethodsSuccess ||
                      current is FetchPaymentMethodsFailure,
                  builder: (context, state) {
                    if (state is FetchPaymentMethodsLoading &&
                        _methods.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 32),
                        child: Center(
                          child: CircularProgressIndicator(color: _accent),
                        ),
                      );
                    }

                    if (_methods.isEmpty) {
                      return Text(
                        'No payment methods available.',
                        style: TextStyle(color: _palette.textSecondary),
                      );
                    }

                    final showPhone = _selectedMethod != null &&
                        processPaymentRequiresPayerAccount(_selectedMethod!);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        DropdownButtonFormField<String>(
                          value: _selectedMethod,
                          isExpanded: true,
                          dropdownColor: _palette.surface,
                          style: TextStyle(
                            color: _palette.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          iconEnabledColor: _palette.textSecondary,
                          decoration: _fieldDecoration(label: 'Payment Method'),
                          items: _methods.map((method) {
                            final code = method.method!.trim();
                            return DropdownMenuItem<String>(
                              value: code,
                              child: Text(
                                code,
                                style: TextStyle(
                                  color: _palette.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedMethod = value;
                              if (value != null &&
                                  !processPaymentRequiresPayerAccount(
                                      value)) {
                                _payerPhoneController.clear();
                              }
                            });
                          },
                        ),
                        if (showPhone) ...[
                          const SizedBox(height: 16),
                          TextField(
                            controller: _payerPhoneController,
                            keyboardType: TextInputType.phone,
                            style: TextStyle(
                              color: _palette.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: _fieldDecoration(
                              label: 'Payer phone number',
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        foregroundColor: _accent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _methods.isEmpty ? null : _onPayNow,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _accent,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: _palette.border,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text(
                        'Pay Now',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
