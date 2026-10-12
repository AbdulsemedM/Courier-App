import 'package:courier_app/features/add_shipment/bloc/add_shipment_bloc.dart';
import 'package:courier_app/features/add_shipment/model/branch_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:courier_app/core/theme/app_palette.dart';
import 'package:courier_app/core/utils/ethiopian_phone_normalizer.dart';

class FirstPage extends StatefulWidget {
  final Map<String, dynamic> formData;
  final VoidCallback onNext;
  final List<BranchModel> branch;

  const FirstPage({
    super.key,
    required this.formData,
    required this.onNext,
    required this.branch,
  });

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  String? receiverName;
  String? senderName;
  final TextEditingController _receiverNameController = TextEditingController();
  final TextEditingController _senderNameController = TextEditingController();
  final TextEditingController _receiverMobileController =
      TextEditingController();
  final TextEditingController _senderMobileController = TextEditingController();

  @override
  void initState() {
    super.initState();
    receiverName = widget.formData['receiverName'];
    senderName = widget.formData['senderName'];
    _receiverNameController.text = receiverName ?? '';
    _senderNameController.text = senderName ?? '';
    _receiverMobileController.text =
        widget.formData['receiverMobile']?.toString() ?? '';
    _senderMobileController.text =
        widget.formData['senderMobile']?.toString() ?? '';
  }

  @override
  void dispose() {
    _receiverNameController.dispose();
    _senderNameController.dispose();
    _receiverMobileController.dispose();
    _senderMobileController.dispose();
    super.dispose();
  }

  void _setReceiverMobile(String value) {
    widget.formData['receiverMobile'] = value;
    if (_receiverMobileController.text != value) {
      _receiverMobileController.text = value;
      _receiverMobileController.selection = TextSelection.fromPosition(
        TextPosition(offset: _receiverMobileController.text.length),
      );
    }
  }

  void _setSenderMobile(String value) {
    widget.formData['senderMobile'] = value;
    if (_senderMobileController.text != value) {
      _senderMobileController.text = value;
      _senderMobileController.selection = TextSelection.fromPosition(
        TextPosition(offset: _senderMobileController.text.length),
      );
    }
  }

