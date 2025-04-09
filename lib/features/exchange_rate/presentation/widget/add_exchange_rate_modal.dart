import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../currency/bloc/currency_bloc.dart';
import '../../bloc/exchange_rate_bloc.dart';
import '../../../../configuration/auth_service.dart';

class AddExchangeRateModal extends StatefulWidget {
  const AddExchangeRateModal({super.key});

  @override
  State<AddExchangeRateModal> createState() => _AddExchangeRateModalState();
}

class _AddExchangeRateModalState extends State<AddExchangeRateModal> {
  final _formKey = GlobalKey<FormState>();
  String? _fromCurrencyId;
  String? _toCurrencyId;
  final _factorController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    context.read<CurrencyBloc>().add(FetchCurrencies());
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<ExchangeRateBloc, ExchangeRateState>(
      listener: (context, state) {
        if (state is AddExchangeRateSuccess) {
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Exchange rate added successfully'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is AddExchangeRateFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Dialog(
        backgroundColor: isDarkMode ? const Color(0xFF1A1C2E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 400),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Exchange Rate',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 24),
                BlocBuilder<CurrencyBloc, CurrencyState>(
                  builder: (context, state) {
                    if (state is FetchCurrencySuccess) {
                      return Column(
                        children: [
                          DropdownButtonFormField<String>(
                            value: _fromCurrencyId,
                            decoration: InputDecoration(
                              labelText: 'From Currency',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            items: state.currencies.map((currency) {
                              return DropdownMenuItem(
                                value: currency.id.toString(),
                                child: Text(currency.code),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _fromCurrencyId = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a currency';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: _toCurrencyId,
                            decoration: InputDecoration(
                              labelText: 'To Currency',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            items: state.currencies.map((currency) {
                              return DropdownMenuItem(
                                value: currency.id.toString(),
                                child: Text(currency.code),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _toCurrencyId = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a currency';
                              }
                              return null;
                            },
                          ),
                        ],
                      );
                    }
                    return const CircularProgressIndicator();
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _factorController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Factor',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter factor';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed:
                          _isLoading ? null : () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    BlocBuilder<ExchangeRateBloc, ExchangeRateState>(
                      builder: (context, state) {
                        _isLoading = state is AddExchangeRateLoading;

                        return ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : () async {
                                  if (_formKey.currentState!.validate()) {
                                    final authService = AuthService();
                                    final exchangeRate = {
                                      'fromCurrencyId': int.parse(_fromCurrencyId!),
                                      'toCurrencyId': int.parse(_toCurrencyId!),
                                      'factor':
                                          double.parse(_factorController.text),
                                      'addedBy': await authService.getUserId(),
                                    };
                                    context.read<ExchangeRateBloc>().add(
                                          AddExchangeRate(
                                              exchangeRate: exchangeRate),
                                        );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Submit'),
                        );
                      },
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

  @override
  void dispose() {
    _factorController.dispose();
    super.dispose();
  }
}
