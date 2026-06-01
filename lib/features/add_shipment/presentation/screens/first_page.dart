import 'package:courier_app/features/add_shipment/bloc/add_shipment_bloc.dart';
import 'package:courier_app/features/add_shipment/model/branch_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:courier_app/core/theme/app_palette.dart';

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
  // String _lastFetchType = ''; // 'receiver' or 'sender'

  @override
  void initState() {
    super.initState();
    receiverName = widget.formData['receiverName'];
    senderName = widget.formData['senderName'];
    _receiverNameController.text = receiverName ?? '';
    _senderNameController.text = senderName ?? '';
  }

  @override
  void dispose() {
    _receiverNameController.dispose();
    _senderNameController.dispose();
    super.dispose();
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
              color: Colors.red[400],
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
            value: widget.formData['receiverMobile'],
            onChanged: (value) => setState(() {
              widget.formData['receiverMobile'] = value;
            }),
            isDarkMode: isDarkMode,
            keyboardType: TextInputType.phone,
          ),
          ElevatedButton(
            onPressed: () {
              final phoneNumber = widget.formData['receiverMobile']?.toString();
              if (phoneNumber == null || phoneNumber.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a phone number'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

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
                if (state.customer.fullname != null) {
                  _updateReceiverName(state.customer.fullname!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Customer found!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } else if (state is FetchCustomerByPhoneFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage),
                    backgroundColor: Colors.red,
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
              color: Colors.green[400],
            ),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Sender Mobile',
            value: widget.formData['senderMobile'],
            onChanged: (value) => setState(() {
              widget.formData['senderMobile'] = value;
            }),
            isDarkMode: isDarkMode,
            keyboardType: TextInputType.phone,
          ),
          ElevatedButton(
            onPressed: () {
              final phoneNumber = widget.formData['senderMobile']?.toString();
              if (phoneNumber == null || phoneNumber.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a phone number'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

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
                if (state.customer.fullname != null) {
                  _updateSenderName(state.customer.fullname!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Customer found!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } else if (state is FetchSenderByPhoneFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage),
                    backgroundColor: Colors.red,
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
                color: isDarkMode ? Colors.blue[400]! : Colors.blue[700]!,
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
                color: isDarkMode ? Colors.blue[400]! : Colors.blue[700]!,
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
