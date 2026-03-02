import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resipal_admin/admin_session_service.dart';
import 'package:resipal_admin/presentation/shared/colors/app_colors.dart';
import 'package:resipal_admin/presentation/auth/auth_page.dart';
import 'package:resipal_core/lib.dart';
import 'package:short_navigation/short_navigation.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // Setup Supabase
  final supabaseConfig = ResipalSupabaseConfig(
    url: dotenv.get('SUPABASE_URL'),
    anonKey: dotenv.get('SUPABASE_ANON_KEY'),
  );
  GetIt.instance.registerSingleton<ResipalSupabaseConfig>(supabaseConfig);

  // Setup Auth Config
  final authConfig = AuthServiceConfig(
    iosClientId: dotenv.get('GOOGLE_OAUTH_IOS_CLIENT_ID'),
    serverClientId: dotenv.get('GOOGLE_OAUTH_SERVER_CLIENT_ID'),
  );
  GetIt.instance.registerSingleton<AuthServiceConfig>(authConfig);

  await ServiceLocator().initializeContainers();
  GetIt.instance.registerSingleton<AdminSessionService>(AdminSessionService());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: Go.navigatorKey,
      title: 'Resipal - Administrator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          // --- Brand ---
          primary: AppColors.primary700,
          onPrimary: Colors.white,
          primaryContainer: AppColors.primary100,
          onPrimaryContainer: AppColors.primary900,

          // --- Secondary (Terracotta) ---
          secondary: AppColors.secondary500,
          onSecondary: Colors.white,
          secondaryContainer: AppColors.secondary100,
          onSecondaryContainer: AppColors.secondary900,

          // --- Surfaces ---
          surface: AppColors.surface,
          onSurface: AppColors.textPrimary,
          background: AppColors.background,
          onBackground: AppColors.textPrimary,

          // --- Feedback ---
          error: AppColors.danger,
          onError: Colors.white,

          // --- Neutral / Outline ---
          outline: AppColors.grey300,
          outlineVariant: AppColors.grey200,

          // --- Additional mapping ---
          tertiary: AppColors.info,
        ),
        appBarTheme: AppBarTheme(backgroundColor: AppColors.background),
        scaffoldBackgroundColor: AppColors.background,
        textTheme: TextTheme(
          // HEADINGS (TÍTULOS)
          displayLarge: GoogleFonts.raleway(
            fontSize: 48,
            height: 54 / 48,
            fontWeight: FontWeight.w700, // GIGA
          ),
          headlineLarge: GoogleFonts.raleway(
            fontSize: 32,
            height: 40 / 32,
            fontWeight: FontWeight.bold, // H1
          ),
          headlineMedium: GoogleFonts.raleway(
            fontSize: 24,
            height: 32 / 24,
            fontWeight: FontWeight.bold, // H2
          ),
          headlineSmall: GoogleFonts.raleway(
            fontSize: 20,
            height: 28 / 20,
            fontWeight: FontWeight.bold, // H3
          ),
          titleLarge: GoogleFonts.raleway(
            fontSize: 18,
            height: 24 / 18,
            fontWeight: FontWeight.bold, // H4
          ),
          titleMedium: GoogleFonts.raleway(
            fontSize: 16,
            height: 20 / 16,
            fontWeight: FontWeight.bold, // H5
          ),
          titleSmall: GoogleFonts.raleway(
            fontSize: 14,
            height: 16 / 14,
            fontWeight: FontWeight.bold, // H6
          ),

          // BODY (CUERPO DE TEXTO)
          bodyLarge: GoogleFonts.raleway(
            fontSize: 18,
            height: 28 / 18,
            fontWeight: FontWeight.normal, // Body Parrafo 01
          ),
          bodyMedium: GoogleFonts.raleway(
            fontSize: 16,
            height: 24 / 16,
            fontWeight: FontWeight.normal, // Body Parrafo 02
          ),
          bodySmall: GoogleFonts.raleway(
            fontSize: 14,
            height: 20 / 14,
            fontWeight: FontWeight.normal, // Body Parrafo 03
          ),
          labelSmall: GoogleFonts.poppins(
            // Caption / Tiny
            fontSize: 12,
            height: 16 / 12,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      home: const AuthPage(),
    );
  }
}
