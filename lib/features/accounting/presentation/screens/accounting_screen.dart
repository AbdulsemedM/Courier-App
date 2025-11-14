import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme_provider.dart';
import 'accounting_create_screen.dart';
import '../../../accounts/presentation/screens/accounts_screen.dart';
import '../../../balance_sheet/presentation/screens/balance_sheet_screen.dart';
import '../../../income_statement/presentation/screens/income_statement_screen.dart';
import '../../../teller_accounts/presentation/screens/teller_accounts_screen.dart';
import '../../../teller_by_branch/presentation/screens/teller_by_branch_screen.dart';
import '../../../teller_by_branch_admin/presentation/screens/teller_by_branch_admin_screen.dart';
import '../../../teller_by_branch/bloc/teller_by_branch_bloc.dart';
import '../../../teller_by_branch/data/repository/teller_by_branch_repository.dart';
import '../../../teller_by_branch/data/data_provider/teller_by_branch_data_provider.dart';
import '../../../branches/bloc/branches_bloc.dart';
import '../../../branches/data/repository/branches_repository.dart';
import '../../../branches/data/data_provider/branches_data_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../transaction_branch_to_hq/presentation/screens/transaction_branch_to_hq_screen.dart';
import '../../../transaction_hq_to_branch/presentation/screens/transaction_hq_to_branch_screen.dart';
import '../../../closeout_transaction/presentation/screens/closeout_transaction_screen.dart';
import '../../../closeout_transaction/bloc/closeout_transaction_bloc.dart';
import '../../../closeout_transaction/data/repository/closeout_transaction_repository.dart';
import '../../../closeout_transaction/data/data_provider/closeout_transaction_data_provider.dart';
import '../../../pending_closeout/presentation/screens/pending_closeout_screen.dart';
import '../../../pending_closeout/bloc/pending_closeout_bloc.dart';
import '../../../pending_closeout/data/repository/pending_closeout_repository.dart';
import '../../../pending_closeout/data/data_provider/pending_closeout_data_provider.dart';
import '../../../teller_liability/presentation/screens/teller_liability_screen.dart';
import '../../../teller_liability/bloc/teller_liability_bloc.dart';
import '../../../teller_liability/data/repository/teller_liability_repository.dart';
import '../../../teller_liability/data/data_provider/teller_liability_data_provider.dart';
import '../../../teller_liability_by_branch/presentation/screens/teller_liability_by_branch_screen.dart';
import '../../../teller_liability_by_branch/bloc/teller_liability_by_branch_bloc.dart';
import '../../../teller_liability_by_branch/data/repository/teller_liability_by_branch_repository.dart';
import '../../../teller_liability_by_branch/data/data_provider/teller_liability_by_branch_data_provider.dart';

class AccountingScreen extends StatefulWidget {
  const AccountingScreen({super.key});

  @override
  State<AccountingScreen> createState() => _AccountingScreenState();
}

