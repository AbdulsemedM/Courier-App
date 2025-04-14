import 'package:courier_app/core/theme/theme_provider.dart';
import 'package:courier_app/features/miles_configuration/presentation/widgets/miles_configuration_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../bloc/miles_configuration_bloc.dart';

class MilesConfigurationScreen extends StatefulWidget {
  const MilesConfigurationScreen({super.key});

  @override
  State<MilesConfigurationScreen> createState() =>
      _MilesConfigurationScreenState();
}

class _MilesConfigurationScreenState extends State<MilesConfigurationScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MilesConfigurationBloc>().add(FetchMilesConfiguration());
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode
          ? const Color.fromARGB(255, 75, 23, 160)
          : const Color.fromARGB(255, 75, 23, 160),
      appBar: AppBar(
        backgroundColor: isDarkMode
          ? const Color.fromARGB(255, 75, 23, 160)
          : const Color.fromARGB(255, 75, 23, 160),
        title: const Text('Miles Configuration'),
      ),
      body: BlocBuilder<MilesConfigurationBloc, MilesConfigurationState>(
        builder: (context, state) {
          if (state is MilesConfigurationLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MilesConfigurationSuccess) {
            return MilesConfigurationWidgets.buildMilesConfigurationTable(
              isDarkMode: isDarkMode,
              configurations: state.milesConfigurations,
              onAddConfig: () =>
                  MilesConfigurationWidgets.showAddMilesConfigModal(context),
            );
          }

          return const Center(child: Text('Failed to load configurations'));
        },
      ),
    );
  }
}
