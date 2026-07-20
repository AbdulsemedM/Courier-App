/// API permission name constants used by the courier app UI.
///
/// Names match `GET /api/v1/permission/role/{roleId}` permission `name` fields.
class AppPermissions {
  AppPermissions._();

  // Home / shipments
  static const String addShipment = 'add_shipment';
  static const String trackShipment = 'Track_Shipment';
  static const String changeShipmentStatus = 'Change_Shipment_Status';
  static const String viewReports = 'view_reports';
  static const String manageAccounting = 'manage_accounting';

  // Applications
  static const String payByAwb = 'pay_by_awb';
  static const String shipmentInvoice = 'Shipment_Invoice';
  static const String manageShipments = 'manage_shipments';
  static const String manageManifest = 'manage_manifest';
  static const String manifestList = 'Manifest_List';
  static const String manageHomeDelivery = 'Manage_Home_Delivery';
  static const String shelvesManagement = 'Shelves_management';
  static const String manageExtraFee = 'manage_extra_fee';

  // Reports
  static const String branchReport = 'Branch_Report';
  static const String adminBranchReport = 'Admin_Branch_Report';
  static const String branchExpenses = 'Branch_Expenses';
  static const String adminExpense = 'Admin_Expense';

  // Accounting
  static const String accountsList = 'Accounts_List';
  static const String balanceSheet = 'Balance_Sheet';
  static const String incomeStatement = 'Income_Statement';
  static const String pendingCloseout = 'Pending_Closeout';
  static const String tellersList = 'Tellers_List';
  static const String branchTeller = 'Branch Teller';
  static const String tellerByBranch = 'Teller_By_Branch';
  static const String tellerByBranchAdmin = 'Teller_By_Branch_Admin';
  static const String tellerLiabilityHq = 'teller_liability_hq';
  static const String tellerLiabilityBranch = 'teller_liability_branch';
  static const String transactionHqBranch = 'Transaction_HQ_Branch';
  static const String transactionsBranchHq = 'Transactions_Branch_HQ';
  static const String closeOutTransactions = 'Close_out_Transactions';

  // Options / settings
  static const String manageBranches = 'manage_branches';
  static const String manageCountries = 'manage_countries';
  static const String managePaymentMethods = 'manage_payment_methods';
  static const String manageShipmentTypes = 'manage_shipment_types';
  static const String servicesModes = 'Services_modes';
  static const String manageCurrencies = 'manage_currencies';
  static const String manageTransportModes = 'manage_transport_modes';
  static const String manageExchangeRates = 'manage_exchange_rates';
  static const String manageUsers = 'manage_users';
  static const String usersList = 'Users_List';
  static const String manageCustomers = 'manage_customers';
  static const String manageAgents = 'manage_agents';
  static const String tellersListAssign = 'Assign_Tellers';

  // Dashboard
  static const String viewDashboard = 'view_dashboard';

  /// Permissions that unlock the Home Reports entry tile.
  static const List<String> reportEntryAny = [
    viewReports,
    branchReport,
    adminBranchReport,
    branchExpenses,
    adminExpense,
  ];

  /// Permissions that unlock the Home Other Settings entry tile.
  static const List<String> optionsEntryAny = [
    manageBranches,
    manageCountries,
    managePaymentMethods,
    manageShipmentTypes,
    servicesModes,
    manageCurrencies,
    manageTransportModes,
    manageExchangeRates,
    manageAccounting,
    manageUsers,
    usersList,
    manageCustomers,
    manageAgents,
  ];

  /// Permissions that unlock Manifest.
  static const List<String> manifestAny = [
    manageManifest,
    manifestList,
  ];

  /// Permissions that unlock Manage Users in Options.
  static const List<String> manageUsersAny = [
    manageUsers,
    usersList,
  ];

  /// Permissions that unlock Teller Account in Accounting.
  static const List<String> tellerAccountAny = [
    tellersList,
    branchTeller,
  ];
}

/// Case-insensitive permission matching with space/underscore normalization.
class PermissionGuard {
  PermissionGuard._();

  static String normalize(String value) {
    return value.trim().toLowerCase().replaceAll(RegExp(r'[\s_]+'), '');
  }

  static bool has(List<String> permissions, String required) {
    if (required.isEmpty) return false;
    final target = normalize(required);
    for (final p in permissions) {
      if (normalize(p) == target) return true;
    }
    return false;
  }

  static bool hasAny(List<String> permissions, List<String> required) {
    for (final name in required) {
      if (has(permissions, name)) return true;
    }
    return false;
  }
}
