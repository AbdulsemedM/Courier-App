import 'package:courier_app/features/branches/model/branches_model.dart';

class BranchNameResolver {
  static bool isMissingName(String? name) {
    if (name == null) return true;
    final trimmed = name.trim();
    return trimmed.isEmpty ||
        trimmed.toUpperCase() == 'N/A' ||
        RegExp(r'^\d+$').hasMatch(trimmed);
  }

  static int? parseId(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is Map) {
      return parseId(value['id']);
    }
    final text = value.toString().trim();
    if (RegExp(r'^\d+$').hasMatch(text)) {
      return int.tryParse(text);
    }
    return null;
  }

  static String parseName(dynamic branch) {
    if (branch == null) return '';
    if (branch is Map) {
      final name = branch['name'];
      if (name != null) {
        final text = name.toString().trim();
        if (!isMissingName(text)) return text;
      }
      return '';
    }
    if (branch is int || branch is num) return '';
    final text = branch.toString().trim();
    if (isMissingName(text)) return '';
    return text;
  }

  static String? branchCodeFromAwb(String? awb) {
    if (awb == null || awb.isEmpty) return null;
    final match = RegExp(r'^ET([A-Z]{2})').firstMatch(awb.toUpperCase());
    return match?.group(1);
  }

  static String resolve({
    String? name,
    int? branchId,
    Map<int, String>? branchNamesById,
    List<BranchesModel>? branches,
    String? awb,
  }) {
    if (!isMissingName(name)) return name!.trim();
    if (branchId != null && branchNamesById != null) {
      final resolved = branchNamesById[branchId];
      if (resolved != null && resolved.trim().isNotEmpty) {
        return resolved.trim();
      }
    }
    final code = branchCodeFromAwb(awb);
    if (code != null && branches != null) {
      for (final branch in branches) {
        if (branch.code.toUpperCase() == code) {
          return branch.name;
        }
      }
    }
    return '';
  }

  static Map<int, String> lookupFromBranches(List<BranchesModel> branches) {
    return {for (final branch in branches) branch.id: branch.name};
  }
}