class _AccountingScreenState extends State<AccountingScreen> {
  final List<Map<String, dynamic>> _accountingFeatures = [
    {
      'title': 'Create',
      'icon': Icons.add_circle_outline,
      'color': Colors.blue,
    },
    {
      'title': 'Accounts',
      'icon': Icons.account_balance_wallet,
      'color': Colors.green,
    },
    {
      'title': 'Balance Sheet',
      'icon': Icons.description,
      'color': Colors.purple,
    },
    {
      'title': 'Income Statement',
      'icon': Icons.assessment,
      'color': Colors.orange,
    },
    {
      'title': 'Pending Closeout',
      'icon': Icons.pending_actions,
      'color': Colors.amber,
    },
    {
      'title': 'Teller Account',
      'icon': Icons.account_circle,
      'color': Colors.teal,
    },
    {
      'title': 'Teller By Branch',
      'icon': Icons.business,
      'color': Colors.indigo,
    },
    {
      'title': 'Teller By Branch Admin',
      'icon': Icons.admin_panel_settings,
      'color': Colors.deepPurple,
    },
    {
      'title': 'Teller Liability',
      'icon': Icons.account_balance,
      'color': Colors.red,
    },
    {
      'title': 'Teller Liability Branch',
      'icon': Icons.business_center,
      'color': Colors.pink,
    },
    {
      'title': 'Transaction HQto Branch',
      'icon': Icons.swap_horiz,
      'color': Colors.cyan,
    },
    {
      'title': 'Transaction Branch to HQ',
      'icon': Icons.swap_vert,
      'color': Colors.lightBlue,
    },
    {
      'title': 'Closeout Transaction',
      'icon': Icons.check_circle_outline,
      'color': Colors.lime,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor:
          isDarkMode ? const Color(0xFF5b3895) : const Color(0xFF5b3895),
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
                    const Color(0xFF5b3895),
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
                      'Accounting',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              // Main Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.1,
                    children: _accountingFeatures.map((feature) {
                      return _buildAccountingCard(
                        context: context,
                        icon: feature['icon'] as IconData,
                        title: feature['title'] as String,
                        color: feature['color'] as Color,
                        isDarkMode: isDarkMode,
                        onTap: () {
                          if (feature['title'] == 'Create') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const AccountingCreateScreen(),
                              ),
                            );
                          } else if (feature['title'] == 'Accounts') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AccountsScreen(),
                              ),
                            );
                          } else if (feature['title'] == 'Balance Sheet') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const BalanceSheetScreen(),
                              ),
                            );
                          } else if (feature['title'] == 'Income Statement') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const IncomeStatementScreen(),
                              ),
                            );
                          } else if (feature['title'] == 'Teller Account') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const TellerAccountsScreen(),
                              ),
                            );
                          } else if (feature['title'] == 'Teller By Branch') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) => TellerByBranchBloc(
                                    TellerByBranchRepository(
                                      tellerByBranchDataProvider: TellerByBranchDataProvider(),
                                    ),
                                  ),
                                  child: const TellerByBranchScreen(),
                                ),
                              ),
                            );
                          } else if (feature['title'] == 'Teller By Branch Admin') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MultiBlocProvider(
                                  providers: [
                                    BlocProvider(
                                      create: (context) => TellerByBranchBloc(
                                        TellerByBranchRepository(
                                          tellerByBranchDataProvider: TellerByBranchDataProvider(),
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
                                  child: const TellerByBranchAdminScreen(),
                                ),
                              ),
                            );
                          } else if (feature['title'] == 'Transaction Branch to HQ') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const TransactionBranchToHqScreen(),
                              ),
                            );
                          } else if (feature['title'] == 'Transaction HQto Branch') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const TransactionHqToBranchScreen(),
                              ),
                            );
                          } else if (feature['title'] == 'Closeout Transaction') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MultiBlocProvider(
                                  providers: [
                                    BlocProvider(
                                      create: (context) => CloseoutTransactionBloc(
                                        repository: CloseoutTransactionRepository(
                                          dataProvider: CloseoutTransactionDataProvider(),
                                        ),
                                      ),
                                    ),
                                    BlocProvider(
                                      create: (context) => TellerByBranchBloc(
                                        TellerByBranchRepository(
                                          tellerByBranchDataProvider: TellerByBranchDataProvider(),
                                        ),
                                      ),
                                    ),
                                  ],
                                  child: const CloseoutTransactionScreen(),
                                ),
                              ),
                            );
                          } else if (feature['title'] == 'Pending Closeout') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MultiBlocProvider(
                                  providers: [
                                    BlocProvider(
                                      create: (context) => PendingCloseoutBloc(
                                        repository: PendingCloseoutRepository(
                                          dataProvider: PendingCloseoutDataProvider(),
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
                                  child: const PendingCloseoutScreen(),
                                ),
                              ),
                            );
                          } else if (feature['title'] == 'Teller Liability') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MultiBlocProvider(
                                  providers: [
                                    BlocProvider(
                                      create: (context) => TellerLiabilityBloc(
                                        repository: TellerLiabilityRepository(
                                          dataProvider: TellerLiabilityDataProvider(),
                                        ),
                                      )..add(FetchTellerLiabilities()),
                                    ),
                                    BlocProvider(
                                      create: (context) => BranchesBloc(
                                        BranchesRepository(
                                          branchesDataProvider: BranchesDataProvider(),
                                        ),
                                      )..add(FetchBranches()),
                                    ),
                                  ],
                                  child: const TellerLiabilityScreen(),
                                ),
                              ),
                            );
                          } else if (feature['title'] == 'Teller Liability Branch') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MultiBlocProvider(
                                  providers: [
                                    BlocProvider(
                                      create: (context) => TellerLiabilityByBranchBloc(
                                        repository: TellerLiabilityByBranchRepository(
                                          dataProvider: TellerLiabilityByBranchDataProvider(),
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
                                  child: const TellerLiabilityByBranchScreen(),
                                ),
                              ),
                            );
                          }
                          // TODO: Navigate to other specific feature screens
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountingCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Color color,
    required bool isDarkMode,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      color: isDarkMode ? color.withOpacity(0.15) : color.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: color.withOpacity(isDarkMode ? 0.3 : 0.2),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: color,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
