import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Light Color Scheme (Farmer Friendly)
const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF558B2F), // Darker, more natural green
  onPrimary: Colors.white,
  primaryContainer: Color(0xFFDCEDC8), // Lighter, softer green for containers
  onPrimaryContainer: Color(0xFF00210A),
  secondary: Color(0xFFAED581), // Brighter green for secondary actions
  onSecondary: Colors.white,
  secondaryContainer: Color(0xFFE8F5E9),
  onSecondaryContainer: Color(0xFF0C240E),
  tertiary: Color(0xFF8BC34A), // Another shade of green
  onTertiary: Colors.white,
  tertiaryContainer: Color(0xFFDCEFD9),
  onTertiaryContainer: Color(0xFF0C1F0C),
  error: Color(0xFFBA1A1A),
  onError: Colors.white,
  errorContainer: Color(0xFFFFDAD6),
  onErrorContainer: Color(0xFF410002),
  surface: Color(0xFFFFFDE7), // This was the original surface, which will now implicitly serve as the "background"
  onSurface: Color(0xFF333333), // This was the original onSurface, used for text
  surfaceContainerHighest: Color(0xFFE0E0D5), // Replacement for surfaceVariant
  onSurfaceVariant: Color(0xFF434940),
  outline: Color(0xFF73796F),
  onInverseSurface: Color(0xFFF0F2F5),
  inverseSurface: Color(0xFF303130),
  inversePrimary: Color(0xFFACD1AD),
  shadow: Colors.black,
  surfaceTint: Color(0xFF558B2F),
  outlineVariant: Color(0xFFC3C8BE),
  scrim: Colors.black,
);

// Dark Color Scheme (Farmer Friendly)
const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF8BC34A), // Muted, darker green for primary actions in dark mode
  onPrimary: Color(0xFF083915),
  primaryContainer: Color(0xFF215227),
  onPrimaryContainer: Color(0xFFC8E6C9),
  secondary: Color(0xFFAED581),
  onSecondary: Color(0xFF203521),
  secondaryContainer: Color(0xFF364C37),
  onSecondaryContainer: Color(0xFFE8F5E9),
  tertiary: Color(0xFFBEDFBB),
  onTertiary: Color(0xFF203521),
  tertiaryContainer: Color(0xFF364C37),
  onTertiaryContainer: Color(0xFFDCEFD9),
  error: Color(0xFFFFB4AB),
  onError: Color(0xFF690005),
  errorContainer: Color(0xFF93000A),
  onErrorContainer: Color(0xFFFFDAD6),
  surface: Color(0xFF384236), // This was the original surface, which will now implicitly serve as the "background"
  onSurface: Color(0xFFE0E0E0), // This was the original onSurface, used for text
  surfaceContainerHighest: Color(0xFF434940),
  onSurfaceVariant: Color(0xFFC3C8BE),
  outline: Color(0xFF8D9388),
  onInverseSurface: Color(0xFF1B1C1B),
  inverseSurface: Color(0xFFE3E3DF),
  inversePrimary: Color(0xFF558B2F),
  shadow: Colors.black,
  surfaceTint: Color(0xFF8BC34A),
  outlineVariant: Color(0xFF434940),
  scrim: Colors.black,
);

// Light Theme Data
final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: lightColorScheme,
  scaffoldBackgroundColor: lightColorScheme.surface,
  textTheme: GoogleFonts.montserratTextTheme(ThemeData.light().textTheme).apply(
    bodyColor: lightColorScheme.onSurface,
    displayColor: lightColorScheme.onSurface,
  ), // Use Montserrat for text theme

  appBarTheme: AppBarTheme(
    backgroundColor: lightColorScheme.surface,
    foregroundColor: lightColorScheme.onSurface,
    elevation: 2,
    centerTitle: false,
    titleTextStyle: GoogleFonts.montserrat(
      color: lightColorScheme.onSurface,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: lightColorScheme.surfaceContainerHighest.withAlpha((255 * 0.4).round()),
    contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: lightColorScheme.primary, width: 2.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: lightColorScheme.error, width: 2.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: lightColorScheme.error, width: 2.0),
    ),
    labelStyle: TextStyle(color: lightColorScheme.onSurfaceVariant),
    hintStyle: TextStyle(color: lightColorScheme.onSurfaceVariant.withAlpha((255 * 0.6).round())),
  ),

  cardTheme: CardThemeData(
    color: lightColorScheme.surface,
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: lightColorScheme.primary,
      foregroundColor: lightColorScheme.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      textStyle: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.bold), // Use Montserrat for button text
      elevation: 4,
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: lightColorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      textStyle: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.bold), // Use Montserrat for text button text
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: lightColorScheme.secondary,
    unselectedItemColor: lightColorScheme.onSurfaceVariant,
    backgroundColor: lightColorScheme.surface,
    elevation: 8,
    type: BottomNavigationBarType.fixed,
    showUnselectedLabels: true,
  ),
);

// Dark Theme Data
final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: darkColorScheme,
  scaffoldBackgroundColor: darkColorScheme.surface,
  textTheme: GoogleFonts.montserratTextTheme(ThemeData.dark().textTheme).apply(
    bodyColor: darkColorScheme.onSurface,
    displayColor: darkColorScheme.onSurface,
  ), // Use Montserrat for text theme

  appBarTheme: AppBarTheme(
    backgroundColor: darkColorScheme.surface,
    foregroundColor: darkColorScheme.onSurface,
    elevation: 2,
    centerTitle: false,
    titleTextStyle: GoogleFonts.montserrat(
      color: darkColorScheme.onSurface,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: darkColorScheme.surfaceContainerHighest.withAlpha((255 * 0.2).round()),
    contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: darkColorScheme.primary, width: 2.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: darkColorScheme.error, width: 2.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: darkColorScheme.error, width: 2.0),
    ),
    labelStyle: TextStyle(color: darkColorScheme.onSurfaceVariant),
    hintStyle: TextStyle(color: darkColorScheme.onSurfaceVariant.withAlpha((255 * 0.6).round())),
  ),

  cardTheme: CardThemeData(
    color: darkColorScheme.surface,
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: darkColorScheme.primary,
      foregroundColor: darkColorScheme.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      textStyle: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.bold), // Use Montserrat for button text
      elevation: 4,
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: darkColorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      textStyle: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.bold), // Use Montserrat for text button text
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: darkColorScheme.secondary,
    unselectedItemColor: darkColorScheme.onSurfaceVariant,
    backgroundColor: darkColorScheme.surface,
    elevation: 8,
    type: BottomNavigationBarType.fixed,
    showUnselectedLabels: true,
  ),
);
