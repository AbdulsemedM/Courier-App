import 'package:courier_app/features/services_mode/models/services_mode_models.dart';
import 'package:courier_app/features/services_mode/presentation/widget/add_services_mode_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/services_mode_bloc.dart';
import '../widget/services_mode_widget.dart';

class ServicesModeScreen extends StatefulWidget {
  const ServicesModeScreen({super.key});

  @override
  State<ServicesModeScreen> createState() => _ServicesModeScreenState();
}

class _ServicesModeScreenState extends State<ServicesModeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ServicesModeModels> _filteredServices = [];

  @override
  void initState() {
    super.initState();
    _fetchServicesModes();
  }

  void _fetchServicesModes() {
    context.read<ServicesModeBloc>().add(FetchServicesMode());
  }

  void _handleSearch(String query) {
    final state = context.read<ServicesModeBloc>().state;
    if (state is ServicesModeLoaded) {
      setState(() {
        _filteredServices = state.servicesMode.where((service) {
          final searchLower = query.toLowerCase();
          return (service.code.toLowerCase().contains(searchLower)) ||
              (service.description.toLowerCase().contains(searchLower));
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5b3895),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 75, 23, 160),
        title: const Text('Services Mode'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  return Dialog(
                    insetPadding: const EdgeInsets.all(24),
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: const AddServicesModeModal(),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<ServicesModeBloc, ServicesModeState>(
        builder: (context, state) {
          if (state is ServicesModeLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ServicesModeError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  ElevatedButton(
                    onPressed: _fetchServicesModes,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is ServicesModeLoaded) {
            final services =
                _filteredServices.isEmpty && _searchController.text.isEmpty
                    ? state.servicesMode
                    : _filteredServices;

            return Column(
              children: [
                SearchBarWidget(
                  controller: _searchController,
                  onChanged: _handleSearch,
                ),
                Expanded(
                  child: ServicesModeTable(
                    servicesModes: services,
                  ),
                ),
              ],
            );
          }

          return const Center(child: Text('No data available'));
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