  String? _canonicalPhoneOrNull(String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      return null;
    }
    try {
      return EthiopianPhoneNormalizer.normalize(raw);
    } catch (_) {
      return EthiopianPhoneNormalizer.toLocal09(raw);
    }
  }

  void _updateReceiverName(String value) {
    setState(() {
      receiverName = value;
      widget.formData['receiverName'] = value;
      _receiverNameController.text = value;
      _receiverNameController.selection = TextSelection.fromPosition(
        TextPosition(offset: _receiverNameController.text.length),
      );
    });
  }

  void _updateSenderName(String value) {
    setState(() {
      senderName = value;
      widget.formData['senderName'] = value;
      _senderNameController.text = value;
      _senderNameController.selection = TextSelection.fromPosition(
        TextPosition(offset: _senderNameController.text.length),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.isDarkMode;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'RECEIVER INFORMATION',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: BrandColors.danger,
            ),
          ),
          const SizedBox(height: 16),
          _buildDropdownField(
            label: 'Receiver Branch',
            value: widget.formData['receiverBranchId']?.toString(),
            items: widget.branch
                .map((branch) => DropdownMenuItem(
                      value: branch.id?.toString(),
                      child: Text(branch.name ?? ''),
                    ))
                .where((item) => item.value != null && item.value!.isNotEmpty)
                .toList(),
            onChanged: (value) {
              if (value != null) {
                final selectedBranch = widget.branch.firstWhere(
                  (b) => b.id?.toString() == value,
                  orElse: () => BranchModel(),
                );
                setState(() {
                  widget.formData['receiverBranchId'] = selectedBranch.id;
                });
              }
            },
            isDarkMode: isDarkMode,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Receiver Mobile',
            controller: _receiverMobileController,
            onChanged: (value) => setState(() {
              widget.formData['receiverMobile'] = value;
            }),
            isDarkMode: isDarkMode,
            keyboardType: TextInputType.phone,
          ),
          ElevatedButton(
            onPressed: () {
              final raw = widget.formData['receiverMobile']?.toString();
              late final String phoneNumber;
              try {
                phoneNumber = EthiopianPhoneNormalizer.normalize(raw ?? '');
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(e.toString()),
                    backgroundColor: BrandColors.danger,
                  ),
                );
                return;
              }
              setState(() => _setReceiverMobile(phoneNumber));
              context.read<AddShipmentBloc>().add(
                    FetchCustomerByPhone(
                      phoneNumber: phoneNumber,
                    ),
                  );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.palette.accent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: BlocBuilder<AddShipmentBloc, AddShipmentState>(
              builder: (context, state) {
                if (state is FetchCustomerByPhoneLoading) {
                  return const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  );
                }
                return const Text('CHECK RECEIVER');
              },
            ),
          ),
          BlocListener<AddShipmentBloc, AddShipmentState>(
            listener: (context, state) {
              if (state is FetchCustomerByPhoneSuccess) {
                final canonical = state.customer.phone ??
                    _canonicalPhoneOrNull(
                        widget.formData['receiverMobile']?.toString());
                if (canonical != null && canonical.isNotEmpty) {
                  _setReceiverMobile(canonical);
                }
                if (state.customer.fullname != null) {
                  _updateReceiverName(state.customer.fullname!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Customer found!'),
                      backgroundColor: BrandColors.success,
                    ),
                  );
                }
              } else if (state is FetchCustomerByPhoneFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage),
                    backgroundColor: BrandColors.danger,
                  ),
                );
              }
            },
            child: const SizedBox.shrink(),
          ),
          const SizedBox(height: 16),
          BlocBuilder<AddShipmentBloc, AddShipmentState>(
            builder: (context, state) {
              if (state is FetchCustomerByPhoneSuccess &&
                  state.customer.fullname != null) {
                _receiverNameController.text = state.customer.fullname!;
              }

              return _buildTextField(
                label: 'Receiver Name',
                controller: _receiverNameController,
                onChanged: _updateReceiverName,
                isDarkMode: isDarkMode,
              );
            },
          ),
          const SizedBox(height: 32),
          Text(
            'SENDER INFORMATION',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: BrandColors.success,
            ),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Sender Mobile',
            controller: _senderMobileController,
            onChanged: (value) => setState(() {
              widget.formData['senderMobile'] = value;
            }),
            isDarkMode: isDarkMode,
            keyboardType: TextInputType.phone,
          ),
          ElevatedButton(
            onPressed: () {
              final raw = widget.formData['senderMobile']?.toString();
              late final String phoneNumber;
              try {
                phoneNumber = EthiopianPhoneNormalizer.normalize(raw ?? '');
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(e.toString()),
                    backgroundColor: BrandColors.danger,
                  ),
                );
                return;
              }
              setState(() => _setSenderMobile(phoneNumber));
              context.read<AddShipmentBloc>().add(
                    FetchSenderByPhone(
                      phoneNumber: phoneNumber,
                    ),
                  );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.palette.accent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: BlocBuilder<AddShipmentBloc, AddShipmentState>(
              builder: (context, state) {
                if (state is FetchSenderByPhoneLoading) {
                  return const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  );
                }
                return const Text('CHECK SENDER');
              },
            ),
          ),
          BlocListener<AddShipmentBloc, AddShipmentState>(
            listener: (context, state) {
              if (state is FetchSenderByPhoneSuccess) {
                final canonical = state.customer.phone ??
                    _canonicalPhoneOrNull(
                        widget.formData['senderMobile']?.toString());
                if (canonical != null && canonical.isNotEmpty) {
                  _setSenderMobile(canonical);
                }
                if (state.customer.fullname != null) {
                  _updateSenderName(state.customer.fullname!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Customer found!'),
                      backgroundColor: BrandColors.success,
                    ),
                  );
                }
              } else if (state is FetchSenderByPhoneFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage),
                    backgroundColor: BrandColors.danger,
                  ),
                );
              }
            },
            child: const SizedBox.shrink(),
          ),
          const SizedBox(height: 16),
          BlocBuilder<AddShipmentBloc, AddShipmentState>(
            builder: (context, state) {
              if (state is FetchSenderByPhoneSuccess &&
                  state.customer.fullname != null) {
                _senderNameController.text = state.customer.fullname!;
              }

              return _buildTextField(
                label: 'Sender Name',
                controller: _senderNameController,
                onChanged: _updateSenderName,
                isDarkMode: isDarkMode,
              );
            },
          ),
          // const SizedBox(height: 16),
          // _buildTextField(
          //   label: 'Sender Name',
          //   value: widget.formData['senderName'],
          //   onChanged: (value) => setState(() {
          //     widget.formData['senderName'] = value;
          //   }),
          //   isDarkMode: isDarkMode,
          // ),
          const SizedBox(height: 16),
          // _buildDropdownField(
          //   label: 'Sender Branch',
          //   value: widget.formData['senderBranchId']?.toString(),
          //   items: widget.branch
          //       .map((branch) => DropdownMenuItem(
          //             value: branch.id?.toString(),
          //             child: Text(branch.name ?? ''),
          //           ))
          //       .where((item) => item.value != null && item.value!.isNotEmpty)
          //       .toList(),
          //   onChanged: (value) {
          //     if (value != null) {
          //       final selectedBranch = widget.branch.firstWhere(
          //         (b) => b.id?.toString() == value,
          //         orElse: () => BranchModel(),
          //       );
          //       setState(() {
          //         widget.formData['senderBranchId'] = selectedBranch.id;
          //       });
          //     }
          //   },
          //   isDarkMode: isDarkMode,
          // ),
          // const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (widget.formData['receiverName'] == null ||
                      widget.formData['receiverName'] == '' ||
                      widget.formData['senderName'] == null ||
                      widget.formData['senderName'] == '' ||
                      widget.formData['receiverBranchId'] == null)
                  ? null
                  : widget.onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkMode
                    ? context.palette.accent
                    : context.palette.accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Next',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    String? value,
    TextEditingController? controller,
    required Function(String) onChanged,
    required bool isDarkMode,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: context.palette.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          initialValue: controller == null ? value : null,
          onChanged: onChanged,
          keyboardType: keyboardType,
          style: TextStyle(
            color: context.palette.textPrimary,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor:
                context.palette.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: context.palette.border,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: context.palette.border,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDarkMode ? BrandColors.info : BrandColors.infoDeep,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            return null;
          },
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
  }) {
    // Ensure value is null if it's not in the available items
    final validValue = items.any((item) => item.value == value) ? value : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: context.palette.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: validValue,
          items: items,
          onChanged: onChanged,
          style: TextStyle(
            color: context.palette.textPrimary,
          ),
          dropdownColor: context.palette.surface,
          decoration: InputDecoration(
            filled: true,
            fillColor:
                context.palette.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: context.palette.border,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: context.palette.border,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDarkMode ? BrandColors.info : BrandColors.infoDeep,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            return null;
          },
        ),
      ],
    );
  }
}
