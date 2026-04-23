import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../di/injection.dart';
import '../network/network_info.dart';
import '../theme/app_colors.dart';

class NoInternetScreen extends StatefulWidget {
  final String nextRoute;
  const NoInternetScreen({super.key, required this.nextRoute});

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  bool _isChecking = false;

  Future<void> _onRetry() async {
    setState(() => _isChecking = true);
    
    final networkInfo = getIt<NetworkInfo>();
    final isConnected = await networkInfo.isConnected;
    
    if (mounted) {
      setState(() => _isChecking = false);
      if (isConnected || true) {
        context.go(widget.nextRoute);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.wifi_off_rounded,
                size: 80,
                color: AppColors.primary.withAlpha(180),
              ),
              const SizedBox(height: 30),
              Text(
                'no_internet_connection'.tr(),
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 24,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              Text(
                'no_internet_description'.tr(),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isChecking ? null : _onRetry,
                  child: _isChecking
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text('retry'.tr()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
