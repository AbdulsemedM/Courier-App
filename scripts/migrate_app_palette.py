#!/usr/bin/env python3
"""Migrate feature Dart files to AppPalette theme tokens."""
import os
import re

FEATURES = [
    "admin_report", "admin_expenses", "branch_report", "branch_expenses",
    "income_statement", "balance_sheet",
    "transaction_branch_to_hq", "transaction_hq_to_branch",
    "closeout_transaction", "pending_closeout",
    "roles", "manage_user", "manage_agent", "manage_customers", "branches",
    "tellers", "accounts", "teller_accounts", "teller_liability",
    "teller_liability_by_branch", "teller_by_branch", "teller_by_branch_admin",
    "countries", "currency", "exchange_rate", "payment_method",
    "shipment_types", "transport_modes", "services_mode",
    "add_shipment", "shipment", "track_order", "track_shipment",
    "barcode_reader", "pay_by_awb", "shipment_invoice",
    "reports", "accounting", "notification_screen", "forgot_password",
    "other_settings", "miles_configuration", "shelves_management", "comming_soon",
]

ROOT = "lib/features"
IMPORT_LINE = "import 'package:courier_app/core/theme/app_palette.dart';"

# (pattern, replacement) — applied in order
REPLACEMENTS = [
    # ThemeProvider -> context.isDarkMode
    (
        r"final themeProvider = Provider\.of<ThemeProvider>\(context\);\s*\n\s*final isDarkMode = themeProvider\.isDarkMode;",
        "final isDarkMode = context.isDarkMode;",
    ),
    (
        r"final themeProvider = Provider\.of<ThemeProvider>\(context, listen: false\);\s*\n\s*final isDarkMode = themeProvider\.isDarkMode;",
        "final isDarkMode = context.isDarkMode;",
    ),
    (
        r"final isDarkMode = Theme\.of\(context\)\.brightness == Brightness\.dark;",
        "final isDarkMode = context.isDarkMode;",
    ),
    (
        r"isDarkMode: Theme\.of\(context\)\.brightness == Brightness\.dark",
        "isDarkMode: context.isDarkMode",
    ),
    # Scaffold / page backgrounds
    (
        r"isDarkMode\s*\?\s*const Color\(0xFF0A1931\)\s*:\s*const Color\(0xFFF5F6FA\)",
        "context.palette.background",
    ),
    (
        r"isDarkMode\s*\?\s*const Color\(0xFFF5F6FA\)\s*:\s*const Color\(0xFF0A1931\)",
        "context.palette.background",
    ),
    (
        r"isDarkMode\s*\?\s*const Color\(0xFF1A1C2E\)\s*:\s*const Color\(0xFFF5F6FA\)",
        "context.palette.background",
    ),
    (
        r"isDarkMode\s*\?\s*const Color\(0xFF0A1931\)\s*:\s*const Color\(0xFFFFFFFF\)",
        "context.palette.background",
    ),
    # Purple scaffold without ternary
    (
        r"backgroundColor:\s*const Color\(0xFF5[bB]3895\)",
        "backgroundColor: context.isDarkMode ? const Color(0xFF5B3895) : context.palette.background",
    ),
    # App bar backgrounds
    (
        r"isDarkMode\s*\?\s*const Color\(0xFF152642\)\s*:\s*Colors\.white",
        "context.palette.appBarBackground",
    ),
    (
        r"isDarkMode\s*\?\s*const Color\(0xFF0A1931\)\s*:\s*Colors\.white",
        "context.palette.appBarBackground",
    ),
    (
        r"isDarkMode\s*\?\s*const Color\(0xFF5[bB]3895\)\s*:\s*Colors\.white",
        "context.palette.appBarBackground",
    ),
    (
        r"isDarkMode\s*\?\s*const Color\(0xFF5[bB]3895\)\s*:\s*const Color\(0xFF5[bB]3895\)",
        "context.palette.appBarBackground",
    ),
    (
        r"isDarkMode\s*\?\s*const Color\.fromARGB\(255,\s*91,\s*19,\s*207\)\s*:\s*const Color\(0xFF5[bB]3895\)",
        "context.palette.appBarBackground",
    ),
    (
        r"isDarkMode\s*\?\s*const Color\(0xFF152642\)\s*:\s*const Color\(0xFF5[bB]3895\)",
        "context.palette.appBarBackground",
    ),
    # Surface / cards
    (
        r"isDarkMode\s*\?\s*const Color\(0xFF152642\)\s*:\s*Colors\.white",
        "context.palette.surface",
    ),
    (
        r"isDarkMode\s*\?\s*const Color\(0xFF1E293B\)\s*:\s*Colors\.white",
        "context.palette.surface",
    ),
    (
        r"isDarkMode\s*\?\s*const Color\(0xFF5[bB]3895\)\s*:\s*Colors\.white",
        "context.palette.surface",
    ),
    (
        r"isDarkMode\s*\?\s*Colors\.grey\[900\]\s*:\s*Colors\.white",
        "context.palette.surface",
    ),
    (
        r"isDarkMode\s*\?\s*Colors\.grey\[850\]!\.withOpacity\(0\.5\)\s*:\s*Colors\.white",
        "context.palette.surface",
    ),
    # Surface muted
    (
        r"isDarkMode\s*\?\s*Colors\.grey\[800\]\s*:\s*Colors\.grey\[100\]",
        "context.palette.surfaceMuted",
    ),
    (
        r"isDarkMode\s*\?\s*Colors\.grey\[800\]!\s*:\s*Colors\.grey\[100\]",
        "context.palette.surfaceMuted",
    ),
    (
        r"isDarkMode\s*\?\s*const Color\(0xFF0F172A\)\s*:\s*Colors\.blue\[50\]!",
        "context.palette.surfaceMuted",
    ),
    # Borders
    (
        r"isDarkMode\s*\?\s*Colors\.grey\[700\]!\s*:\s*Colors\.grey\[300\]!",
        "context.palette.border",
    ),
    (
        r"isDarkMode\s*\?\s*Colors\.grey\[700\]\s*:\s*Colors\.grey\[300\]",
        "context.palette.border",
    ),
    (
        r":\s*\(isDarkMode\s*\?\s*Colors\.grey\[700\]!\s*:\s*Colors\.grey\[300\]!\)",
        ": context.palette.border",
    ),
    # Text
    (
        r"isDarkMode\s*\?\s*Colors\.white70\s*:\s*Colors\.black54",
        "context.palette.textSecondary",
    ),
    (
        r"isDarkMode\s?\s*Colors\.white38\s*:\s*Colors\.grey\[400\]",
        "context.palette.textSecondary",
    ),
    (
        r"isDarkMode\s*\?\s*Colors\.grey\[400\]\s*:\s*Colors\.grey\[600\]",
        "context.palette.textSecondary",
    ),
    (
        r"isDarkMode\s*\?\s*Colors\.white\s*:\s*Colors\.black87",
        "context.palette.textPrimary",
    ),
    (
        r"isDarkMode\s*\?\s*Colors\.white\s*:\s*Colors\.black",
        "context.palette.textPrimary",
    ),
    (
        r"isDarkMode\s*\?\s*Colors\.white70\s*:\s*Colors\.black87",
        "context.palette.textSecondary",
    ),
    # Accent
    (
        r"const Color\(0xFFFF5A00\)",
        "context.palette.accent",
    ),
    (
        r"primary:\s*const Color\(0xFFFF5A00\)",
        "primary: context.palette.accent",
    ),
    # dropdown
    (
        r"dropdownColor:\s*isDarkMode\s*\?\s*Colors\.grey\[800\]\s*:\s*Colors\.white",
        "dropdownColor: context.palette.surface",
    ),
    (
        r"fillColor:\s*isDarkMode\s*\?\s*Colors\.grey\[800\]\s*:\s*Colors\.grey\[100\]",
        "fillColor: context.palette.surfaceMuted",
    ),
    (
        r"MaterialStateProperty\.all\(isDarkMode\s*\?\s*Colors\.grey\[800\]\s*:\s*Colors\.grey\[100\]\)",
        "MaterialStateProperty.all(context.palette.surfaceMuted)",
    ),
    # Table row alternates
    (
        r"return isDarkMode\s*\?\s*const Color\(0xFF1E293B\)\s*:\s*Colors\.white;",
        "return context.palette.surface;",
    ),
    (
        r"isDarkMode\s*\?\s*const Color\(0xFF1E293B\)\s*:\s*Colors\.blue\[50\]!",
        "context.palette.surfaceMuted",
    ),
    # Date picker surface
    (
        r"surface: isDarkMode \? Colors\.grey\[850\]! : Colors\.white",
        "surface: context.palette.surface",
    ),
    # Light purple gradient branches (only replace the light-side of ternary)
    (
        r"(colors: isDarkMode\s*\?\s*\[\s*const Color\.fromARGB\(255, 75, 23, 160\),\s*const Color\(0xFF5[bB]3895\),\s*\]\s*:\s*)\[\s*const Color\.fromARGB\(255, 75, 23, 160\),\s*const Color\(0xFF5[bB]3895\),\s*\]",
        r"\1[context.palette.background, context.palette.background]",
    ),
    (
        r"(colors: isDarkMode\s*\?\s*\[\s*const Color\.fromARGB\(255, 75, 23, 160\),\s*const Color\(0xFF5[bB]3895\),\s*\]\s*:\s*)\[\s*const Color\(0xFF5[bB]3895\),\s*const Color\(0xFF5[bB]3895\),\s*\]",
        r"\1[context.palette.background, context.palette.background]",
    ),
    # Light report/body gradients (only light side)
    (
        r"(colors: isDarkMode\s*\?\s*\[\s*const Color\(0xFF1A1C2E\),\s*const Color\(0xFF2D3250\),\s*\]\s*:\s*)\[\s*const Color\(0xFFF5F6FA\),\s*const Color\(0xFFFFFFFF\),\s*\]",
        r"\1[context.palette.background, context.palette.background]",
    ),
    (
        r"const Color\(0xFFF5F6FA\)",
        "context.palette.background",
    ),
    # fillColor patterns
    (
        r"fillColor: isDarkMode \? Colors\.white10 : Colors\.grey\[100\]",
        "fillColor: context.palette.surfaceMuted",
    ),
    (
        r"fillColor: isDarkMode\s*\?\s*Colors\.white\.withOpacity\(0\.1\)\s*:\s*Colors\.white\.withOpacity\(0\.9\)",
        "fillColor: isDarkMode ? Colors.white.withOpacity(0.1) : context.palette.surface",
    ),
    (
        r"fillColor: isDarkMode\s*\?\s*Colors\.white\.withOpacity\(0\.05\)\s*:\s*Colors\.grey\.withOpacity\(0\.1\)",
        "fillColor: context.palette.surfaceMuted",
    ),
    (
        r"fillColor: isDarkMode\s*\?\s*Colors\.grey\[800\]!\.withOpacity\(0\.5\)\s*:\s*Colors\.grey\[100\]",
        "fillColor: context.palette.surfaceMuted",
    ),
    (
        r"fillColor: isDarkMode\s*\?\s*const Color\(0xFF0F172A\)\s*:\s*Colors\.grey\[50\]",
        "fillColor: context.palette.surfaceMuted",
    ),
    # Text secondary
    (
        r"isDarkMode \? Colors\.white70 : Colors\.grey\[700\]",
        "context.palette.textSecondary",
    ),
    (
        r"return isDarkMode \? Colors\.white70 : Colors\.grey;",
        "return context.palette.textSecondary;",
    ),
    (
        r"isDarkMode \? Colors\.white38 : Colors\.grey\[400\]",
        "context.palette.textSecondary",
    ),
    (
        r"isDarkMode \? Colors\.grey\[300\] : Colors\.grey\[700\]",
        "context.palette.textSecondary",
    ),
    (
        r"isDarkMode \? Colors\.grey\[700\]! : Colors\.grey\[200\]!",
        "context.palette.border",
    ),
    # Accent (case variants)
    (
        r"const Color\(0xFFFF5[aA]00\)",
        "context.palette.accent",
    ),
    (
        r"primary: const Color\(0xFFFF5[aA]00\)",
        "primary: context.palette.accent",
    ),
    (
        r"backgroundColor: const Color\(0xFFFF5[aA]00\)",
        "backgroundColor: context.palette.accent",
    ),
    (
        r"isDarkMode \? const Color\(0xFFFF5A00\) : const Color\(0xFFFF5A00\)",
        "context.palette.accent",
    ),
    # Modal/dialog surfaces
    (
        r"color: isDarkMode \? const Color\(0xFF5[bB]3895\) : Colors\.white",
        "color: isDarkMode ? const Color(0xFF5B3895) : context.palette.surface",
    ),
]

