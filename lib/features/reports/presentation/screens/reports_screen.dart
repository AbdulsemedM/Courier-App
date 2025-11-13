import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/theme_provider.dart';
import 'package:courier_app/features/branch_report/presentation/screens/branch_report_screen.dart';
import 'package:courier_app/features/branch_report/bloc/branch_report_bloc.dart';
import 'package:courier_app/features/branch_report/data/repository/branch_report_repository.dart';
import 'package:courier_app/features/branch_report/data/data_provider/branch_report_data_provider.dart';
import 'package:courier_app/features/admin_report/presentation/screens/admin_report_screen.dart';
import 'package:courier_app/features/admin_report/bloc/admin_report_bloc.dart';
import 'package:courier_app/features/admin_report/data/repository/admin_report_repository.dart';
import 'package:courier_app/features/admin_report/data/data_provider/admin_report_data_provider.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor:
          isDarkMode ? const Color(0xFF1A1C2E) : const Color(0xFFF5F6FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDarkMode
            ? const Color.fromARGB(255, 91, 19, 207)
            : const Color(0xFF5b3895),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Reports',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDarkMode
                ? [
                    const Color(0xFF1A1C2E),
                    const Color(0xFF2D3250),
                  ]
                : [
                    const Color(0xFFF5F6FA),
                    const Color(0xFFFFFFFF),
                  ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Coming Soon Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 239, 146, 96),
                      const Color(0xFFFF5A00),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: isDarkMode
                          ? Colors.black.withOpacity(0.3)
                          : Colors.grey.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.analytics_outlined,
                      size: 80,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Reports Feature',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Available Reports
              Text(
                'Available Reports',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 16),
              // Report Cards
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.1,
                children: [
                  _buildReportCard(
                    icon: Icons.business,
                    title: 'Branch Report',
                    description: 'View branch reports',
                    isDarkMode: isDarkMode,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => BranchReportBloc(
                              repository: BranchReportRepository(
                                dataProvider: BranchReportDataProvider(),
                              ),
                            ),
                            child: const BranchReportScreen(),
                          ),
                        ),
                      );
                    },
                  ),
                  _buildReportCard(
                    icon: Icons.admin_panel_settings,
                    title: 'Admin Report',
                    description: 'View admin reports',
                    isDarkMode: isDarkMode,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => AdminReportBloc(
                              repository: AdminReportRepository(
                                dataProvider: AdminReportDataProvider(),
                              ),
                            ),
                            child: const AdminReportScreen(),
                          ),
                        ),
                      );
                    },
                  ),
                  _buildReportCard(
                    icon: Icons.receipt_long,
                    title: 'Branch Expense',
                    description: 'View branch expenses',
                    isDarkMode: isDarkMode,
                  ),
                  _buildReportCard(
                    icon: Icons.account_balance_wallet,
                    title: 'Admin Expense',
                    description: 'View admin expenses',
                    isDarkMode: isDarkMode,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportCard({
    required IconData icon,
    required String title,
    required String description,
    required bool isDarkMode,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 0,
      color: isDarkMode ? Colors.grey[850]!.withOpacity(0.5) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap ??
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$title feature coming soon'),
                  backgroundColor: const Color(0xFFFF5A00),
                ),
              );
            },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 28,
                color: const Color(0xFFFF5A00),
              ),
              const SizedBox(height: 8),
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.grey[800],
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 4),
              Flexible(
                child: Text(
                  description,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
