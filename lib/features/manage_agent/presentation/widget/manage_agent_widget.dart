import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../model/agent_model.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search customers...',
          prefixIcon: Icon(
            Icons.search,
            color: isDarkMode ? Colors.grey : Colors.grey[600],
          ),
          filled: true,
          fillColor: isDarkMode ? Colors.white10 : Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
        ),
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}

class AgentsTable extends StatelessWidget {
  final List<AgentModel> agents;
  final Function(AgentModel)? onEdit;
  final Function(AgentModel)? onDelete;

  const AgentsTable({
    super.key,
    required this.agents,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          columnSpacing: 24,
          columns: [
            DataColumn(
              label: Text(
                'Full Name',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Email',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Phone',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Agent Code',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Branch',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Commision Rate',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Status',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Created At',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (onEdit != null || onDelete != null)
              DataColumn(
                label: Text(
                  'Actions',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
          rows: agents.map((agent) {
            return DataRow(
              cells: [
                DataCell(Text(
                  agent.name,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                )),
                DataCell(Text(
                  agent.email,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                )),
                DataCell(Text(
                  agent.phone,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                )),
                DataCell(Text(
                  agent.agentCode,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                )),
                DataCell(Text(
                  agent.branchName,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                )),
                DataCell(Text(
                  agent.commisionRate.toString(),
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                )),
                DataCell(Text(
                  agent.status,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                )),
                DataCell(Text(
                  DateFormat('MMM-dd-yyyy')
                      .format(DateTime.parse(agent.createdAt)),
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                )),
                if (onEdit != null || onDelete != null)
                  DataCell(Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (onEdit != null)
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: isDarkMode ? Colors.blue[300] : Colors.blue,
                          ),
                          onPressed: () => onEdit!(agent),
                        ),
                      // if (onDelete != null)
                      //   IconButton(
                      //     icon: Icon(
                      //       Icons.delete,
                      //       color: isDarkMode ? Colors.red[300] : Colors.red,
                      //     ),
                      //     onPressed: () => onDelete!(customer),
                      //   ),
                    ],
                  )),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
