import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/mixins/responsive_layout_mixin.dart';
import '../../../../core/view_models/base_view_model.dart';
import '../../../../core/widgets/app_loaders.dart';
import '../../../../core/widgets/auth_card_container.dart';
import '../state/auth_view_model.dart';
import '../widgets/auth_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with ResponsiveLayoutMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  String? _message;
  bool _isSuccess = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<AuthViewModel>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('forgot_password'.tr()),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => context.pop(),
          ),
        ),
        body: SafeArea(
          child: OrientationBuilder(
            builder: (context, _) {
              final config = getResponsiveConfig(context);

              return AuthCardContainer(
                config: config,
                gradientAlpha: 41,
                children: [
                  Text(
                    'reset_password'.tr(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: config.titleFontSize,
                    ),
                  ),
                  SizedBox(height: config.isPortrait ? 10.h : 8.h),
                  Text(
                    'enter_email_reset'.tr(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: config.bodyFontSize,
                    ),
                  ),
                  SizedBox(height: config.isPortrait ? 30.h : 20.h),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        AuthTextField(
                          labelText: 'email_address'.tr(),
                          hintText: 'email_address'.tr(),
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.email_outlined,
                          semanticLabel: 'email_address'.tr(),
                          validator: (value) => !value!.contains('@')
                              ? 'enter_valid_email'.tr()
                              : null,
                        ),
                        SizedBox(height: config.isPortrait ? 18.h : 12.h),
                        Consumer<AuthViewModel>(
                          builder: (context, viewModel, child) {
                            if (viewModel.state == ViewState.error) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                setState(() {
                                  _isSuccess = false;
                                  _message = viewModel.errorMessage ??
                                      'error_occurred'.tr();
                                });
                                viewModel.resetState();
                              });
                            }

                            if (viewModel.state == ViewState.success) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                setState(() {
                                  _isSuccess = true;
                                  _message = 'reset_email_sent'.tr();
                                });
                                viewModel.resetState();
                              });
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ElevatedButton(
                                  onPressed: viewModel.isLoading
                                      ? null
                                      : () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            setState(() {
                                              _message = null;
                                            });
                                            viewModel.forgotPassword(
                                              _emailController.text,
                                            );
                                          }
                                        },
                                  child: viewModel.isLoading
                                      ? AppLoaders.buttonLoader()
                                      : Text(
                                          'send_reset_link'.tr(),
                                          style: TextStyle(
                                            fontSize: config.buttonFontSize,
                                          ),
                                        ),
                                ),
                                if (_message != null)
                                  Padding(
                                    padding: EdgeInsets.only(top: 8.h),
                                    child: Text(
                                      _message!,
                                      style: TextStyle(
                                        color: _isSuccess
                                            ? Colors.green
                                            : Theme.of(context)
                                                .colorScheme
                                                .error,
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ],
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
