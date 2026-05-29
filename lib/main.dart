import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parabook/l10n/app_localizations.dart';
import 'providers/settings_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const ProviderScope(child: ParaBookApp()));
}

class ParaBookApp extends ConsumerWidget {
  const ParaBookApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return MaterialApp(
      title: 'ParaBook',
      debugShowCheckedModeBanner: false,
      locale: settings.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('fr'), Locale('en')],
      theme: ThemeData(
        colorScheme: ColorScheme.dark(
          primary: settings.primaryColor,
          surface: settings.backgroundColor,
          onSurface: settings.textColor,
          onSurfaceVariant: settings.textColor,
        ),
        scaffoldBackgroundColor: settings.backgroundColor,
        appBarTheme: AppBarTheme(
          backgroundColor: settings.backgroundColor,
          foregroundColor: settings.textColor,
          elevation: 0,
        ),
        tabBarTheme: TabBarThemeData(
          labelColor: settings.primaryColor,
          unselectedLabelColor: settings.textColor.withAlpha(128),
          indicatorColor: settings.primaryColor,
        ),
        textTheme: TextTheme(
          displayLarge: TextStyle(color: settings.textColor),
          displayMedium: TextStyle(color: settings.textColor),
          displaySmall: TextStyle(color: settings.textColor),
          headlineLarge: TextStyle(color: settings.textColor),
          headlineMedium: TextStyle(color: settings.textColor),
          headlineSmall: TextStyle(color: settings.textColor),
          titleLarge: TextStyle(color: settings.textColor),
          titleMedium: TextStyle(color: settings.textColor),
          titleSmall: TextStyle(color: settings.textColor),
          bodyLarge: TextStyle(color: settings.textColor),
          bodyMedium: TextStyle(color: settings.textColor),
          bodySmall: TextStyle(color: settings.textColor),
          labelLarge: TextStyle(color: settings.textColor),
          labelMedium: TextStyle(color: settings.textColor),
          labelSmall: TextStyle(color: settings.textColor),
        ),
        iconTheme: IconThemeData(color: settings.textColor),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: settings.primaryColor,
          foregroundColor: Colors.white,
        ),
        cardTheme: CardThemeData(
          color: settings.backgroundColor.withAlpha(200),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: settings.primaryColor.withAlpha(60)),
          ),
        ),
        dividerColor: settings.textColor.withAlpha(40),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: settings.textColor.withAlpha(180)),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: settings.textColor.withAlpha(80)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: settings.primaryColor),
          ),
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
