import 'package:courier_app/configuration/auth_service.dart';

class RoleDisplayInfo {
  final String primaryRole;
  final String formattedRole;

  const RoleDisplayInfo({
    required this.primaryRole,
    required this.formattedRole,
  });
}

class RoleDisplayHelper {
  static const _rolePriority = {
    'admin': 0,
    'branch manager': 1,
    'teller': 2,
  };

  /// Maps API role strings (e.g. `TALLER `, `BRANCH MANAGER`) to canonical names.
  static String normalizeRole(String raw) {
    final normalized = raw.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
    if (normalized.isEmpty) return normalized;
    // Backend lists this role as "TALLER" (typo for teller).
    if (normalized == 'taller') return 'teller';
    return normalized;
  }

  static bool isAdminRole(String? raw) =>
      raw != null && normalizeRole(raw) == 'admin';

  static bool hasAccountingAccess(String? raw) {
    if (raw == null || raw.trim().isEmpty) return false;
    final role = normalizeRole(raw);
    return role == 'admin' || role == 'teller' || role == 'branch manager';
  }

  static bool hasBranchReportNetAccess(String? raw) {
    if (raw == null || raw.trim().isEmpty) return false;
    final role = normalizeRole(raw);
    return role == 'admin' || role == 'branch manager';
  }

  static String resolvePrimaryRole(List<String> roles) {
    if (roles.isEmpty) return 'user';

    String? bestRole;
    var bestPriority = 999;

    for (final raw in roles) {
      final normalized = normalizeRole(raw);
      if (normalized.isEmpty) continue;

      final priority = _rolePriority[normalized] ?? 100;
      if (priority < bestPriority) {
        bestPriority = priority;
        bestRole = normalized;
      }
    }

    return bestRole ?? roles.first.trim().toLowerCase();
  }

  static String formatRoleLabel(String role) {
    final normalized = normalizeRole(role);
    if (normalized.isEmpty) return 'User';

    return normalized
        .split(RegExp(r'\s+'))
        .map((word) =>
            word.isEmpty ? word : '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }

  static List<String> parseRolesFromToken(Map<String, dynamic> user) {
    final roles = <String>[];

    void addRole(dynamic value) {
      if (value is String && value.trim().isNotEmpty) {
        roles.add(value.trim());
      }
    }

    final candidates = [
      user['roles'],
      user['roleNames'],
      user['role_names'],
    ];

    for (final candidate in candidates) {
      if (candidate is List) {
        for (final item in candidate) {
          if (item is String) {
            addRole(item);
          } else if (item is Map) {
            addRole(item['role'] ?? item['roleName'] ?? item['name']);
          }
        }
      }
    }

    addRole(user['roleName']);
    addRole(user['role']);

    return roles.toSet().toList();
  }

  static Future<RoleDisplayInfo> loadRoleDisplayInfo({
    AuthService? authService,
  }) async {
    final auth = authService ?? AuthService();
    final storedRoles = await auth.getRoleNames();
    final roleName = await auth.getRoleName();

    final roles = <String>[
      ...storedRoles,
      if (roleName != null && roleName.isNotEmpty) roleName,
    ];

    final primary = resolvePrimaryRole(roles);
    return RoleDisplayInfo(
      primaryRole: primary,
      formattedRole: formatRoleLabel(primary),
    );
  }
}
