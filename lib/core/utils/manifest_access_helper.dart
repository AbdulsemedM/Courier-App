class ManifestAccessHelper {
  static const _allowedRoles = {'admin', 'branch manager', 'teller'};

  static bool canAccessManifest(List<String> roles) {
    return roles.any(
      (role) => _allowedRoles.contains(role.trim().toLowerCase()),
    );
  }
}
