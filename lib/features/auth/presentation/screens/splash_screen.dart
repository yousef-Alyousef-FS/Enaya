import 'package:enaya/features/auth/presentation/screens/login_screen.dart';

import '../widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/services/session_manager.dart';
import '../../../../core/services/token_manager.dart';
import '../../../../core/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
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
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    // Scale animation
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutBack),
    );

    _ambientController = AnimationController(
      duration: const Duration(milliseconds: 4200),
      vsync: this,
    );
    _ambientScaleAnimation = Tween<double>(begin: 0.90, end: 1.05).animate(
      CurvedAnimation(parent: _ambientController, curve: Curves.easeInOut),
    );

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

    final tokenManager = getIt<TokenManager>();
    final sessionManager = getIt<SessionManager>();

    final token = await tokenManager.getToken();
    final roleId = sessionManager.currentRoleId;

    if (token != null && token.isNotEmpty && roleId != null) {
      final role = UserRole.fromId(roleId);
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
    final subtitleColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.gray600;
    final cardColor = isDark
        ? AppColors.darkSurface.withAlpha(215)
        : Colors.white.withAlpha(235);
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
                    ? [
                        const Color(0xFF0A1022),
                        AppColors.darkBackground,
                        const Color(0xFF131A31),
                      ]
                    : [
                        const Color(0xFFF5F8FF),
                        const Color(0xFFEDF2FF),
                        const Color(0xFFF9FCFF),
                      ],
              ),
            ),
          ),
          Positioned(
            right: -100,
            top: -60,
            child: ScaleTransition(
              scale: _ambientScaleAnimation,
              child: _SplashOrb(
                size: 180,
                color: Theme.of(
                  context,
                ).colorScheme.primary.withAlpha(isDark ? 40 : 28),
              ),
            ),
          ),
          Positioned(
            left: -90,
            bottom: -70,
            child: ScaleTransition(
              scale: _ambientScaleAnimation,
              child: _SplashOrb(
                size: 160,
                color: Theme.of(
                  context,
                ).colorScheme.secondary.withAlpha(isDark ? 32 : 24),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 320),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.fromLTRB(24, 28, 24, 22),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: cardBorderColor, width: 1.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(isDark ? 35 : 16),
                            blurRadius: 24,
                            offset: const Offset(0, 14),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          LogoIcon(
                            width: 96,
                            height: 96,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'ENAYA',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: titleColor,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 2.6,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Healthcare Companion',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: subtitleColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
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
