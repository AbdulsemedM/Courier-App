import 'package:courier_app/features/login/presentation/screen/login_screen.dart';
import 'package:courier_app/features/track_order/bloc/track_order_bloc.dart';
import 'package:courier_app/features/track_order/data/data_provider/track_order_data_provider.dart';
import 'package:courier_app/features/track_order/data/repository/track_order_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'core/theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required for SharedPreferences
  runApp(MultiProvider(providers: [
    BlocProvider(
        create: (context) =>
            TrackOrderBloc(TrackOrderRepository(TrackOrderDataProvider()))),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Courier App',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.currentTheme,
            home: const LoginScreen(),
          );
        },
      ),
    );
  }
}
