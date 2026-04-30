import 'package:enaya/core/widgets/common/logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
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

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _ambientController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _ambientScaleAnimation;

  @override
  void initState() {
    super.initState();

    // Fade animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);

    // Scale animation
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _scaleController, curve: Curves.easeOutBack));

    _ambientController = AnimationController(
      duration: const Duration(milliseconds: 2800),
      vsync: this,
    );
    _ambientScaleAnimation = Tween<double>(
      begin: 0.96,
      end: 1.06,
    ).animate(CurvedAnimation(parent: _ambientController, curve: Curves.easeInOut));

    _fadeController.forward();
    _scaleController.forward();
    _ambientController.repeat(reverse: true);

    _navigateToNext();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _ambientController.dispose();
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
    final titleColor = isDark ? AppColors.darkTextPrimary : AppColors.secondary;
    final subtitleColor = isDark ? AppColors.darkTextSecondary : AppColors.gray600;
    final cardColor = isDark ? AppColors.darkSurface.withAlpha(215) : Colors.white.withAlpha(235);
    final cardBorderColor = isDark
        ? AppColors.gray700.withAlpha(120)
        : AppColors.gray200.withAlpha(180);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [const Color(0xFF0A1022), AppColors.darkBackground, const Color(0xFF131A31)]
                    : [const Color(0xFFF5F8FF), const Color(0xFFEDF2FF), const Color(0xFFF9FCFF)],
              ),
            ),
          ),
          Positioned(
            right: -80,
            top: -40,
            child: ScaleTransition(
              scale: _ambientScaleAnimation,
              child: _SplashOrb(size: 220, color: AppColors.primary.withAlpha(isDark ? 55 : 40)),
            ),
          ),
          Positioned(
            left: -70,
            bottom: -50,
            child: ScaleTransition(
              scale: _ambientScaleAnimation,
              child: _SplashOrb(size: 200, color: AppColors.accent.withAlpha(isDark ? 45 : 32)),
            ),
          ),
          SafeArea(
            child: Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 340),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.fromLTRB(28, 32, 28, 24),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: cardBorderColor, width: 1.2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(isDark ? 35 : 16),
                            blurRadius: 28,
                            offset: const Offset(0, 16),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          LogoIcon(
                            width: 120,
                            height: 120,
                            color: isDark ? AppColors.primaryLight : AppColors.primary,
                          ),
                          const SizedBox(height: 18),
                          Text(
                            'ENAYA',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: titleColor,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 3.0,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Healthcare Companion',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: subtitleColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 24),
                          SpinKitFadingCircle(color: theme.colorScheme.primary, size: 28),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SplashOrb extends StatelessWidget {
  final double size;
  final Color color;

  const _SplashOrb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, color.withAlpha(0)]),
      ),
    );
  }
}
