import 'package:courier_app/core/utils/role_display_helper.dart';

class ManifestAccessHelper {
  static const _allowedRoles = {'admin', 'branch manager', 'teller'};

  static bool canAccessManifest(List<String> roles) {
    return roles.any(
      (role) => _allowedRoles.contains(RoleDisplayHelper.normalizeRole(role)),
    );
  }
}
