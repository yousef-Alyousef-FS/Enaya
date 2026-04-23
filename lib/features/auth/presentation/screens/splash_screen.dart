import 'package:enaya/core/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/services/token_manager.dart';
import '../../../../core/theme/app_colors.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Fade animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    // Scale animation
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutBack),
    );

    _fadeController.forward();
    _scaleController.forward();

    _navigateToNext();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // 1. Check Internet Connectivity
    final networkInfo = getIt<NetworkInfo>();
    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      if (mounted) {
        context.go('${AppRouter.noInternet}?next=${AppRouter.login}');
      }
      return;
    }

    // 2. Check Auto-Login
    final tokenManager = getIt<TokenManager>();
    final token = await tokenManager.getToken();
    final user = tokenManager.getUserData();

    if (token != null && token.isNotEmpty && user != null) {
      final role = UserRole.fromId(user['roleId'] ?? 3);
      final route = switch (role) {
        UserRole.receptionist => AppRouter.receptionistHome,
        UserRole.doctor => AppRouter.doctorHome,
        UserRole.patient => AppRouter.patientHome,
      };
      if (mounted) context.go(route);
      return;
    }

    if (mounted) {
      context.go(AppRouter.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const LogoIcon(width: 140, height: 140),
                const SizedBox(height: 24),
                SpinKitFadingCircle(
                  color: theme.colorScheme.primary,
                  size: 32,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