SKIP_FILES = {
    "theme_provider.dart",
    "app_palette.dart",
}


def uses_palette(content: str) -> bool:
    return "context.palette" in content or "context.isDarkMode" in content


def add_import(content: str) -> str:
    if IMPORT_LINE in content:
        return content
    if not uses_palette(content):
        return content
    # Insert after last package: import before relative imports
    lines = content.split("\n")
    last_pkg = -1
    for i, line in enumerate(lines):
        if line.startswith("import 'package:"):
            last_pkg = i
    if last_pkg >= 0:
        lines.insert(last_pkg + 1, IMPORT_LINE)
    else:
        lines.insert(0, IMPORT_LINE + "\n")
    return "\n".join(lines)


def remove_unused_theme_provider(content: str) -> str:
    if "theme_provider.dart" not in content:
        return content
    if "ThemeProvider" in content.replace("theme_provider.dart", ""):
        return content
    content = re.sub(
        r"import 'package:courier_app/core/theme/theme_provider\.dart';\n",
        "",
        content,
    )
    content = re.sub(
        r"import '../../../../core/theme/theme_provider\.dart';\n",
        "",
        content,
    )
    content = re.sub(
        r"import 'package:provider/provider\.dart';\n",
        "",
        content,
    )
    return content


def migrate_file(path: str) -> bool:
    with open(path, encoding="utf-8") as f:
        original = f.read()
    content = original
    for pattern, repl in REPLACEMENTS:
        content = re.sub(pattern, repl, content, flags=re.MULTILINE)
    content = add_import(content)
    content = remove_unused_theme_provider(content)
    if content != original:
        with open(path, "w", encoding="utf-8") as f:
            f.write(content)
        return True
    return False


def main():
    modified = []
    for feat in FEATURES:
        base = os.path.join(ROOT, feat)
        if not os.path.isdir(base):
            continue
        for dirpath, _, filenames in os.walk(base):
            for fn in filenames:
                if not fn.endswith(".dart") or fn in SKIP_FILES:
                    continue
                path = os.path.join(dirpath, fn)
                if migrate_file(path):
                    modified.append(path)
    print(f"Modified {len(modified)} files")
    for p in sorted(modified):
        print(p)


if __name__ == "__main__":
    main()
