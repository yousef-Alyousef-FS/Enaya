import 'dart:math' as math;

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

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<AuthViewModel>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Account'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => context.pop(),
          ),
        ),
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
                  ? 30.h
                  : (isCompactHeight ? 18.h : 22.h);
              final scrollVerticalPadding = isPortrait
                  ? 20.h
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
                            AppColors.primary.withAlpha(36),
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
                                Text(
                                  'Join Enaya',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayLarge
                                      ?.copyWith(fontSize: titleFontSize),
                                ),
                                SizedBox(height: isPortrait ? 10.h : 8.h),
                                Text(
                                  'Create your account to start managing patients, appointments and staff.',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(fontSize: bodyFontSize),
                                ),
                                SizedBox(height: isPortrait ? 32.h : 24.h),
                                AuthTextField(
                                  hintText: 'Full Name',
                                  controller: _userNameController,
                                  prefixIcon: Icons.person_outline,
                                  validator: (value) =>
                                      value!.isEmpty ? 'Enter your name' : null,
                                ),
                                SizedBox(height: isPortrait ? 16.h : 12.h),
                                AuthTextField(
                                  hintText: 'Email Address',
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  prefixIcon: Icons.email_outlined,
                                  validator: (value) => !value!.contains('@')
                                      ? 'Enter a valid email'
                                      : null,
                                ),
                                SizedBox(height: isPortrait ? 16.h : 12.h),
                                AuthTextField(
                                  hintText: 'Phone Number',
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  prefixIcon: Icons.phone_outlined,
                                  validator: (value) => value!.isEmpty
                                      ? 'Enter phone number'
                                      : null,
                                ),
                                SizedBox(height: isPortrait ? 16.h : 12.h),
                                AuthTextField(
                                  hintText: 'Password',
                                  controller: _passwordController,
                                  isPassword: true,
                                  prefixIcon: Icons.lock_outline,
                                  validator: (value) => value!.length < 6
                                      ? 'Password too short'
                                      : null,
                                ),
                                SizedBox(height: isPortrait ? 30.h : 22.h),
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
                                            context.go(AppRouter.login);
                                          });
                                    }

                                    return ElevatedButton(
                                      onPressed: viewModel.isLoading
                                          ? null
                                          : () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                viewModel.signup(
                                                  _emailController.text,
                                                  _passwordController.text,
                                                  _userNameController.text,
                                                  _phoneController.text,
                                                );
                                              }
                                            },
                                      child: viewModel.isLoading
                                          ? AppLoaders.buttonLoader()
                                          : const Text('Sign Up'),
                                    );
                                  },
                                ),
                                SizedBox(height: isPortrait ? 20.h : 14.h),
                                Center(
                                  child: Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    alignment: WrapAlignment.center,
                                    children: [
                                      Text(
                                        'Already have an account? ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(fontSize: bodyFontSize),
                                      ),
                                      TextButton(
                                        onPressed: () => context.pop(),
                                        child: Text(
                                          'Login',
                                          style: TextStyle(
                                            color: const Color.fromRGBO(108, 99, 255, 1),
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
