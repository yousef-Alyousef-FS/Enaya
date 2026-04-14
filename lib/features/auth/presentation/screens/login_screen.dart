import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/view_models/base_view_model.dart';
import '../../../../core/widgets/app_dialogs.dart';
import '../../../../core/widgets/app_loaders.dart';
import '../state/auth_view_model.dart';
import '../widgets/auth_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<AuthViewModel>(),
      child: Scaffold(
        body: SafeArea(
          child: OrientationBuilder(
            builder: (context, orientation) {
              final media = MediaQuery.of(context);
              final isPortrait = orientation == Orientation.portrait;
              final screenWidth = media.size.width;
              final screenHeight = media.size.height;
              final isCompactHeight = screenHeight < 620;
              final cardMaxWidth = math.min(
                isPortrait ? 520.w : 600.w,
                screenWidth * (isPortrait ? 0.94 : 0.88),
              );
              final cardHorizontalPadding = isPortrait ? 24.w : 20.w;
              final cardVerticalPadding = isPortrait
                  ? 32.h
                  : (isCompactHeight ? 18.h : 22.h);
              final scrollVerticalPadding = isPortrait
                  ? 28.h
                  : (isCompactHeight ? 12.h : 16.h);
              double responsiveFontSize({
                required double small,
                required double medium,
                required double large,
              }) {
                if (screenWidth >= 900) return large;
                if (screenWidth >= 700) return medium;
                return small;
              }

              final titleFontSize = responsiveFontSize(
                small: 26,
                medium: 28,
                large: 32,
              );
              final bodyFontSize = responsiveFontSize(
                small: 14,
                medium: 15,
                large: 16,
              );
              final buttonFontSize = responsiveFontSize(
                small: 14,
                medium: 15,
                large: 16,
              );
              return Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.primary.withAlpha(41),
                            Theme.of(context).scaffoldBackgroundColor,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: cardMaxWidth),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: cardHorizontalPadding,
                          vertical: scrollVerticalPadding,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(
                              isPortrait ? 28.r : 20.r,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(15),
                                blurRadius: 26,
                                offset: const Offset(0, 16),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: cardHorizontalPadding,
                            vertical: cardVerticalPadding,
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  width: isPortrait ? 72.w : 56.w,
                                  height: isPortrait ? 72.w : 56.w,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withAlpha(35),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.medical_services_outlined,
                                    size: isPortrait ? 36.sp : 28.sp,
                                    color: AppColors.primary,
                                  ),
                                ),
                                SizedBox(height: isPortrait ? 22.h : 16.h),
                                Text(
                                  'welcome_back'.tr(),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayLarge
                                      ?.copyWith(fontSize: 26),
                                ),
                                SizedBox(height: isPortrait ? 10.h : 8.h),
                                Text(
                                  'login_description'.tr(),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(fontSize: bodyFontSize),
                                ),
                                SizedBox(height: isPortrait ? 30.h : 20.h),
                                AuthTextField(
                                  hintText: 'username_or_email'.tr(),
                                  controller: _emailController,
                                  prefixIcon: Icons.person_outline,
                                  validator: (value) => value!.isEmpty
                                      ? 'enter_username_or_email'.tr()
                                      : null,
                                ),
                                SizedBox(height: isPortrait ? 18.h : 12.h),
                                AuthTextField(
                                  hintText: 'password'.tr(),
                                  controller: _passwordController,
                                  prefixIcon: Icons.lock_outline,
                                  isPassword: true,
                                  validator: (value) => value!.isEmpty
                                      ? 'enter_password'.tr()
                                      : null,
                                ),
                                SizedBox(height: isPortrait ? 10.h : 8.h),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      'forgot_password'.tr(),
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: buttonFontSize,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: isPortrait ? 18.h : 12.h),
                                Consumer<AuthViewModel>(
                                  builder: (context, viewModel, child) {
                                    if (viewModel.state == ViewState.error) {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                            AppDialogs.showError(
                                              context,
                                              message:
                                                  viewModel.errorMessage ??
                                                  'Error',
                                            );
                                            viewModel.resetState();
                                          });
                                    }

                                    if (viewModel.state == ViewState.success) {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                            final user = viewModel.currentUser;
                                            if (user != null) {
                                              String route;
                                              switch (user.roleId) {
                                                case 1: // Admin
                                                case 3: // Nurse/Receptionist
                                                  route = AppRouter
                                                      .receptionistHome;
                                                  break;
                                                case 2: // Doctor
                                                  route = AppRouter.doctorHome;
                                                  break;
                                                case 4: // Patient
                                                  route = AppRouter.patientHome;
                                                  break;
                                                default:
                                                  route = AppRouter
                                                      .patientHome; // Default
                                              }
                                              context.go(route);
                                            }
                                          });
                                    }

                                    return ElevatedButton(
                                      onPressed: viewModel.isLoading
                                          ? null
                                          : () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                viewModel.login(
                                                  _emailController.text,
                                                  _passwordController.text,
                                                );
                                              }
                                            },
                                      child: viewModel.isLoading
                                          ? AppLoaders.buttonLoader()
                                          : const Text('Login'),
                                    );
                                  },
                                ),
                                SizedBox(height: isPortrait ? 24.h : 16.h),
                                Center(
                                  child: Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    alignment: WrapAlignment.center,
                                    children: [
                                      Text(
                                        'dont_have_account'.tr(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              fontSize: buttonFontSize,
                                            ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          GoRouter.of(
                                            context,
                                          ).push(AppRouter.signup);
                                        },
                                        child: Text(
                                          'sign_up'.tr(),
                                          style: TextStyle(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: buttonFontSize,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
