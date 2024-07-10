import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io' show Platform;
import 'package:permission_handler/permission_handler.dart';
import 'package:water_tanker_worker/blocs/home_bloc.dart';
import 'package:water_tanker_worker/blocs/navigation_bloc.dart';
import 'package:water_tanker_worker/blocs/order_bloc.dart';
import 'package:water_tanker_worker/blocs/track_bloc.dart';
import 'package:water_tanker_worker/events/order_event.dart';
import 'package:water_tanker_worker/firebase_options.dart';
import 'package:water_tanker_worker/screens/main_screen.dart';
import 'package:water_tanker_worker/states/theme_state.dart';

import 'blocs/theme_bloc.dart';
import 'events/theme_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        BlocProvider(create: (_) => ThemeBloc()..add(LoadThemeEvent())),
        BlocProvider(create: (_) => HomeBloc()),
        BlocProvider(create: (_) => OrdersBloc()..add(FetchAssignedOrdersEvent())),
        BlocProvider(create: (_) => TrackOrderBloc()),
        BlocProvider(create: (_) => NavigationBloc()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    if (Platform.isAndroid || Platform.isIOS) {
      await Permission.location.request();
    } else {
      await Geolocator.requestPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(builder: (context, state) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: _buildLightTheme(),
        darkTheme: _buildDarkTheme(),
        themeMode: state.themeMode,
        home: const MainScreen(),
      );
    });
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blueAccent,
        primary: Colors.blueAccent,
        onPrimary: Colors.white,
        secondary: Colors.blue,
        onSecondary: Colors.white,
        surface: Colors.white,
        onSurface: Colors.black,
        error: Colors.red,
        onError: Colors.white,
      ),
      hintColor: Colors.blueAccent,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: Colors.blueAccent),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent)),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blueAccent,
        primary: Colors.blueAccent,
        onPrimary: Colors.white,
        secondary: Colors.blue,
        onSecondary: Colors.white,
        surface: Colors.black,
        onSurface: Colors.white,
        error: Colors.red,
        onError: Colors.white,
      ),
      hintColor: Colors.blueAccent,
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: Colors.blueAccent),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent)),
      ),
    );
  }
}
