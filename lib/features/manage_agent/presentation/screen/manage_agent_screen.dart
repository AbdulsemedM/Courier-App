import 'package:courier_app/features/manage_agent/bloc/manage_agent_bloc.dart';
import 'package:courier_app/features/manage_agent/presentation/widget/add_agent_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/agent_model.dart';
import '../widget/manage_agent_widget.dart';

class ManageAgentScreen extends StatefulWidget {
  const ManageAgentScreen({super.key});

  @override
  State<ManageAgentScreen> createState() => _ManageAgentScreenState();
}

class _ManageAgentScreenState extends State<ManageAgentScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<AgentModel> _filteredAgents = [];

  @override
  void initState() {
    super.initState();
    context.read<ManageAgentBloc>().add(FetchAgentsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDarkMode
                ? [
                    const Color.fromARGB(255, 75, 23, 160),
                    const Color(0xFF5b3895),
                  ]
                : [
                    const Color.fromARGB(255, 75, 23, 160),
                    const Color(0xFF5b3895),
                  ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Manage Agents',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: () => _showAddCustomerModal(context),
                      icon: const Icon(Icons.add),
                      label: const Text('Add'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF5a00),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Search Bar
              SearchBarWidget(
                controller: _searchController,
                onChanged: _filterCustomers,
              ),

              // Main Content
              Expanded(
                child: BlocBuilder<ManageAgentBloc, ManageAgentState>(
                  builder: (context, state) {
                    if (state is FetchAgentsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is FetchAgentsSuccess) {
                      final agents = _searchController.text.isEmpty
                          ? state.agents
                          : _filteredAgents;

                      return AgentsTable(
                        agents: agents,
                        onEdit: (agent) => _handleEdit(context, agent),
                        onDelete: (agent) => _handleDelete(context, agent),
                      );
                    }

                    if (state is FetchAgentsError) {
                      return Center(
                        child: Text(
                          'Error: ${state.error}',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      );
                    }

                    return const Center(child: Text('No data available'));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _filterCustomers(String query) {
    final state = context.read<ManageAgentBloc>().state;
    if (state is FetchAgentsSuccess) {
      setState(() {
        _filteredAgents = state.agents
            .where((customer) =>
                customer.name.toLowerCase().contains(query.toLowerCase()) ||
                customer.email.toLowerCase().contains(query.toLowerCase()) ||
                customer.phone.toLowerCase().contains(query.toLowerCase()) ||
                customer.agentCode.toLowerCase().contains(query.toLowerCase()) ||
                customer.branchName.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  Future<void> _showAddCustomerModal(BuildContext context) async {
    final success = await showDialog<bool>(
      context: context,
      builder: (context) => const AddAgentModal(),
    );

    if (success == true && mounted) {
      context.read<ManageAgentBloc>().add(FetchAgentsEvent());
    }
  }

  void _handleEdit(BuildContext context, AgentModel agent) {
    showDialog<bool>(
      context: context,
      builder: (context) => AddAgentModal(agentToEdit: agent),
    ).then((success) {
      if (success == true && mounted) {
        context.read<ManageAgentBloc>().add(FetchAgentsEvent());
      }
    });
  }

  void _handleDelete(BuildContext context, AgentModel agent) {
    // Handle delete action
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
