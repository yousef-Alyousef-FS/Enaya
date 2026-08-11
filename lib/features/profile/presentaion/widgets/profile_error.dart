import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileErrorWidget extends StatelessWidget {
  final String message;

  const ProfileErrorWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message.tr(),
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
      ),
    );
  }
}
