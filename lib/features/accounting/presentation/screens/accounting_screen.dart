import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme_provider.dart';
import 'accounting_create_screen.dart';
import '../../../accounts/presentation/screens/accounts_screen.dart';
import '../../../balance_sheet/presentation/screens/balance_sheet_screen.dart';
import '../../../income_statement/presentation/screens/income_statement_screen.dart';
import '../../../teller_accounts/presentation/screens/teller_accounts_screen.dart';

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
