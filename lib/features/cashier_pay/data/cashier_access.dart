import 'package:courier_app/configuration/auth_service.dart';
import 'package:courier_app/core/utils/role_display_helper.dart';
import 'package:courier_app/features/cashier_pay/data/cashier_pay_models.dart';
import 'package:courier_app/features/cashier_pay/data/cashier_pay_repository.dart';

/// Who may see the cashier features. Mirrors the web dashboard:
///  - "Cashier Pay" (branch side): shown when `/cashiers/me` → `isCashier`.
///  - "Branch Cashiers" (HQ side): menu shown to HQ finance/admin roles; the
///    screen itself requires `/cashiers/me` → `isHq`, which is what the server
///    enforces (everyone else gets 403).
class CashierAccess {
  /// Role names the web dashboard lets into "Branch Cashiers" (normalized).
  static const hqRoles = {
    'hq finance',
    'hq admin',
    'headquarters finance',
    'finance',
    'admin',
    'super admin',
  };

  final CashierProfile? profile;
  final bool hasHqRole;

  const CashierAccess({this.profile, this.hasHqRole = false});

  bool get isCashier => profile?.isCashier ?? false;
  bool get isHq => profile?.isHq ?? false;

  /// Show the HQ menu when the role matches or the server says HQ.
  bool get canOpenHq => isHq || hasHqRole;

  static bool roleIsHq(String role) =>
      hqRoles.contains(RoleDisplayHelper.normalizeRole(role));

  static Future<CashierAccess> load({
    CashierPayRepository? repository,
    AuthService? authService,
  }) async {
    final auth = authService ?? AuthService();
    final roles = <String>[
      ...await auth.getRoleNames(),
      if ((await auth.getRoleName())?.isNotEmpty ?? false)
        (await auth.getRoleName())!,
    ];
    CashierProfile? profile;
    try {
      profile = await (repository ?? CashierPayRepository()).fetchMe();
    } catch (_) {
      profile = null;
    }
    return CashierAccess(
      profile: profile,
      hasHqRole: roles.any(roleIsHq),
    );
  }
}
