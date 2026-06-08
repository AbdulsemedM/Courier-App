import 'package:courier_app/core/theme/app_palette.dart';
import 'package:courier_app/features/branches/model/country_model.dart';
import 'package:courier_app/features/public_tracking/utils/country_defaults.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneCountrySelector extends StatelessWidget {
  final List<CountryModel> countries;
  final CountryModel selectedCountry;
  final TextEditingController phoneController;
  final ValueChanged<CountryModel> onCountryChanged;
  final String? errorText;

  const PhoneCountrySelector({
    super.key,
    required this.countries,
    required this.selectedCountry,
    required this.phoneController,
    required this.onCountryChanged,
    this.errorText,
  });

  void _showCountryPicker(BuildContext context) {
    final searchController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final query = searchController.text.toLowerCase();
            final filtered = countries.where((c) {
              final name = c.name?.toLowerCase() ?? '';
              final code = c.countryCode?.toLowerCase() ?? '';
              final iso = c.isoCode?.toLowerCase() ?? '';
              return name.contains(query) ||
                  code.contains(query) ||
                  iso.contains(query);
            }).toList();

            final palette = context.palette;
            final isDark = context.isDarkMode;

            return Container(
              height: MediaQuery.of(context).size.height * 0.72,
              decoration: BoxDecoration(
                color: palette.surface,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: palette.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                    child: Text(
                      'Select country',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: palette.textPrimary,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: searchController,
                      onChanged: (_) => setModalState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Search country or code',
                        prefixIcon:
                            Icon(Icons.search, color: palette.accent, size: 22),
                        filled: true,
                        fillColor: palette.surfaceMuted,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final country = filtered[index];
                        final isSelected = country.isoCode ==
                            selectedCountry.isoCode;
                        return ListTile(
                          leading: Text(
                            CountryDefaults.flagEmoji(country.isoCode),
                            style: const TextStyle(fontSize: 24),
                          ),
                          title: Text(
                            country.name ?? '',
                            style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: palette.textPrimary,
                            ),
                          ),
                          trailing: Text(
                            country.countryCode ?? '',
                            style: TextStyle(
                              color: isSelected
                                  ? palette.accent
                                  : palette.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          selected: isSelected,
                          selectedTileColor: isDark
                              ? palette.accent.withValues(alpha: 0.12)
                              : palette.accentMuted,
                          onTap: () {
                            onCountryChanged(country);
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: palette.surfaceMuted,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: errorText != null ? Colors.red : palette.border,
            ),
          ),
          child: Row(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _showCountryPicker(context),
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(14),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(color: palette.border),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          CountryDefaults.flagEmoji(selectedCountry.isoCode),
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          selectedCountry.countryCode ?? '+252',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: palette.textPrimary,
                            fontSize: 15,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: palette.textSecondary,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: TextStyle(
                    color: palette.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: '61XXXXXXX',
                    hintStyle: TextStyle(
                      color: palette.textSecondary.withValues(alpha: 0.7),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Text(
            errorText!,
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        ],
      ],
    );
  }
}
