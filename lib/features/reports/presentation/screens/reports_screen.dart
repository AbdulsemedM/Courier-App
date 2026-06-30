import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:courier_app/core/utils/role_display_helper.dart';
import 'package:courier_app/features/branch_report/presentation/screens/branch_report_screen.dart';
import 'package:courier_app/features/branch_report/bloc/branch_report_bloc.dart';
import 'package:courier_app/features/branch_report/data/repository/branch_report_repository.dart';
import 'package:courier_app/features/branch_report/data/data_provider/branch_report_data_provider.dart';
import 'package:courier_app/features/branch_report_net/presentation/screens/branch_report_net_screen.dart';
import 'package:courier_app/features/branch_report_net/bloc/branch_report_net_bloc.dart';
import 'package:courier_app/features/branch_report_net/data/repository/branch_report_net_repository.dart';
import 'package:courier_app/features/branch_report_net/data/data_provider/branch_report_net_data_provider.dart';
import 'package:courier_app/features/admin_report/presentation/screens/admin_report_screen.dart';
import 'package:courier_app/features/admin_report/bloc/admin_report_bloc.dart';
import 'package:courier_app/features/admin_report/data/repository/admin_report_repository.dart';
import 'package:courier_app/features/admin_report/data/data_provider/admin_report_data_provider.dart';
import 'package:courier_app/features/branch_expenses/presentation/screens/branch_expenses_screen.dart';
import 'package:courier_app/features/branch_expenses/bloc/branch_expenses_bloc.dart';
import 'package:courier_app/features/branch_expenses/data/repository/branch_expenses_repository.dart';
import 'package:courier_app/features/branch_expenses/data/data_provider/branch_expenses_data_provider.dart';
import 'package:courier_app/features/admin_expenses/presentation/screens/admin_expenses_screen.dart';
import 'package:courier_app/features/admin_expenses/bloc/admin_expenses_bloc.dart';
import 'package:courier_app/features/admin_expenses/data/repository/admin_expenses_repository.dart';
import 'package:courier_app/features/admin_expenses/data/data_provider/admin_expenses_data_provider.dart';
import 'package:courier_app/features/branches/bloc/branches_bloc.dart';
import 'package:courier_app/features/branches/data/repository/branches_repository.dart';
import 'package:courier_app/features/branches/data/data_provider/branches_data_provider.dart';
import 'package:courier_app/core/theme/app_palette.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  bool _hasBranchReportNetAccess = false;
  bool _roleLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadRole();
  }

  Future<void> _loadRole() async {
    final roleInfo = await RoleDisplayHelper.loadRoleDisplayInfo();
    if (!mounted) return;
    setState(() {
      _hasBranchReportNetAccess =
          RoleDisplayHelper.hasBranchReportNetAccess(roleInfo.primaryRole);
      _roleLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.isDarkMode;

    return Scaffold(
      backgroundColor:
          context.palette.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.palette.appBarBackground,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: context.palette.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Reports',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: context.palette.textPrimary,
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
                : [context.palette.background, context.palette.background],
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
                      context.palette.accent,
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
                  color: context.palette.textPrimary,
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
                  if (_roleLoaded && _hasBranchReportNetAccess)
                    _buildReportCard(
                      icon: Icons.summarize_outlined,
                      title: 'Branch Report Net',
                      description: 'Branch net fee shipments',
                      isDarkMode: isDarkMode,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MultiBlocProvider(
                              providers: [
                                BlocProvider(
                                  create: (context) => BranchReportNetBloc(
                                    repository: BranchReportNetRepository(
                                      dataProvider:
                                          BranchReportNetDataProvider(),
                                    ),
                                  ),
                                ),
                                BlocProvider(
                                  create: (context) => BranchesBloc(
                                    BranchesRepository(
                                      branchesDataProvider:
                                          BranchesDataProvider(),
                                    ),
                                  )..add(FetchBranches()),
                                ),
                              ],
                              child: const BranchReportNetScreen(),
                            ),
                          ),
                        );
                      },
                    ),
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => BranchExpensesBloc(
                              repository: BranchExpensesRepository(
                                dataProvider: BranchExpensesDataProvider(),
                              ),
                            ),
                            child: const BranchExpensesScreen(),
                          ),
                        ),
                      );
                    },
                  ),
                  _buildReportCard(
                    icon: Icons.account_balance_wallet,
                    title: 'Admin Expense',
                    description: 'View admin expenses',
                    isDarkMode: isDarkMode,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MultiBlocProvider(
                            providers: [
                              BlocProvider(
                                create: (context) => AdminExpensesBloc(
                                  repository: AdminExpensesRepository(
                                    dataProvider: AdminExpensesDataProvider(),
                                  ),
                                ),
                              ),
                              BlocProvider(
                                create: (context) => BranchesBloc(
                                  BranchesRepository(
                                    branchesDataProvider: BranchesDataProvider(),
                                  ),
                                )..add(FetchBranches()),
                              ),
                            ],
                            child: const AdminExpensesScreen(),
                          ),
                        ),
                      );
                    },
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
      color: context.palette.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap ??
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$title feature coming soon'),
                  backgroundColor: context.palette.accent,
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
                color: context.palette.accent,
              ),
              const SizedBox(height: 8),
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: context.palette.textPrimary,
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
                    color: context.palette.textSecondary,
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
