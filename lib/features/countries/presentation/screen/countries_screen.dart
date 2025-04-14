import 'package:courier_app/features/branches/model/country_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/countries_bloc.dart';
import '../widget/countries_widget.dart';
import '../widget/add_country_modal.dart';

class CountriesScreen extends StatefulWidget {
  const CountriesScreen({super.key});

  @override
  State<CountriesScreen> createState() => _CountriesScreenState();
}

class _CountriesScreenState extends State<CountriesScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<CountryModel> _filteredCountries = [];

  @override
  void initState() {
    super.initState();
    _fetchCountries();
  }

  void _fetchCountries() {
    context.read<CountriesBloc>().add(FetchCountries());
  }

  void _handleSearch(String query) {
    final state = context.read<CountriesBloc>().state;
    if (state is FetchCountriesSuccess) {
      setState(() {
        _filteredCountries = state.countries.where((country) {
          final searchLower = query.toLowerCase();
          return (country.name?.toLowerCase().contains(searchLower) ?? false) ||
              (country.isoCode?.toLowerCase().contains(searchLower) ?? false) ||
              (country.countryCode?.toLowerCase().contains(searchLower) ??
                  false);
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5b3895),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 75, 23, 160),
        title: const Text('Countries'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  return Dialog(
                    insetPadding: const EdgeInsets.all(24),
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: const AddCountryModal(),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<CountriesBloc, CountriesState>(
        builder: (context, state) {
          if (state is FetchCountriesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FetchCountriesFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  ElevatedButton(
                    onPressed: _fetchCountries,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is FetchCountriesSuccess) {
            final countries =
                _filteredCountries.isEmpty && _searchController.text.isEmpty
                    ? state.countries
                    : _filteredCountries;

            return Column(
              children: [
                SearchBarWidget(
                  controller: _searchController,
                  onChanged: _handleSearch,
                ),
                Expanded(
                  child: CountriesTable(
                    countries: countries,
                  ),
                ),
              ],
            );
          }

          return const Center(child: Text('No data available'));
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
