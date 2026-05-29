import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  final Locale locale;
  final Color backgroundColor;
  final Color primaryColor;
  final Color secondaryColor;
  final Color textColor;
  final String emailAddress;
  final int jumpsBefore;
  final String licenseNumber;
  final String skydiversInfo;
  final String residenceCountry;

  const AppSettings({
    this.locale = const Locale('en'),
    this.backgroundColor = const Color(0xFF000000),
    this.primaryColor = const Color(0xFFF54927),
    this.secondaryColor = const Color(0xFF9E9E9E),
    this.textColor = const Color(0xFFF2F2F2),
    this.emailAddress = '',
    this.jumpsBefore = 0,
    this.licenseNumber = '',
    this.skydiversInfo = '',
    this.residenceCountry = '',
  });

  AppSettings copyWith({
    Locale? locale,
    Color? backgroundColor,
    Color? primaryColor,
    Color? secondaryColor,
    Color? textColor,
    String? emailAddress,
    int? jumpsBefore,
    String? licenseNumber,
    String? skydiversInfo,
    String? residenceCountry,
  }) =>
      AppSettings(
        locale: locale ?? this.locale,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        primaryColor: primaryColor ?? this.primaryColor,
        secondaryColor: secondaryColor ?? this.secondaryColor,
        textColor: textColor ?? this.textColor,
        emailAddress: emailAddress ?? this.emailAddress,
        jumpsBefore: jumpsBefore ?? this.jumpsBefore,
        licenseNumber: licenseNumber ?? this.licenseNumber,
        skydiversInfo: skydiversInfo ?? this.skydiversInfo,
        residenceCountry: residenceCountry ?? this.residenceCountry,
      );
}

class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier() : super(const AppSettings()) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = AppSettings(
      locale: Locale(prefs.getString('locale') ?? 'en'),
      backgroundColor: Color(prefs.getInt('bgColor') ?? 0xFF000000),
      primaryColor: Color(prefs.getInt('primaryColor') ?? 0xFFF54927),
      secondaryColor: Color(prefs.getInt('secondaryColor') ?? 0xFF9E9E9E),
      textColor: Color(prefs.getInt('textColor') ?? 0xFFF2F2F2),
      emailAddress: prefs.getString('emailAddress') ?? '',
      jumpsBefore: prefs.getInt('jumpsBefore') ?? 0,
      licenseNumber: prefs.getString('licenseNumber') ?? '',
      skydiversInfo: prefs.getString('skydiversInfo') ?? '',
      residenceCountry: prefs.getString('residenceCountry') ?? '',
    );
  }

  Future<void> setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale.languageCode);
    state = state.copyWith(locale: locale);
  }

  Future<void> setColors({Color? bg, Color? primary, Color? secondary, Color? text}) async {
    final prefs = await SharedPreferences.getInstance();
    if (bg != null) await prefs.setInt('bgColor', bg.toARGB32());
    if (primary != null) await prefs.setInt('primaryColor', primary.toARGB32());
    if (secondary != null) await prefs.setInt('secondaryColor', secondary.toARGB32());
    if (text != null) await prefs.setInt('textColor', text.toARGB32());
    state = state.copyWith(
      backgroundColor: bg,
      primaryColor: primary,
      secondaryColor: secondary,
      textColor: text,
    );
  }

  Future<void> resetTheme() async {
    await setColors(
      bg: const Color(0xFF000000),
      primary: const Color(0xFFF54927),
      secondary: const Color(0xFF9E9E9E),
      text: const Color(0xFFF2F2F2),
    );
  }

  Future<void> setEmailAddress(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('emailAddress', email);
    state = state.copyWith(emailAddress: email);
  }

  Future<void> setJumpsBefore(int n) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('jumpsBefore', n);
    state = state.copyWith(jumpsBefore: n);
  }

  Future<void> setLicenseNumber(String v) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('licenseNumber', v);
    state = state.copyWith(licenseNumber: v);
  }

  Future<void> setSkydiversInfo(String v) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('skydiversInfo', v);
    state = state.copyWith(skydiversInfo: v);
  }

  Future<void> setResidenceCountry(String v) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('residenceCountry', v);
    state = state.copyWith(residenceCountry: v);
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>(
  (_) => SettingsNotifier(),
);
