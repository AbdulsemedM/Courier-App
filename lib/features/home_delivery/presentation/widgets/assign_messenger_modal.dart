import 'package:courier_app/configuration/auth_service.dart';
import 'package:courier_app/core/theme/app_palette.dart';
import 'package:courier_app/features/home_delivery/bloc/home_delivery_bloc.dart';
import 'package:courier_app/features/messenger/data/data_provider/messenger_data_provider.dart';
import 'package:courier_app/features/messenger/data/model/messenger_model.dart';
import 'package:courier_app/features/messenger/data/repository/messenger_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AssignMessengerModal extends StatefulWidget {
  final int branchId;
  final String awb;

  const AssignMessengerModal({
    super.key,
    required this.branchId,
    required this.awb,
  });

  @override
  State<AssignMessengerModal> createState() => _AssignMessengerModalState();
}

class _AssignMessengerModalState extends State<AssignMessengerModal> {
  final _messengerRepository =
      MessengerRepository(messengerDataProvider: MessengerDataProvider());
  final _authService = AuthService();

  Future<List<MessengerModel>>? _messengersFuture;
  MessengerModel? _selectedMessenger;
  DateTime? _estimatedDateTime;

  @override
  void initState() {
    super.initState();
    _messengersFuture =
        _messengerRepository.fetchMessengersByBranch(widget.branchId);
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(hours: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        DateTime.now().add(const Duration(hours: 1)),
      ),
    );
    if (time == null || !mounted) return;

    setState(() {
      _estimatedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _submitWithUserId() async {
    if (_selectedMessenger == null) {
      _showSnack('Please select a messenger');
      return;
    }
    if (_estimatedDateTime == null) {
      _showSnack('Please select estimated delivery time');
      return;
    }

    final userId = int.tryParse(await _authService.getUserId() ?? '') ?? 0;
    final formatted =
        DateFormat('yyyy-MM-dd HH:mm').format(_estimatedDateTime!);

    if (!mounted) return;
    context.read<HomeDeliveryBloc>().add(
          AssignMessenger(
            awb: widget.awb,
            messengerId: _selectedMessenger!.id,
            assignedBy: userId,
            estimatedDeliveryTime: formatted,
          ),
        );
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return BlocListener<HomeDeliveryBloc, HomeDeliveryState>(
      listenWhen: (prev, curr) =>
          curr is AssignMessengerSuccess || curr is AssignMessengerFailure,
      listener: (context, state) {
        if (state is AssignMessengerSuccess) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is AssignMessengerFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Assign Messenger',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: palette.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'AWB: ${widget.awb}',
              style: TextStyle(color: palette.textSecondary),
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<MessengerModel>>(
              future: _messengersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Text(
                    snapshot.error.toString(),
                    style: const TextStyle(color: Colors.red),
                  );
                }
                final messengers = snapshot.data ?? [];
                if (messengers.isEmpty) {
                  return Text(
                    'No active messengers for this branch',
                    style: TextStyle(color: palette.textSecondary),
                  );
                }
                return DropdownButtonFormField<MessengerModel>(
                  value: _selectedMessenger,
                  decoration: InputDecoration(
                    labelText: 'Messenger',
                    filled: true,
                    fillColor: palette.surfaceMuted,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  dropdownColor: palette.surface,
                  items: messengers
                      .map(
                        (m) => DropdownMenuItem(
                          value: m,
                          child: Text(
                            m.displayLabel,
                            style: TextStyle(color: palette.textPrimary),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _selectedMessenger = value),
                );
              },
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _pickDateTime,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: palette.surfaceMuted,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.schedule, color: palette.accent),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _estimatedDateTime != null
                            ? DateFormat('yyyy-MM-dd HH:mm')
                                .format(_estimatedDateTime!)
                            : 'Select estimated delivery time',
                        style: TextStyle(color: palette.textPrimary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            BlocBuilder<HomeDeliveryBloc, HomeDeliveryState>(
              buildWhen: (prev, curr) =>
                  curr is AssignMessengerLoading ||
                  curr is AssignMessengerSuccess ||
                  curr is AssignMessengerFailure,
              builder: (context, state) {
                final loading = state is AssignMessengerLoading;
                return ElevatedButton(
                  onPressed: loading ? null : _submitWithUserId,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: palette.accent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: loading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Assign'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
