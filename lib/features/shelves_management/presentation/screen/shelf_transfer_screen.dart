import 'package:courier_app/app/utils/dialog_utils.dart';
import 'package:courier_app/core/theme/app_palette.dart';
import 'package:courier_app/features/shelves_management/bloc/shelves_management_bloc.dart';
import 'package:courier_app/features/shelves_management/presentation/widgets/shelf_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShelfTransferScreen extends StatefulWidget {
  const ShelfTransferScreen({super.key});

  @override
  State<ShelfTransferScreen> createState() => _ShelfTransferScreenState();
}

class _ShelfTransferScreenState extends State<ShelfTransferScreen> {
  final _awbController = TextEditingController();
  final _reasonController = TextEditingController();
  int? _selectedShelfId;

  @override
  void dispose() {
    _awbController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _awbController.clear();
    _reasonController.clear();
    setState(() => _selectedShelfId = null);
  }

  void _submit() {
    final awb = _awbController.text.trim().toUpperCase();
    final reason = _reasonController.text.trim();

    if (awb.isEmpty) {
      displaySnack(context, 'Please enter an AWB number', Colors.red);
      return;
    }
    if (_selectedShelfId == null) {
      displaySnack(context, 'Please select a destination shelf', Colors.red);
      return;
    }
    if (reason.isEmpty) {
      displaySnack(context, 'Please enter a reason', Colors.red);
      return;
    }

    context.read<ShelvesManagementBloc>().add(
          TransferShelfEvent(
            awbNumber: awb,
            toShelfId: _selectedShelfId!,
            reason: reason,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isLoading = context.select<ShelvesManagementBloc, bool>(
      (bloc) => bloc.state is TransferShelfLoading,
    );

    return BlocListener<ShelvesManagementBloc, ShelvesManagementState>(
      listener: (context, state) {
        if (state is TransferShelfSuccess) {
          displaySnack(context, state.message, Colors.green);
          _clearForm();
          context.read<ShelvesManagementBloc>().add(
                RestoreShelvesStateEvent(state.previous),
              );
        } else if (state is TransferShelfFailure) {
          displaySnack(context, state.message, Colors.red);
          context.read<ShelvesManagementBloc>().add(
                RestoreShelvesStateEvent(state.previous),
              );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Shelf Transfer'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Move a parcel to another shelf',
                style: TextStyle(
                  fontSize: 14,
                  color: palette.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'AWB Number',
                style: TextStyle(
                  color: palette.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _awbController,
                textCapitalization: TextCapitalization.characters,
                enabled: !isLoading,
                decoration: InputDecoration(
                  hintText: 'e.g. ETGD14276',
                  filled: true,
                  fillColor: palette.surfaceMuted,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ShelfPicker(
                selectedShelfId: _selectedShelfId,
                onChanged: (id) => setState(() => _selectedShelfId = id),
              ),
              const SizedBox(height: 20),
              Text(
                'Reason',
                style: TextStyle(
                  color: palette.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _reasonController,
                enabled: !isLoading,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'e.g. Relocated to correct shelf',
                  filled: true,
                  fillColor: palette.surfaceMuted,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: isLoading ? null : _submit,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Transfer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
